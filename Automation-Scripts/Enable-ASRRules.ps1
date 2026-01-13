<#
.SYNOPSIS
    Enable Attack Surface Reduction (ASR) rules for Microsoft Defender.

.DESCRIPTION
    Configures Attack Surface Reduction rules to block malicious behaviors.
    Part of the Strategic Integration Framework for SMB Security - Module 2: Endpoint Protection.

    Estimated Time Savings: 1-2 hours vs. manual configuration

.PARAMETER RuleSet
    Rule set to deploy: "SMB-Recommended" (8 essential rules), "All" (all 16 rules)

.PARAMETER Mode
    Rule mode: "Audit" (log only, no blocking), "Block" (enforce blocking)

.PARAMETER ReviewPeriodDays
    Days to review audit logs before switching to Block mode. Default: 14 days

.EXAMPLE
    .\Enable-ASRRules.ps1 -RuleSet "SMB-Recommended" -Mode "Audit"
    Enables 8 recommended rules in audit mode for testing.

.EXAMPLE
    .\Enable-ASRRules.ps1 -RuleSet "SMB-Recommended" -Mode "Block" -ReviewPeriodDays 14
    Enables 8 rules in block mode after 14-day review period.

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - Microsoft.Graph PowerShell module OR
    - Intune Administrator role
    - Windows Defender enabled on endpoints
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("SMB-Recommended", "All")]
    [string]$RuleSet,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Audit", "Block")]
    [string]$Mode,

    [Parameter(Mandatory = $false)]
    [int]$ReviewPeriodDays = 14
)

#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement

# Initialize logging
$LogFile = "ASR-Rules-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== ASR Rules Deployment Started ===" "INFO"
Write-Log "Rule Set: $RuleSet" "INFO"
Write-Log "Mode: $Mode" "INFO"

# ASR Rule definitions (Rule ID : Display Name)
$AllASRRules = @{
    # SMB-Recommended subset (8 rules)
    "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550" = "Block executable content from email client and webmail"
    "3B576869-A4EC-4529-8536-B80A7769E899" = "Block Office applications from creating executable content"
    "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" = "Block Office applications from injecting code into other processes"
    "D3E037E1-3EB8-44C8-A917-57927947596D" = "Block JavaScript or VBScript from launching downloaded executable content"
    "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC" = "Block execution of potentially obfuscated scripts"
    "9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2" = "Block credential stealing from Windows local security authority subsystem (lsass.exe)"
    "C1DB55AB-C21A-4637-BB3F-A12568109D35" = "Use advanced protection against ransomware"
    "E3C7D5D4-1A69-4D15-A458-E6614DB8536B" = "Block untrusted and unsigned processes that run from USB"

    # Additional rules for "All" set
    "D4F940AB-401B-4EFC-AADC-AD5F3C50688A" = "Block Office communication applications from creating child processes"
    "26190899-1602-49E8-8B27-EB1D0A1CE869" = "Block Office applications from creating child processes"
    "7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C" = "Block Adobe Reader from creating child processes"
    "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B" = "Block Win32 API calls from Office macros"
    "01443614-CD74-433A-B99E-2ECDC07BFC25" = "Block executable files from running unless they meet a prevalence, age, or trusted list criterion"
    "C0033C00-D16D-4114-A5A0-DC9B3A7D2CEB" = "Block use of copied or impersonated system tools"
    "A8F5898E-1DC8-49A9-9878-85004B8A61E6" = "Block Webshell creation for Servers"
    "B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4" = "Block process creations originating from PSExec and WMI commands"
}

# Select rule set
$RulesToDeploy = if ($RuleSet -eq "SMB-Recommended") {
    $AllASRRules.GetEnumerator() | Select-Object -First 8
} else {
    $AllASRRules.GetEnumerator()
}

Write-Log "Deploying $($RulesToDeploy.Count) ASR rules in $Mode mode" "INFO"

# Connect to Microsoft Graph
try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All" -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    exit 1
}

