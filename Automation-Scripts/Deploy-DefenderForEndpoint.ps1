<#
.SYNOPSIS
    Deploy Microsoft Defender for Endpoint via Intune Endpoint Security (Native).

.DESCRIPTION
    Configures Microsoft Defender for Endpoint using native Endpoint Security policies.
    Part of the Strategic Integration Framework for SMB Security - Module 2: Endpoint Protection.

    Uses Security Baselines and securityTemplate intents for native deployment.
    Policies appear in: Endpoint security blade (not Device Configuration)

.PARAMETER DeploymentScope
    Scope of deployment: "AllDevices" (recommended), "PilotGroup" (test first)

.PARAMETER PilotGroupName
    Azure AD group name for pilot deployment (required if DeploymentScope is "PilotGroup")

.EXAMPLE
    .\Deploy-DefenderForEndpoint.ps1 -DeploymentScope "AllDevices"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("AllDevices", "PilotGroup")]
    [string]$DeploymentScope,

    [Parameter(Mandatory = $false)]
    [string]$PilotGroupName
)

#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Groups

if ($DeploymentScope -eq "PilotGroup" -and [string]::IsNullOrEmpty($PilotGroupName)) {
    Write-Error "PilotGroupName is required when DeploymentScope is 'PilotGroup'"
    exit 1
}

# Initialize logging
$LogFile = "Defender-Endpoint-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Microsoft Defender for Endpoint Deployment Started ===" "INFO"
Write-Log "Deployment Scope: $DeploymentScope" "INFO"
Write-Log "Using: Native Endpoint Security Policies" "INFO"

# ============================================
# Connect to Microsoft Graph
# ============================================

try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes @(
        "DeviceManagementConfiguration.ReadWrite.All",
        "DeviceManagementManagedDevices.ReadWrite.All",
        "Group.Read.All"
    ) -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    exit 1
}

# Get Target Group
$TargetGroupId = $null
if ($DeploymentScope -eq "PilotGroup") {
    $Group = Get-MgGroup -Filter "displayName eq '$PilotGroupName'" -ErrorAction SilentlyContinue
    if ($Group) {
        $TargetGroupId = $Group.Id
        Write-Log "Found pilot group ID: $TargetGroupId" "INFO"
    } else {
        $NewGroup = New-MgGroup -DisplayName $PilotGroupName -MailEnabled:$false -MailNickname ($PilotGroupName -replace " ","") -SecurityEnabled:$true
        $TargetGroupId = $NewGroup.Id
        Write-Log "Created pilot group with ID: $TargetGroupId" "INFO"
    }
}

$CreatedPolicies = @()
$FailedPolicies = @()

# ============================================
# Helper: Create Policy from Template using createInstance
# ============================================

# Note: The createInstance endpoint is the correct way to create
# Endpoint Security policies from templates with default settings.

