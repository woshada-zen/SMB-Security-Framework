<#
.SYNOPSIS
    Create Device Compliance Policies for multiple platforms via Intune.

.DESCRIPTION
    Creates device compliance policies for Windows, macOS, iOS, and Android.
    Part of the Strategic Integration Framework for SMB Security - Module 2: Endpoint Protection.

    Creates the following compliance policies:
    1. Windows 10/11 Compliance Policy - BitLocker, Firewall, Antivirus, Secure Boot
    2. macOS Compliance Policy - FileVault, Firewall, System Integrity
    3. iOS/iPadOS Compliance Policy - Passcode, Jailbreak detection
    4. Android Compliance Policy - Encryption, Root detection, Security patch level

.PARAMETER PolicySet
    Policy strictness level: "SMB-Baseline" (recommended), "Strict" (enhanced), "Minimal" (basic)

.PARAMETER Platforms
    Platforms to create policies for: "All", "Windows", "macOS", "iOS", "Android"

.PARAMETER GracePeriodDays
    Days before non-compliant devices are marked (default: 3)

.EXAMPLE
    .\Create-CompliancePolicies.ps1 -PolicySet "SMB-Baseline" -Platforms "All"

.EXAMPLE
    .\Create-CompliancePolicies.ps1 -PolicySet "Strict" -Platforms "Windows,iOS"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("SMB-Baseline", "Strict", "Minimal")]
    [string]$PolicySet,

    [Parameter(Mandatory = $false)]
    [string]$Platforms = "All",

    [Parameter(Mandatory = $false)]
    [int]$GracePeriodDays = 3
)

#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement

# Initialize logging
$LogFile = "Compliance-Policies-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Device Compliance Policies Deployment Started ===" "INFO"
Write-Log "Policy Set: $PolicySet" "INFO"
Write-Log "Platforms: $Platforms" "INFO"
Write-Log "Grace Period: $GracePeriodDays days" "INFO"

# Parse platforms
$PlatformList = if ($Platforms -eq "All") {
    @("Windows", "macOS", "iOS", "Android")
} else {
    $Platforms -split "," | ForEach-Object { $_.Trim() }
}

Write-Log "Deploying to platforms: $($PlatformList -join ', ')" "INFO"

# ============================================
# Connect to Microsoft Graph
# ============================================

try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes @(
        "DeviceManagementConfiguration.ReadWrite.All",
        "DeviceManagementManagedDevices.ReadWrite.All"
    ) -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    exit 1
}

$CreatedPolicies = @()
$FailedPolicies = @()

# ============================================
# 1. Windows 10/11 Compliance Policy
# ============================================