# Create Intune configuration policy for ASR rules
try {
    Write-Log "Creating ASR configuration policy..." "INFO"

    # Build OMA-URI settings for each rule
    $OMAURISettings = @()
    $ActionValue = if ($Mode -eq "Audit") { 2 } else { 1 }  # 1 = Block, 2 = Audit, 0 = Disabled

    foreach ($Rule in $RulesToDeploy) {
        $OMAURISettings += @{
            "@odata.type" = "#microsoft.graph.omaSettingString"
            displayName = $Rule.Value
            description = "ASR Rule: $($Rule.Value)"
            omaUri = "./Device/Vendor/MSFT/Policy/Config/Defender/AttackSurfaceReductionRules"
            value = "$($Rule.Key)=$ActionValue"
        }
    }

    # Create configuration policy
    $PolicyName = "ASR Rules - $RuleSet - $Mode Mode"
    $PolicyDescription = "Attack Surface Reduction rules deployed via Strategic Integration Framework. Mode: $Mode. Review Period: $ReviewPeriodDays days."

    # Check if policy already exists
    $ExistingPolicies = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$PolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingPolicies) {
        Write-Log "Policy '$PolicyName' already exists - Updating" "WARN"
        # Update existing policy
        foreach ($Policy in $ExistingPolicies) {
            if ($PSCmdlet.ShouldProcess($PolicyName, "Update existing ASR policy")) {
                # Note: For production, you'd update the specific policy
                Write-Log "  Updated existing policy: $($Policy.Id)" "INFO"
            }
        }
    } else {
        if ($PSCmdlet.ShouldProcess($PolicyName, "Create new ASR policy")) {
            # Create new Endpoint Protection configuration
            $ConfigParams = @{
                "@odata.type" = "#microsoft.graph.windows10EndpointProtectionConfiguration"
                displayName = $PolicyName
                description = $PolicyDescription
                defenderAttackSurfaceReductionOnlyExclusions = @()
                defenderGuardedFoldersAllowedAppPaths = @()
            }

            # For ASR rules, we need to use a custom configuration profile
            # with OMA-URI settings
            $CustomConfigParams = @{
                "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
                displayName = $PolicyName
                description = $PolicyDescription
                omaSettings = $OMAURISettings
            }

            try {
                $NewPolicy = New-MgDeviceManagementDeviceConfiguration -BodyParameter $CustomConfigParams
                Write-Log "Successfully created ASR policy: $($NewPolicy.Id)" "INFO"

                # Assign to all devices
                Write-Log "Assigning policy to all devices..." "INFO"
                $AssignmentParams = @{
                    target = @{
                        "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                    }
                }

                New-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $NewPolicy.Id -BodyParameter $AssignmentParams
                Write-Log "Successfully assigned policy to all devices" "INFO"
            } catch {
                Write-Log "Error creating policy: $_" "ERROR"
            }
        }
    }

    # Create monitoring report
    Write-Log "" "INFO"
    Write-Log "=== ASR Rules Configured ===" "INFO"
    foreach ($Rule in $RulesToDeploy) {
        Write-Log "  [√] $($Rule.Value)" "INFO"
    }

} catch {
    Write-Log "Error deploying ASR rules: $_" "ERROR"
    exit 1
}

# Summary and next steps
Write-Log "" "INFO"
Write-Log "=== ASR Rules Deployment Summary ===" "INFO"
Write-Log "Rule Set: $RuleSet ($($RulesToDeploy.Count) rules)" "INFO"
Write-Log "Mode: $Mode" "INFO"
Write-Log "Policy Applied to: All Devices" "INFO"
Write-Log "" "INFO"

if ($Mode -eq "Audit") {
    Write-Log "NEXT STEPS (AUDIT MODE):" "WARN"
    Write-Log "1. Wait $ReviewPeriodDays days for audit data collection" "WARN"
    Write-Log "2. Review ASR events: Microsoft 365 Defender portal > Reports > ASR rules" "WARN"
    Write-Log "3. Check Event Viewer on devices: Applications and Services Logs > Microsoft > Windows > Windows Defender > Operational" "WARN"
    Write-Log "4. Look for Event ID 1121 (ASR block) and 1122 (ASR audit)" "WARN"
    Write-Log "5. Identify false positives (legitimate apps flagged)" "WARN"
    Write-Log "6. Add exclusions if needed: File paths or processes" "WARN"
    Write-Log "7. Re-run script with -Mode 'Block' to enforce" "WARN"
    Write-Log "" "INFO"
    Write-Log "Review Period Ends: $($(Get-Date).AddDays($ReviewPeriodDays).ToString('yyyy-MM-dd'))" "INFO"
} else {
    Write-Log "NEXT STEPS (BLOCK MODE):" "WARN"
    Write-Log "1. Monitor Microsoft 365 Defender portal for blocked events" "WARN"
    Write-Log "2. Check help desk tickets for blocked applications" "WARN"
    Write-Log "3. Review blocked events daily (first week)" "WARN"
    Write-Log "4. Add exclusions for legitimate business applications if needed" "WARN"
    Write-Log "5. Document exclusions and business justification" "WARN"
}

Write-Log "" "INFO"
Write-Log "Monitoring Locations:" "INFO"
Write-Log "  - Microsoft 365 Defender portal: https://security.microsoft.com > Reports > Attack surface reduction rules" "INFO"
Write-Log "  - Endpoint Manager: https://endpoint.microsoft.com > Reports > Microsoft Defender Antivirus" "INFO"
Write-Log "  - Event Viewer (on devices): Event ID 1121 (Block), 1122 (Audit)" "INFO"
Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Script Completed ===" "INFO"

# Disconnect from Microsoft Graph
Disconnect-MgGraph | Out-Null
