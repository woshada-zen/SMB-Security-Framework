<#
.SYNOPSIS
    Enable Attack Surface Reduction (ASR) rules for Microsoft Defender (v2 - Multi-Policy).

.DESCRIPTION
    Configures Attack Surface Reduction rules organized into multiple policy categories.
    Part of the Strategic Integration Framework for SMB Security - Module 2: Endpoint Protection.

    Creates 5 separate Intune policies for granular management:
    1. Office Application Security - Protects against Office-based attacks
    2. Script Execution Control - Blocks malicious scripts
    3. Credential Protection - Prevents credential theft
    4. Ransomware Protection - Advanced ransomware blocking
    5. Removable Media Control - USB and external device protection

.PARAMETER RuleSet
    Rule set to deploy: "SMB-Recommended" (5 category policies), "All" (all 16 rules across categories)

.PARAMETER Mode
    Rule mode: "Audit" (log only, no blocking), "Block" (enforce blocking)

.EXAMPLE
    .\Enable-ASRRules-v2.ps1 -RuleSet "SMB-Recommended" -Mode "Audit"

.EXAMPLE
    .\Enable-ASRRules-v2.ps1 -RuleSet "All" -Mode "Block"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("SMB-Recommended", "All")]
    [string]$RuleSet,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Audit", "Block")]
    [string]$Mode
)

#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement

# Initialize logging
$LogFile = "ASR-Rules-v2-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== ASR Rules Multi-Policy Deployment (v2) Started ===" "INFO"
Write-Log "Rule Set: $RuleSet" "INFO"
Write-Log "Mode: $Mode" "INFO"

# ============================================
# ASR Rule Categories Definition
# ============================================

$ASRCategories = @{
    "Office-Application-Security" = @{
        Description = "Protects against Office-based malware and macro attacks"
        Rules = @{
            "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550" = "Block executable content from email client and webmail"
            "3B576869-A4EC-4529-8536-B80A7769E899" = "Block Office applications from creating executable content"
            "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" = "Block Office applications from injecting code into other processes"
            "26190899-1602-49E8-8B27-EB1D0A1CE869" = "Block Office communication application from creating child processes"
            "7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C" = "Block Adobe Reader from creating child processes"
        }
    }
    "Script-Execution-Control" = @{
        Description = "Blocks malicious JavaScript, VBScript, and PowerShell attacks"
        Rules = @{
            "D3E037E1-3EB8-44C8-A917-57927947596D" = "Block JavaScript or VBScript from launching downloaded executable content"
            "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC" = "Block execution of potentially obfuscated scripts"
            "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B" = "Block Win32 API calls from Office macros"
        }
    }
    "Credential-Protection" = @{
        Description = "Prevents credential theft and LSASS attacks"
        Rules = @{
            "9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2" = "Block credential stealing from Windows LSASS"
        }
    }
    "Ransomware-Protection" = @{
        Description = "Advanced protection against ransomware behavior"
        Rules = @{
            "C1DB55AB-C21A-4637-BB3F-A12568109D35" = "Use advanced protection against ransomware"
            "D1E49AAC-8F56-4280-B9BA-993A6D77406C" = "Block process creations originating from PSExec and WMI commands"
        }
    }
    "Removable-Media-Control" = @{
        Description = "Controls USB and external device execution"
        Rules = @{
            "B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4" = "Block untrusted and unsigned processes that run from USB"
            "E6DB77E5-3DF2-4CF1-B95A-636979351E5B" = "Block persistence through WMI event subscription"
        }
    }
}

# SMB-Recommended uses subset of rules per category
$SMBRecommendedRules = @{
    "Office-Application-Security" = @(
        "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550",
        "3B576869-A4EC-4529-8536-B80A7769E899",
        "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84"
    )
    "Script-Execution-Control" = @(
        "D3E037E1-3EB8-44C8-A917-57927947596D",
        "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC"
    )
    "Credential-Protection" = @(
        "9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2"
    )
    "Ransomware-Protection" = @(
        "C1DB55AB-C21A-4637-BB3F-A12568109D35"
    )
    "Removable-Media-Control" = @(
        "B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4"
    )
}