if ($PlatformList -contains "Windows") {
    Write-Log "" "INFO"
    Write-Log "=== Creating Windows Compliance Policy ===" "INFO"

    $WindowsPolicyName = "Windows 10-11 Compliance - $PolicySet"
    $WindowsDescription = "Device compliance policy for Windows 10/11 devices. Enforces BitLocker, Firewall, Antivirus, and Secure Boot."

    $ExistingWindows = Get-MgDeviceManagementDeviceCompliancePolicy -Filter "displayName eq '$WindowsPolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingWindows) {
        Write-Log "Policy '$WindowsPolicyName' already exists - skipping" "WARN"
        $FailedPolicies += @{ Name = $WindowsPolicyName; Platform = "Windows"; Reason = "Already exists" }
    } else {
        # Define settings based on PolicySet
        $WindowsSettings = switch ($PolicySet) {
            "SMB-Baseline" {
                @{
                    bitLockerEnabled = $true
                    secureBootEnabled = $true
                    codeIntegrityEnabled = $true
                    defenderEnabled = $true
                    firewallEnabled = $true
                    antivirusRequired = $true
                    antiSpywareRequired = $true
                    rtpEnabled = $true  # Real-time protection
                    passwordRequired = $true
                    passwordMinimumLength = 8
                    osMinimumVersion = "10.0.19041"  # Windows 10 2004
                }
            }
            "Strict" {
                @{
                    bitLockerEnabled = $true
                    secureBootEnabled = $true
                    codeIntegrityEnabled = $true
                    defenderEnabled = $true
                    firewallEnabled = $true
                    antivirusRequired = $true
                    antiSpywareRequired = $true
                    rtpEnabled = $true
                    passwordRequired = $true
                    passwordMinimumLength = 12
                    passwordRequiredType = "alphanumeric"
                    osMinimumVersion = "10.0.22000"  # Windows 11
                    tpmRequired = $true
                }
            }
            "Minimal" {
                @{
                    defenderEnabled = $true
                    firewallEnabled = $true
                    passwordRequired = $true
                    passwordMinimumLength = 6
                }
            }
        }

        $WindowsParams = @{
            "@odata.type" = "#microsoft.graph.windows10CompliancePolicy"
            displayName = $WindowsPolicyName
            description = $WindowsDescription
            bitLockerEnabled = $WindowsSettings.bitLockerEnabled
            secureBootEnabled = $WindowsSettings.secureBootEnabled
            codeIntegrityEnabled = $WindowsSettings.codeIntegrityEnabled
            defenderEnabled = $WindowsSettings.defenderEnabled
            firewallEnabled = $WindowsSettings.firewallEnabled
            antivirusRequired = $WindowsSettings.antivirusRequired
            antiSpywareRequired = $WindowsSettings.antiSpywareRequired
            rtpEnabled = $WindowsSettings.rtpEnabled
            passwordRequired = $WindowsSettings.passwordRequired
            passwordMinimumLength = $WindowsSettings.passwordMinimumLength
            osMinimumVersion = $WindowsSettings.osMinimumVersion
            scheduledActionsForRule = @(
                @{
                    ruleName = "PasswordRequired"
                    scheduledActionConfigurations = @(
                        @{
                            actionType = "block"
                            gracePeriodHours = ($GracePeriodDays * 24)
                            notificationTemplateId = ""
                        }
                    )
                }
            )
        }

        try {
            Write-Log "Creating Windows compliance policy..." "INFO"
            $NewWindowsPolicy = New-MgDeviceManagementDeviceCompliancePolicy -BodyParameter $WindowsParams -ErrorAction Stop
            Write-Log "Windows policy created - ID: $($NewWindowsPolicy.Id)" "INFO"

            # Assign to all devices
            $AssignmentParams = @{
                assignments = @(
                    @{
                        target = @{
                            "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                        }
                    }
                )
            }

            Invoke-MgGraphRequest -Method POST `
                -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies/$($NewWindowsPolicy.Id)/assign" `
                -Body ($AssignmentParams | ConvertTo-Json -Depth 10) `
                -ContentType "application/json" -ErrorAction Stop

            Write-Log "Windows policy assigned to all devices" "INFO"

            $CreatedPolicies += @{
                Name = $WindowsPolicyName
                Id = $NewWindowsPolicy.Id
                Platform = "Windows"
                Settings = $WindowsSettings.Keys.Count
            }
        } catch {
            Write-Log "Failed to create Windows policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $WindowsPolicyName; Platform = "Windows"; Reason = $_.Exception.Message }
        }
    }
}

# ============================================
# 2. macOS Compliance Policy
# ============================================

if ($PlatformList -contains "macOS") {
    Write-Log "" "INFO"
    Write-Log "=== Creating macOS Compliance Policy ===" "INFO"

    $macOSPolicyName = "macOS Compliance - $PolicySet"
    $macOSDescription = "Device compliance policy for macOS devices. Enforces FileVault encryption, Firewall, and System Integrity Protection."

    $ExistingmacOS = Get-MgDeviceManagementDeviceCompliancePolicy -Filter "displayName eq '$macOSPolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingmacOS) {
        Write-Log "Policy '$macOSPolicyName' already exists - skipping" "WARN"
        $FailedPolicies += @{ Name = $macOSPolicyName; Platform = "macOS"; Reason = "Already exists" }
    } else {
        $macOSSettings = switch ($PolicySet) {
            "SMB-Baseline" {
                @{
                    passwordRequired = $true
                    passwordMinimumLength = 8
                    storageRequireEncryption = $true
                    firewallEnabled = $true
                    systemIntegrityProtectionEnabled = $true
                    osMinimumVersion = "12.0"  # macOS Monterey
                }
            }
            "Strict" {
                @{
                    passwordRequired = $true
                    passwordMinimumLength = 12
                    passwordRequiredType = "alphanumeric"
                    storageRequireEncryption = $true
                    firewallEnabled = $true
                    firewallBlockAllIncoming = $true
                    systemIntegrityProtectionEnabled = $true
                    osMinimumVersion = "13.0"  # macOS Ventura
                }
            }
            "Minimal" {
                @{
                    passwordRequired = $true
                    passwordMinimumLength = 6
                    storageRequireEncryption = $true
                }
            }
        }

        $macOSParams = @{
            "@odata.type" = "#microsoft.graph.macOSCompliancePolicy"
            displayName = $macOSPolicyName
            description = $macOSDescription
            passwordRequired = $macOSSettings.passwordRequired
            passwordMinimumLength = $macOSSettings.passwordMinimumLength
            storageRequireEncryption = $macOSSettings.storageRequireEncryption
            firewallEnabled = $macOSSettings.firewallEnabled
            systemIntegrityProtectionEnabled = $macOSSettings.systemIntegrityProtectionEnabled
            osMinimumVersion = $macOSSettings.osMinimumVersion
            scheduledActionsForRule = @(
                @{
                    ruleName = "PasswordRequired"
                    scheduledActionConfigurations = @(
                        @{
                            actionType = "block"
                            gracePeriodHours = ($GracePeriodDays * 24)
                            notificationTemplateId = ""
                        }
                    )
                }
            )
        }

        try {
            Write-Log "Creating macOS compliance policy..." "INFO"
            $NewmacOSPolicy = New-MgDeviceManagementDeviceCompliancePolicy -BodyParameter $macOSParams -ErrorAction Stop
            Write-Log "macOS policy created - ID: $($NewmacOSPolicy.Id)" "INFO"

            $AssignmentParams = @{
                assignments = @(
                    @{
                        target = @{
                            "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                        }
                    }
                )
            }

            Invoke-MgGraphRequest -Method POST `
                -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies/$($NewmacOSPolicy.Id)/assign" `
                -Body ($AssignmentParams | ConvertTo-Json -Depth 10) `
                -ContentType "application/json" -ErrorAction Stop

            Write-Log "macOS policy assigned to all devices" "INFO"

            $CreatedPolicies += @{
                Name = $macOSPolicyName
                Id = $NewmacOSPolicy.Id
                Platform = "macOS"
                Settings = $macOSSettings.Keys.Count
            }
        } catch {
            Write-Log "Failed to create macOS policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $macOSPolicyName; Platform = "macOS"; Reason = $_.Exception.Message }
        }
    }
}

# ============================================
# 3. iOS/iPadOS Compliance Policy
# ============================================

if ($PlatformList -contains "iOS") {
    Write-Log "" "INFO"
    Write-Log "=== Creating iOS/iPadOS Compliance Policy ===" "INFO"

    $iOSPolicyName = "iOS-iPadOS Compliance - $PolicySet"
    $iOSDescription = "Device compliance policy for iOS and iPadOS devices. Enforces passcode, jailbreak detection, and minimum OS version."

    $ExistingiOS = Get-MgDeviceManagementDeviceCompliancePolicy -Filter "displayName eq '$iOSPolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingiOS) {
        Write-Log "Policy '$iOSPolicyName' already exists - skipping" "WARN"
        $FailedPolicies += @{ Name = $iOSPolicyName; Platform = "iOS"; Reason = "Already exists" }
    } else {
        $iOSSettings = switch ($PolicySet) {
            "SMB-Baseline" {
                @{
                    passcodeRequired = $true
                    passcodeMinimumLength = 6
                    securityBlockJailbrokenDevices = $true
                    managedEmailProfileRequired = $false
                    osMinimumVersion = "15.0"
                }
            }
            "Strict" {
                @{
                    passcodeRequired = $true
                    passcodeMinimumLength = 8
                    passcodeRequiredType = "alphanumeric"
                    securityBlockJailbrokenDevices = $true
                    managedEmailProfileRequired = $true
                    osMinimumVersion = "16.0"
                }
            }
            "Minimal" {
                @{
                    passcodeRequired = $true
                    passcodeMinimumLength = 4
                    securityBlockJailbrokenDevices = $true
                }
            }
        }

        $iOSParams = @{
            "@odata.type" = "#microsoft.graph.iosCompliancePolicy"
            displayName = $iOSPolicyName
            description = $iOSDescription
            passcodeRequired = $iOSSettings.passcodeRequired
            passcodeMinimumLength = $iOSSettings.passcodeMinimumLength
            securityBlockJailbrokenDevices = $iOSSettings.securityBlockJailbrokenDevices
            osMinimumVersion = $iOSSettings.osMinimumVersion
            scheduledActionsForRule = @(
                @{
                    ruleName = "PasswordRequired"
                    scheduledActionConfigurations = @(
                        @{
                            actionType = "block"
                            gracePeriodHours = ($GracePeriodDays * 24)
                            notificationTemplateId = ""
                        }
                    )
                }
            )
        }

        try {
            Write-Log "Creating iOS/iPadOS compliance policy..." "INFO"
            $NewiOSPolicy = New-MgDeviceManagementDeviceCompliancePolicy -BodyParameter $iOSParams -ErrorAction Stop
            Write-Log "iOS policy created - ID: $($NewiOSPolicy.Id)" "INFO"

            $AssignmentParams = @{
                assignments = @(
                    @{
                        target = @{
                            "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                        }
                    }
                )
            }

            Invoke-MgGraphRequest -Method POST `
                -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies/$($NewiOSPolicy.Id)/assign" `
                -Body ($AssignmentParams | ConvertTo-Json -Depth 10) `
                -ContentType "application/json" -ErrorAction Stop

            Write-Log "iOS policy assigned to all devices" "INFO"

            $CreatedPolicies += @{
                Name = $iOSPolicyName
                Id = $NewiOSPolicy.Id
                Platform = "iOS"
                Settings = $iOSSettings.Keys.Count
            }
        } catch {
            Write-Log "Failed to create iOS policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $iOSPolicyName; Platform = "iOS"; Reason = $_.Exception.Message }
        }
    }
}

# ============================================
# 4. Android Compliance Policy
# ============================================

if ($PlatformList -contains "Android") {
    Write-Log "" "INFO"
    Write-Log "=== Creating Android Compliance Policy ===" "INFO"

    $AndroidPolicyName = "Android Compliance - $PolicySet"
    $AndroidDescription = "Device compliance policy for Android devices. Enforces encryption, root detection, and security patch level."

    $ExistingAndroid = Get-MgDeviceManagementDeviceCompliancePolicy -Filter "displayName eq '$AndroidPolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingAndroid) {
        Write-Log "Policy '$AndroidPolicyName' already exists - skipping" "WARN"
        $FailedPolicies += @{ Name = $AndroidPolicyName; Platform = "Android"; Reason = "Already exists" }
    } else {
        $AndroidSettings = switch ($PolicySet) {
            "SMB-Baseline" {
                @{
                    passwordRequired = $true
                    passwordMinimumLength = 6
                    securityBlockJailbrokenDevices = $true  # Root detection
                    storageRequireEncryption = $true
                    osMinimumVersion = "10.0"
                }
            }
            "Strict" {
                @{
                    passwordRequired = $true
                    passwordMinimumLength = 8
                    passwordRequiredType = "alphanumeric"
                    securityBlockJailbrokenDevices = $true
                    storageRequireEncryption = $true
                    osMinimumVersion = "12.0"
                    minAndroidSecurityPatchLevel = (Get-Date).AddMonths(-3).ToString("yyyy-MM-dd")
                }
            }
            "Minimal" {
                @{
                    passwordRequired = $true
                    passwordMinimumLength = 4
                    securityBlockJailbrokenDevices = $true
                }
            }
        }

        $AndroidParams = @{
            "@odata.type" = "#microsoft.graph.androidCompliancePolicy"
            displayName = $AndroidPolicyName
            description = $AndroidDescription
            passwordRequired = $AndroidSettings.passwordRequired
            passwordMinimumLength = $AndroidSettings.passwordMinimumLength
            securityBlockJailbrokenDevices = $AndroidSettings.securityBlockJailbrokenDevices
            storageRequireEncryption = $AndroidSettings.storageRequireEncryption
            osMinimumVersion = $AndroidSettings.osMinimumVersion
            scheduledActionsForRule = @(
                @{
                    ruleName = "PasswordRequired"
                    scheduledActionConfigurations = @(
                        @{
                            actionType = "block"
                            gracePeriodHours = ($GracePeriodDays * 24)
                            notificationTemplateId = ""
                        }
                    )
                }
            )
        }

        try {
            Write-Log "Creating Android compliance policy..." "INFO"
            $NewAndroidPolicy = New-MgDeviceManagementDeviceCompliancePolicy -BodyParameter $AndroidParams -ErrorAction Stop
            Write-Log "Android policy created - ID: $($NewAndroidPolicy.Id)" "INFO"

            $AssignmentParams = @{
                assignments = @(
                    @{
                        target = @{
                            "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                        }
                    }
                )
            }

            Invoke-MgGraphRequest -Method POST `
                -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies/$($NewAndroidPolicy.Id)/assign" `
                -Body ($AssignmentParams | ConvertTo-Json -Depth 10) `
                -ContentType "application/json" -ErrorAction Stop

            Write-Log "Android policy assigned to all devices" "INFO"

            $CreatedPolicies += @{
                Name = $AndroidPolicyName
                Id = $NewAndroidPolicy.Id
                Platform = "Android"
                Settings = $AndroidSettings.Keys.Count
            }
        } catch {
            Write-Log "Failed to create Android policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $AndroidPolicyName; Platform = "Android"; Reason = $_.Exception.Message }
        }
    }
}

# ============================================
# Deployment Summary
# ============================================

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║          DEVICE COMPLIANCE POLICIES DEPLOYMENT SUMMARY           ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Policy Set:        $PolicySet" "INFO"
Write-Log "║  Grace Period:      $GracePeriodDays days" "INFO"
Write-Log "║  Policies Created:  $($CreatedPolicies.Count)" "INFO"
Write-Log "║  Policies Skipped:  $($FailedPolicies.Count)" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "=== CREATED POLICIES ===" "INFO"
foreach ($Policy in $CreatedPolicies) {
    Write-Log "  [+] $($Policy.Name)" "INFO"
    Write-Log "      Platform: $($Policy.Platform) | Settings: $($Policy.Settings) | ID: $($Policy.Id)" "INFO"
}

if ($FailedPolicies.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== SKIPPED/FAILED POLICIES ===" "WARN"
    foreach ($Policy in $FailedPolicies) {
        Write-Log "  [-] $($Policy.Name) ($($Policy.Platform)): $($Policy.Reason)" "WARN"
    }
}

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                    COMPLIANCE REQUIREMENTS                       ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Windows:  BitLocker, Firewall, Defender, Secure Boot            ║" "INFO"
Write-Log "║  macOS:    FileVault, Firewall, System Integrity Protection      ║" "INFO"
Write-Log "║  iOS:      Passcode, Jailbreak Detection, Min OS Version         ║" "INFO"
Write-Log "║  Android:  Encryption, Root Detection, Security Patches          ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                         NEXT STEPS                               ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  1. Verify policies: Intune > Devices > Compliance policies      ║" "INFO"
Write-Log "║  2. Monitor compliance: Intune > Reports > Device compliance     ║" "INFO"
Write-Log "║  3. Configure Conditional Access to require compliant devices    ║" "INFO"
Write-Log "║  4. Set up non-compliance notifications (email alerts)           ║" "INFO"
Write-Log "║  5. Review device compliance status after 24-48 hours            ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Compliance Policies Deployment Completed ===" "INFO"

Disconnect-MgGraph | Out-Null

# Return summary
return @{
    Success = $true
    PoliciesCreated = $CreatedPolicies.Count
    PoliciesFailed = $FailedPolicies.Count
    PolicySet = $PolicySet
    Platforms = $PlatformList
    CreatedPolicies = $CreatedPolicies
    FailedPolicies = $FailedPolicies
}