function New-EndpointSecurityPolicy {
    param(
        [string]$PolicyName,
        [string]$Description,
        [string]$TemplateId,
        [string]$Scope,
        [string]$GroupId
    )

    Write-Log "Creating policy from template using createInstance: $TemplateId" "INFO"

    # Use createInstance endpoint - this creates the policy with template defaults
    $CreateBody = @{
        displayName = $PolicyName
        description = $Description
    }

    # Create the policy instance from template
    $NewPolicy = Invoke-MgGraphRequest -Method POST `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/templates/$TemplateId/createInstance" `
        -Body ($CreateBody | ConvertTo-Json -Depth 10) `
        -ContentType "application/json" `
        -ErrorAction Stop

    Write-Log "Policy created - ID: $($NewPolicy.id)" "INFO"

    # Wait for policy to be ready
    Start-Sleep -Seconds 3

    # Assign policy
    $AssignmentBody = if ($Scope -eq "AllDevices") {
        @{
            assignments = @(
                @{
                    target = @{
                        "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                    }
                }
            )
        }
    } else {
        @{
            assignments = @(
                @{
                    target = @{
                        "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                        groupId = $GroupId
                    }
                }
            )
        }
    }

    Invoke-MgGraphRequest -Method POST `
        -Uri "https://graph.microsoft.com/beta/deviceManagement/intents/$($NewPolicy.id)/assign" `
        -Body ($AssignmentBody | ConvertTo-Json -Depth 10) `
        -ContentType "application/json" `
        -ErrorAction Stop

    Write-Log "Policy assigned to $Scope" "INFO"

    return $NewPolicy
}

# ============================================
# Get Available Templates
# ============================================

Write-Log "" "INFO"
Write-Log "=== Fetching Endpoint Security Templates ===" "INFO"

$AllTemplates = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/templates" `
    -ErrorAction Stop

# Filter for security-related templates (include all types for AV and Firewall)
$SecurityTemplates = $AllTemplates.value | Where-Object {
    $_.templateType -eq "securityTemplate" -or
    $_.templateType -eq "advancedThreatProtectionSecurityBaseline" -or
    $_.templateType -eq "securityBaseline" -or
    $_.templateType -eq "cloudPC" -or
    $_.templateSubtype -eq "antivirus" -or
    $_.templateSubtype -eq "firewall"
}

Write-Log "Found $($SecurityTemplates.Count) security templates:" "INFO"
foreach ($t in $SecurityTemplates) {
    $subtype = if ($t.templateSubtype) { $t.templateSubtype } else { "N/A" }
    Write-Log "  - $($t.displayName) [Type: $($t.templateType), Subtype: $subtype]" "INFO"
}

# ============================================
# 1. Microsoft Defender for Endpoint Baseline
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating Defender for Endpoint Baseline ===" "INFO"

$DefenderBaselineName = "Defender for Endpoint Baseline - SMB"

# Check if exists
$ExistingBaseline = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/intents?`$filter=displayName eq '$DefenderBaselineName'" `
    -ErrorAction SilentlyContinue

if ($ExistingBaseline.value.Count -gt 0) {
    Write-Log "Policy '$DefenderBaselineName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $DefenderBaselineName; Reason = "Already exists"; Location = "Endpoint Security > Security baselines" }
} else {
    # Find Defender ATP baseline template (check multiple naming patterns)
    $DefenderTemplate = $SecurityTemplates | Where-Object {
        $_.displayName -like "*Defender for Endpoint*" -or
        $_.displayName -like "*Microsoft Defender ATP*" -or
        $_.displayName -like "*Defender ATP*" -or
        $_.templateType -eq "advancedThreatProtectionSecurityBaseline"
    } | Sort-Object -Property publishedDateTime -Descending | Select-Object -First 1

    if ($DefenderTemplate) {
        try {
            $NewPolicy = New-EndpointSecurityPolicy `
                -PolicyName $DefenderBaselineName `
                -Description "Microsoft Defender for Endpoint security baseline for SMB. Includes recommended security settings." `
                -TemplateId $DefenderTemplate.id `
                -Scope $DeploymentScope `
                -GroupId $TargetGroupId

            $CreatedPolicies += @{
                Name = $DefenderBaselineName
                Id = $NewPolicy.id
                Type = "Security Baseline"
                Location = "Endpoint Security > Security baselines > Microsoft Defender for Endpoint"
                Template = $DefenderTemplate.displayName
            }
        } catch {
            Write-Log "Error creating Defender baseline: $_" "ERROR"
            $FailedPolicies += @{ Name = $DefenderBaselineName; Reason = $_.Exception.Message; Location = "Endpoint Security > Security baselines" }
        }
    } else {
        Write-Log "Defender for Endpoint baseline template not found" "WARN"
        $FailedPolicies += @{ Name = $DefenderBaselineName; Reason = "Template not found"; Location = "Endpoint Security > Security baselines" }
    }
}

# ============================================
# 2. BitLocker Policy (Disk Encryption)
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating BitLocker Policy ===" "INFO"

$BitLockerName = "BitLocker Encryption - SMB Baseline"

$ExistingBitLocker = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/intents?`$filter=displayName eq '$BitLockerName'" `
    -ErrorAction SilentlyContinue

if ($ExistingBitLocker.value.Count -gt 0) {
    Write-Log "Policy '$BitLockerName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $BitLockerName; Reason = "Already exists"; Location = "Endpoint Security > Disk encryption" }
} else {
    # Find BitLocker template (check multiple patterns)
    $BitLockerTemplate = $SecurityTemplates | Where-Object {
        $_.displayName -like "*BitLocker*" -or
        $_.templateSubtype -eq "bitLocker"
    } | Sort-Object -Property publishedDateTime -Descending | Select-Object -First 1

    if ($BitLockerTemplate) {
        try {
            $NewPolicy = New-EndpointSecurityPolicy `
                -PolicyName $BitLockerName `
                -Description "BitLocker disk encryption policy for SMB devices." `
                -TemplateId $BitLockerTemplate.id `
                -Scope $DeploymentScope `
                -GroupId $TargetGroupId

            $CreatedPolicies += @{
                Name = $BitLockerName
                Id = $NewPolicy.id
                Type = "Disk Encryption"
                Location = "Endpoint Security > Disk encryption"
                Template = $BitLockerTemplate.displayName
            }
        } catch {
            Write-Log "Error creating BitLocker policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $BitLockerName; Reason = $_.Exception.Message; Location = "Endpoint Security > Disk encryption" }
        }
    } else {
        Write-Log "BitLocker template not found" "WARN"
        $FailedPolicies += @{ Name = $BitLockerName; Reason = "Template not found"; Location = "Endpoint Security > Disk encryption" }
    }
}

# ============================================
# 3. Endpoint Detection and Response
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating EDR Policy ===" "INFO"

$EDRName = "Endpoint Detection and Response - SMB"

$ExistingEDR = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/intents?`$filter=displayName eq '$EDRName'" `
    -ErrorAction SilentlyContinue

if ($ExistingEDR.value.Count -gt 0) {
    Write-Log "Policy '$EDRName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $EDRName; Reason = "Already exists"; Location = "Endpoint Security > EDR" }
} else {
    # Find EDR template (check multiple patterns)
    $EDRTemplate = $SecurityTemplates | Where-Object {
        $_.displayName -like "*Endpoint detection*" -or
        $_.displayName -like "*EDR*" -or
        $_.templateSubtype -eq "endpointDetectionAndResponse"
    } | Sort-Object -Property publishedDateTime -Descending | Select-Object -First 1

    if ($EDRTemplate) {
        try {
            $NewPolicy = New-EndpointSecurityPolicy `
                -PolicyName $EDRName `
                -Description "Endpoint Detection and Response settings for SMB. Sample sharing enabled." `
                -TemplateId $EDRTemplate.id `
                -Scope $DeploymentScope `
                -GroupId $TargetGroupId

            $CreatedPolicies += @{
                Name = $EDRName
                Id = $NewPolicy.id
                Type = "EDR"
                Location = "Endpoint Security > Endpoint detection and response"
                Template = $EDRTemplate.displayName
            }
        } catch {
            Write-Log "Error creating EDR policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $EDRName; Reason = $_.Exception.Message; Location = "Endpoint Security > EDR" }
        }
    } else {
        Write-Log "EDR template not found" "WARN"
        $FailedPolicies += @{ Name = $EDRName; Reason = "Template not found"; Location = "Endpoint Security > EDR" }
    }
}

# ============================================
# 4. MDM Security Baseline
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating MDM Security Baseline ===" "INFO"

$MDMBaselineName = "Windows Security Baseline - SMB"

$ExistingMDM = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/intents?`$filter=displayName eq '$MDMBaselineName'" `
    -ErrorAction SilentlyContinue

if ($ExistingMDM.value.Count -gt 0) {
    Write-Log "Policy '$MDMBaselineName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $MDMBaselineName; Reason = "Already exists"; Location = "Endpoint Security > Security baselines" }
} else {
    # Find MDM Security Baseline template (check multiple patterns)
    $MDMTemplate = $SecurityTemplates | Where-Object {
        $_.displayName -like "*MDM Security Baseline*" -or
        $_.displayName -like "*Security Baseline for Windows*" -or
        ($_.templateType -eq "securityBaseline" -and $_.displayName -notlike "*Defender*" -and $_.displayName -notlike "*Edge*")
    } | Sort-Object -Property publishedDateTime -Descending | Select-Object -First 1

    if ($MDMTemplate) {
        try {
            $NewPolicy = New-EndpointSecurityPolicy `
                -PolicyName $MDMBaselineName `
                -Description "Windows MDM Security Baseline for SMB. Comprehensive security settings." `
                -TemplateId $MDMTemplate.id `
                -Scope $DeploymentScope `
                -GroupId $TargetGroupId

            $CreatedPolicies += @{
                Name = $MDMBaselineName
                Id = $NewPolicy.id
                Type = "Security Baseline"
                Location = "Endpoint Security > Security baselines > MDM Security Baseline"
                Template = $MDMTemplate.displayName
            }
        } catch {
            Write-Log "Error creating MDM baseline: $_" "ERROR"
            $FailedPolicies += @{ Name = $MDMBaselineName; Reason = $_.Exception.Message; Location = "Endpoint Security > Security baselines" }
        }
    } else {
        Write-Log "MDM Security Baseline template not found" "WARN"
        $FailedPolicies += @{ Name = $MDMBaselineName; Reason = "Template not found"; Location = "Endpoint Security > Security baselines" }
    }
}

# ============================================
# 5. Application Control (optional)
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating Application Control Policy ===" "INFO"

$AppControlName = "Application Control - SMB"

$ExistingAppControl = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/intents?`$filter=displayName eq '$AppControlName'" `
    -ErrorAction SilentlyContinue

if ($ExistingAppControl.value.Count -gt 0) {
    Write-Log "Policy '$AppControlName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $AppControlName; Reason = "Already exists"; Location = "Endpoint Security > App control" }
} else {
    # Find Application Control template (check multiple patterns)
    $AppControlTemplate = $SecurityTemplates | Where-Object {
        $_.displayName -like "*Application control*" -or
        $_.displayName -like "*App Control*" -or
        $_.templateSubtype -eq "applicationControl"
    } | Sort-Object -Property publishedDateTime -Descending | Select-Object -First 1

    if ($AppControlTemplate) {
        try {
            $NewPolicy = New-EndpointSecurityPolicy `
                -PolicyName $AppControlName `
                -Description "Application control policy for SMB devices." `
                -TemplateId $AppControlTemplate.id `
                -Scope $DeploymentScope `
                -GroupId $TargetGroupId

            $CreatedPolicies += @{
                Name = $AppControlName
                Id = $NewPolicy.id
                Type = "Application Control"
                Location = "Endpoint Security > Application control"
                Template = $AppControlTemplate.displayName
            }
        } catch {
            Write-Log "Error creating Application Control policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $AppControlName; Reason = $_.Exception.Message; Location = "Endpoint Security > App control" }
        }
    } else {
        Write-Log "Application Control template not found" "WARN"
        $FailedPolicies += @{ Name = $AppControlName; Reason = "Template not found"; Location = "Endpoint Security > App control" }
    }
}

# ============================================
# 6. Antivirus Policy (Settings Catalog)
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating Antivirus Policy ===" "INFO"

$AntivirusName = "Microsoft Defender Antivirus - SMB"

# Check if exists in configurationPolicies
$ExistingAVPolicies = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies?`$filter=name eq '$AntivirusName'" `
    -ErrorAction SilentlyContinue

if ($ExistingAVPolicies.value.Count -gt 0) {
    Write-Log "Policy '$AntivirusName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $AntivirusName; Reason = "Already exists"; Location = "Endpoint Security > Antivirus" }
} else {
    # Known template ID for Microsoft Defender Antivirus (Windows 10)
    $AVTemplateId = "804339ad-1553-4478-a742-138fb5807418_1"

    try {
        Write-Log "Using Settings Catalog template ID: $AVTemplateId" "INFO"

        # Settings for Antivirus - Enable key protections with template references (GUIDs)
        $AVSettings = @(
            @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
                settingInstance = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                    settingDefinitionId = "device_vendor_msft_policy_config_defender_allowrealtimemonitoring"
                    settingInstanceTemplateReference = @{
                        settingInstanceTemplateId = "f0790e28-9231-4d37-8f44-84bb47ca1b3e"
                    }
                    choiceSettingValue = @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                        value = "device_vendor_msft_policy_config_defender_allowrealtimemonitoring_1"
                    }
                }
            },
            @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
                settingInstance = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                    settingDefinitionId = "device_vendor_msft_policy_config_defender_allowbehaviormonitoring"
                    settingInstanceTemplateReference = @{
                        settingInstanceTemplateId = "8eef615a-1aa0-46f4-a25a-12cbe65de5ab"
                    }
                    choiceSettingValue = @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                        value = "device_vendor_msft_policy_config_defender_allowbehaviormonitoring_1"
                    }
                }
            },
            @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
                settingInstance = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                    settingDefinitionId = "device_vendor_msft_policy_config_defender_allowcloudprotection"
                    settingInstanceTemplateReference = @{
                        settingInstanceTemplateId = "7da139f1-9b7e-407d-853a-c2e5037cdc70"
                    }
                    choiceSettingValue = @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                        value = "device_vendor_msft_policy_config_defender_allowcloudprotection_1"
                    }
                }
            },
            @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
                settingInstance = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                    settingDefinitionId = "device_vendor_msft_policy_config_defender_allowioavprotection"
                    settingInstanceTemplateReference = @{
                        settingInstanceTemplateId = "fa06231d-aed4-4601-b631-3a37e85b62a0"
                    }
                    choiceSettingValue = @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                        value = "device_vendor_msft_policy_config_defender_allowioavprotection_1"
                    }
                }
            }
        )

        $AVPolicyBody = @{
            name = $AntivirusName
            description = "Microsoft Defender Antivirus policy for SMB. Real-time protection enabled."
            platforms = "windows10"
            technologies = "mdm,microsoftSense"
            templateReference = @{
                templateId = $AVTemplateId
            }
            settings = $AVSettings
        }

        $NewAVPolicy = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies" `
            -Body ($AVPolicyBody | ConvertTo-Json -Depth 20) `
            -ContentType "application/json" `
            -ErrorAction Stop

        Write-Log "Antivirus policy created - ID: $($NewAVPolicy.id)" "INFO"

        # Assign to all devices
        Start-Sleep -Seconds 2
        $AVAssignment = @{
            assignments = @(
                @{
                    target = @{
                        "@odata.type" = if ($DeploymentScope -eq "AllDevices") { "#microsoft.graph.allDevicesAssignmentTarget" } else { "#microsoft.graph.groupAssignmentTarget"; groupId = $TargetGroupId }
                    }
                }
            )
        }

        Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$($NewAVPolicy.id)/assign" `
            -Body ($AVAssignment | ConvertTo-Json -Depth 10) `
            -ContentType "application/json" `
            -ErrorAction Stop

        Write-Log "Antivirus policy assigned to $DeploymentScope" "INFO"

        $CreatedPolicies += @{
            Name = $AntivirusName
            Id = $NewAVPolicy.id
            Type = "Antivirus"
            Location = "Endpoint Security > Antivirus"
            Template = "Microsoft Defender Antivirus"
        }
    } catch {
        Write-Log "Error creating Antivirus policy: $_" "ERROR"
        $FailedPolicies += @{ Name = $AntivirusName; Reason = $_.Exception.Message; Location = "Endpoint Security > Antivirus" }
    }
}

# ============================================
# 7. Firewall Policy (Settings Catalog)
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating Firewall Policy ===" "INFO"

$FirewallName = "Windows Firewall - SMB Baseline"

# Check if exists in configurationPolicies
$ExistingFWPolicies = Invoke-MgGraphRequest -Method GET `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies?`$filter=name eq '$FirewallName'" `
    -ErrorAction SilentlyContinue

if ($ExistingFWPolicies.value.Count -gt 0) {
    Write-Log "Policy '$FirewallName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $FirewallName; Reason = "Already exists"; Location = "Endpoint Security > Firewall" }
} else {
    # Known template ID for Windows Firewall (Windows 10)
    $FWTemplateId = "6078910e-d808-4a9f-a51d-1b8a7bacb7c0_1"

    try {
        Write-Log "Using Settings Catalog template ID: $FWTemplateId" "INFO"

        # Settings for Firewall - Enable firewall for all profiles with template references (GUIDs)
        $FWSettings = @(
            @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
                settingInstance = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                    settingDefinitionId = "vendor_msft_firewall_mdmstore_domainprofile_enablefirewall"
                    settingInstanceTemplateReference = @{
                        settingInstanceTemplateId = "7714c373-a19a-4b64-ba6d-2e9db04a7684"
                    }
                    choiceSettingValue = @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                        value = "vendor_msft_firewall_mdmstore_domainprofile_enablefirewall_true"
                    }
                }
            },
            @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
                settingInstance = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                    settingDefinitionId = "vendor_msft_firewall_mdmstore_privateprofile_enablefirewall"
                    settingInstanceTemplateReference = @{
                        settingInstanceTemplateId = "1c14f914-69bb-49f8-af5b-e29173a6ee95"
                    }
                    choiceSettingValue = @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                        value = "vendor_msft_firewall_mdmstore_privateprofile_enablefirewall_true"
                    }
                }
            },
            @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
                settingInstance = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                    settingDefinitionId = "vendor_msft_firewall_mdmstore_publicprofile_enablefirewall"
                    settingInstanceTemplateReference = @{
                        settingInstanceTemplateId = "e2714734-708e-4286-8ae9-d56821e306a3"
                    }
                    choiceSettingValue = @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                        value = "vendor_msft_firewall_mdmstore_publicprofile_enablefirewall_true"
                    }
                }
            }
        )

        $FWPolicyBody = @{
            name = $FirewallName
            description = "Windows Firewall policy for SMB devices. Firewall enabled for all profiles."
            platforms = "windows10"
            technologies = "mdm,microsoftSense"
            templateReference = @{
                templateId = $FWTemplateId
            }
            settings = $FWSettings
        }

        $NewFWPolicy = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies" `
            -Body ($FWPolicyBody | ConvertTo-Json -Depth 20) `
            -ContentType "application/json" `
            -ErrorAction Stop

        Write-Log "Firewall policy created - ID: $($NewFWPolicy.id)" "INFO"

        # Assign to all devices
        Start-Sleep -Seconds 2
        $FWAssignment = @{
            assignments = @(
                @{
                    target = @{
                        "@odata.type" = if ($DeploymentScope -eq "AllDevices") { "#microsoft.graph.allDevicesAssignmentTarget" } else { "#microsoft.graph.groupAssignmentTarget"; groupId = $TargetGroupId }
                    }
                }
            )
        }

        Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$($NewFWPolicy.id)/assign" `
            -Body ($FWAssignment | ConvertTo-Json -Depth 10) `
            -ContentType "application/json" `
            -ErrorAction Stop

        Write-Log "Firewall policy assigned to $DeploymentScope" "INFO"

        $CreatedPolicies += @{
            Name = $FirewallName
            Id = $NewFWPolicy.id
            Type = "Firewall"
            Location = "Endpoint Security > Firewall"
            Template = "Windows Firewall"
        }
    } catch {
        Write-Log "Error creating Firewall policy: $_" "ERROR"
        $FailedPolicies += @{ Name = $FirewallName; Reason = $_.Exception.Message; Location = "Endpoint Security > Firewall" }
    }
}