# ============================================
# Connect to Microsoft Graph
# ============================================

try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All" -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    exit 1
}

# ============================================
# Create Policies for Each Category
# ============================================

$ActionValue = if ($Mode -eq "Audit") { 2 } else { 1 }
$CreatedPolicies = @()
$FailedPolicies = @()

foreach ($CategoryName in $ASRCategories.Keys) {
    Write-Log "" "INFO"
    Write-Log "=== Processing Category: $CategoryName ===" "INFO"

    $Category = $ASRCategories[$CategoryName]

    # Determine which rules to deploy based on RuleSet
    if ($RuleSet -eq "SMB-Recommended") {
        $RuleGUIDs = $SMBRecommendedRules[$CategoryName]
        $RulesToDeploy = @{}
        foreach ($GUID in $RuleGUIDs) {
            if ($Category.Rules.ContainsKey($GUID)) {
                $RulesToDeploy[$GUID] = $Category.Rules[$GUID]
            }
        }
    } else {
        $RulesToDeploy = $Category.Rules
    }

    if ($RulesToDeploy.Count -eq 0) {
        Write-Log "No rules to deploy for this category in $RuleSet mode - skipping" "WARN"
        continue
    }

    Write-Log "Deploying $($RulesToDeploy.Count) rules for $CategoryName" "INFO"

    # Build combined rule string (pipe-separated)
    $RuleStrings = @()
    foreach ($Rule in $RulesToDeploy.GetEnumerator()) {
        $RuleStrings += "$($Rule.Key)=$ActionValue"
        Write-Log "  Adding: $($Rule.Value)" "INFO"
    }
    $CombinedRulesValue = $RuleStrings -join "|"

    # Build OMA-URI setting
    $OMAURISettings = @(
        @{
            "@odata.type" = "#microsoft.graph.omaSettingString"
            displayName = "$CategoryName ASR Rules"
            omaUri = "./Device/Vendor/MSFT/Policy/Config/Defender/AttackSurfaceReductionRules"
            value = $CombinedRulesValue
        }
    )

    # Policy naming
    $PolicyName = "ASR - $CategoryName - $Mode Mode"
    $PolicyDescription = "$($Category.Description). Mode: $Mode. Rules: $($RulesToDeploy.Count). Created: $(Get-Date -Format 'yyyy-MM-dd')"

    # Check if policy already exists
    Write-Log "Checking for existing policy: $PolicyName" "INFO"
    $ExistingPolicy = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$PolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingPolicy) {
        Write-Log "Policy '$PolicyName' already exists - skipping (delete manually to recreate)" "WARN"
        $FailedPolicies += @{
            Name = $PolicyName
            Reason = "Already exists"
        }
        continue
    }

    # Create the policy
    $PolicyParams = @{
        "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
        displayName = $PolicyName
        description = $PolicyDescription
        omaSettings = $OMAURISettings
    }

    try {
        Write-Log "Creating policy: $PolicyName" "INFO"
        $NewPolicy = New-MgDeviceManagementDeviceConfiguration -BodyParameter $PolicyParams -ErrorAction Stop

        Start-Sleep -Seconds 2

        # Retrieve created policy
        $CreatedPolicy = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$PolicyName'" -ErrorAction Stop

        if ($CreatedPolicy) {
            Write-Log "Policy created successfully - ID: $($CreatedPolicy.Id)" "INFO"

            # Assign to all devices
            $AssignmentParams = @{
                "@odata.type" = "#microsoft.graph.deviceConfigurationAssignment"
                target = @{
                    "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                }
            }

            try {
                New-MgDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $CreatedPolicy.Id `
                    -BodyParameter $AssignmentParams `
                    -ErrorAction Stop

                Write-Log "Policy assigned to all devices" "INFO"

                $CreatedPolicies += @{
                    Name = $PolicyName
                    Id = $CreatedPolicy.Id
                    Category = $CategoryName
                    RuleCount = $RulesToDeploy.Count
                    Rules = $RulesToDeploy.Values
                }

            } catch {
                Write-Log "Warning: Policy created but assignment failed: $_" "WARN"
                $CreatedPolicies += @{
                    Name = $PolicyName
                    Id = $CreatedPolicy.Id
                    Category = $CategoryName
                    RuleCount = $RulesToDeploy.Count
                    Rules = $RulesToDeploy.Values
                    AssignmentFailed = $true
                }
            }
        }

    } catch {
        Write-Log "Failed to create policy '$PolicyName': $_" "ERROR"
        $FailedPolicies += @{
            Name = $PolicyName
            Reason = $_.Exception.Message
        }
    }
}

# ============================================
# Deployment Summary
# ============================================

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║           ASR RULES MULTI-POLICY DEPLOYMENT SUMMARY              ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Rule Set:        $RuleSet" "INFO"
Write-Log "║  Mode:            $Mode" "INFO"
Write-Log "║  Policies Created: $($CreatedPolicies.Count)" "INFO"
Write-Log "║  Policies Failed:  $($FailedPolicies.Count)" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "=== CREATED POLICIES ===" "INFO"
foreach ($Policy in $CreatedPolicies) {
    Write-Log "" "INFO"
    Write-Log "Policy: $($Policy.Name)" "INFO"
    Write-Log "  ID: $($Policy.Id)" "INFO"
    Write-Log "  Category: $($Policy.Category)" "INFO"
    Write-Log "  Rules ($($Policy.RuleCount)):" "INFO"
    foreach ($RuleName in $Policy.Rules) {
        Write-Log "    - $RuleName" "INFO"
    }
    if ($Policy.AssignmentFailed) {
        Write-Log "  WARNING: Assignment failed - assign manually in Intune" "WARN"
    }
}

if ($FailedPolicies.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== FAILED POLICIES ===" "ERROR"
    foreach ($Policy in $FailedPolicies) {
        Write-Log "  $($Policy.Name): $($Policy.Reason)" "ERROR"
    }
}

# Total rules deployed
$TotalRules = ($CreatedPolicies | Measure-Object -Property RuleCount -Sum).Sum
Write-Log "" "INFO"
Write-Log "Total ASR Rules Deployed: $TotalRules across $($CreatedPolicies.Count) policies" "INFO"

if ($Mode -eq "Audit") {
    Write-Log "" "INFO"
    Write-Log "╔══════════════════════════════════════════════════════════════════╗" "WARN"
    Write-Log "║                    NEXT STEPS (AUDIT MODE)                       ║" "WARN"
    Write-Log "╠══════════════════════════════════════════════════════════════════╣" "WARN"
    Write-Log "║  1. Wait 14 days for audit data collection                       ║" "WARN"
    Write-Log "║  2. Review ASR events: Microsoft 365 Defender > Reports > ASR    ║" "WARN"
    Write-Log "║  3. Check for false positives per category                       ║" "WARN"
    Write-Log "║  4. Add exclusions for legitimate applications if needed         ║" "WARN"
    Write-Log "║  5. Re-run script with -Mode 'Block' to enforce                  ║" "WARN"
    Write-Log "╚══════════════════════════════════════════════════════════════════╝" "WARN"
    Write-Log "" "INFO"
    Write-Log "Review Period Ends: $($(Get-Date).AddDays(14).ToString('yyyy-MM-dd'))" "INFO"
}

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== ASR Rules Multi-Policy Deployment Completed ===" "INFO"

Disconnect-MgGraph | Out-Null

# Return summary object for scripting
return @{
    Success = $true
    PoliciesCreated = $CreatedPolicies.Count
    PoliciesFailed = $FailedPolicies.Count
    TotalRulesDeployed = $TotalRules
    Mode = $Mode
    RuleSet = $RuleSet
    CreatedPolicies = $CreatedPolicies
    FailedPolicies = $FailedPolicies
}