# ============================================
# Deployment Summary
# ============================================

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║       MICROSOFT DEFENDER FOR ENDPOINT DEPLOYMENT SUMMARY         ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Deployment Scope:  $DeploymentScope" "INFO"
Write-Log "║  Policy Type:       Native Endpoint Security" "INFO"
Write-Log "║  Policies Created:  $($CreatedPolicies.Count)" "INFO"
Write-Log "║  Policies Skipped:  $($FailedPolicies.Count)" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "=== CREATED POLICIES ===" "INFO"
foreach ($Policy in $CreatedPolicies) {
    Write-Log "  [+] $($Policy.Name)" "INFO"
    Write-Log "      Type: $($Policy.Type)" "INFO"
    Write-Log "      Location: $($Policy.Location)" "INFO"
    Write-Log "      Template: $($Policy.Template)" "INFO"
    Write-Log "      ID: $($Policy.Id)" "INFO"
}

if ($FailedPolicies.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== SKIPPED/FAILED POLICIES ===" "WARN"
    foreach ($Policy in $FailedPolicies) {
        Write-Log "  [-] $($Policy.Name)" "WARN"
        Write-Log "      Reason: $($Policy.Reason)" "WARN"
        Write-Log "      Location: $($Policy.Location)" "WARN"
    }
}

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                    POLICY LOCATIONS IN INTUNE                    ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Security Baselines: Endpoint security > Security baselines      ║" "INFO"
Write-Log "║  Antivirus:          Endpoint security > Antivirus               ║" "INFO"
Write-Log "║  Firewall:           Endpoint security > Firewall                ║" "INFO"
Write-Log "║  Disk Encryption:    Endpoint security > Disk encryption         ║" "INFO"
Write-Log "║  EDR:                Endpoint security > Endpoint detection      ║" "INFO"
Write-Log "║  App Control:        Endpoint security > Application control     ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Defender for Endpoint Deployment Completed ===" "INFO"

Disconnect-MgGraph | Out-Null

return @{
    Success = $true
    PoliciesCreated = $CreatedPolicies.Count
    PoliciesFailed = $FailedPolicies.Count
    DeploymentScope = $DeploymentScope
    CreatedPolicies = $CreatedPolicies
    FailedPolicies = $FailedPolicies
}
