<#
.SYNOPSIS
    Configure Microsoft Defender Portal settings.

.DESCRIPTION
    Configures Microsoft 365 Defender portal settings including email notifications,
    automated investigation settings, and alert configurations.
    Part of the Strategic Integration Framework for SMB Security - Module 4: Security Monitoring.

.PARAMETER SecurityTeamEmail
    Email address for security team notifications

.PARAMETER EnableAutoRemediation
    Enable automatic remediation for high-confidence threats (default: $true)

.EXAMPLE
    .\Configure-DefenderPortal.ps1 -SecurityTeamEmail "security@contoso.com"

.AUTHOR
    Woshada Dasanayake | woshada@gmail.com
    SMB Security Framework v1.0.0 (December 2025)

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - Microsoft 365 E5 or Defender for Endpoint P2
    - Security Administrator role
    - Microsoft.Graph.Security module
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$SecurityTeamEmail,

    [Parameter(Mandatory = $false)]
    [bool]$EnableAutoRemediation = $true
)

# Initialize logging
$LogFile = "DefenderPortal-Config-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Microsoft Defender Portal Configuration Started ===" "INFO"
Write-Log "Security Team Email: $SecurityTeamEmail" "INFO"
Write-Log "Auto-Remediation: $EnableAutoRemediation" "INFO"

# Connect to Microsoft Graph
try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes @(
        "SecurityEvents.ReadWrite.All",
        "ThreatIndicators.ReadWrite.OwnedBy",
        "SecurityActions.ReadWrite.All"
    ) -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    Write-Log "Some configurations require manual setup in Defender Portal" "WARN"
}

$ConfiguredSettings = @()
$ManualSteps = @()

# Step 1: Document Email Notification Settings
Write-Log "" "INFO"
Write-Log "=== Step 1: Email Notification Configuration ===" "INFO"

Write-Log "Email notifications must be configured manually in Defender Portal:" "INFO"
Write-Log "  1. Navigate to: https://security.microsoft.com" "INFO"
Write-Log "  2. Settings > Microsoft 365 Defender > Email notifications" "INFO"
Write-Log "  3. Add notification recipient: $SecurityTeamEmail" "INFO"
Write-Log "  4. Enable notifications for:" "INFO"
Write-Log "     - High severity incidents" "INFO"
Write-Log "     - Compromised users detected" "INFO"
Write-Log "     - Malware campaigns detected" "INFO"
Write-Log "     - Automated investigation completed" "INFO"

$ManualSteps += "Configure email notifications for $SecurityTeamEmail"

# Step 2: Automated Investigation Settings
Write-Log "" "INFO"
Write-Log "=== Step 2: Automated Investigation & Response (AIR) ===" "INFO"

Write-Log "AIR settings to configure in Defender Portal:" "INFO"
Write-Log "  1. Settings > Endpoints > Advanced features" "INFO"
Write-Log "  2. Enable: Automated Investigation" "INFO"
Write-Log "  3. Enable: Auto-remediation for high-confidence threats" "INFO"
Write-Log "" "INFO"
Write-Log "Recommended approval levels:" "INFO"
Write-Log "  - Fully automated: Malware quarantine, file deletion" "INFO"
Write-Log "  - Require approval: User account disable, network isolation" "INFO"

$ManualSteps += "Enable Automated Investigation and Response"

# Step 3: Incident Assignment Rules
Write-Log "" "INFO"
Write-Log "=== Step 3: Incident Assignment Rules ===" "INFO"

Write-Log "Configure incident assignment in Defender Portal:" "INFO"
Write-Log "  1. Settings > Microsoft 365 Defender > Incident assignment" "INFO"
Write-Log "  2. Create rule: Auto-assign high severity incidents" "INFO"
Write-Log "  3. Assign to: Security Team or specific analyst" "INFO"

$ManualSteps += "Configure incident auto-assignment rules"

# Step 4: Alert Policies
Write-Log "" "INFO"
Write-Log "=== Step 4: Alert Policy Configuration ===" "INFO"

try {
    # Connect to Security & Compliance for alert policies
    Write-Log "Connecting to Security & Compliance Center..." "INFO"
    Connect-IPPSSession -WarningAction SilentlyContinue -ErrorAction Stop

    # Get existing alert policies
    $AlertPolicies = Get-ProtectionAlert -ErrorAction SilentlyContinue

    if ($AlertPolicies) {
        $EnabledCount = ($AlertPolicies | Where-Object { $_.Disabled -eq $false }).Count
        $TotalCount = $AlertPolicies.Count
        Write-Log "Found $TotalCount alert policies ($EnabledCount enabled)" "INFO"

        # List high severity policies
        $HighSeverity = $AlertPolicies | Where-Object { $_.Severity -eq "High" -and $_.Disabled -eq $false }
        Write-Log "High severity policies enabled: $($HighSeverity.Count)" "INFO"

        $ConfiguredSettings += "Alert Policies: $EnabledCount of $TotalCount enabled"
    }

    # Check for existing admin role change alerts
    $AdminRoleAlerts = $AlertPolicies | Where-Object {
        $_.Name -like "*admin*" -or $_.Name -like "*role*" -or $_.Name -like "*privilege*"
    }

    if ($AdminRoleAlerts) {
        Write-Log "Found $($AdminRoleAlerts.Count) existing admin/role alert policies" "INFO"
        $ConfiguredSettings += "Admin Role Alerts: $($AdminRoleAlerts.Count) existing policies"
    } else {
        Write-Log "NOTE: Consider creating custom alerts for admin role changes in Purview" "WARN"
        $ManualSteps += "Create custom alert for admin role assignments"
    }

} catch {
    Write-Log "Could not configure alert policies: $_" "WARN"
    $ManualSteps += "Review and enable alert policies"
}

# Step 5: Secure Score Baseline
Write-Log "" "INFO"
Write-Log "=== Step 5: Secure Score Baseline ===" "INFO"

try {
    Write-Log "Retrieving current Secure Score..." "INFO"

    $SecureScore = Invoke-MgGraphRequest -Method GET `
        -Uri "https://graph.microsoft.com/v1.0/security/secureScores?`$top=1" `
        -ErrorAction SilentlyContinue

    if ($SecureScore -and $SecureScore.value) {
        $CurrentScore = $SecureScore.value[0]
        $ScorePercentage = [math]::Round(($CurrentScore.currentScore / $CurrentScore.maxScore) * 100, 1)

        Write-Log "Current Secure Score: $($CurrentScore.currentScore) / $($CurrentScore.maxScore) ($ScorePercentage%)" "INFO"
        $ConfiguredSettings += "Secure Score Baseline: $ScorePercentage%"

        # Get improvement actions
        $Actions = Invoke-MgGraphRequest -Method GET `
            -Uri "https://graph.microsoft.com/v1.0/security/secureScoreControlProfiles?`$top=10" `
            -ErrorAction SilentlyContinue

        if ($Actions -and $Actions.value) {
            Write-Log "" "INFO"
            Write-Log "Top improvement actions available:" "INFO"
            $TopActions = $Actions.value | Select-Object -First 5
            foreach ($Action in $TopActions) {
                Write-Log "  - $($Action.title)" "INFO"
            }
        }
    }
} catch {
    Write-Log "Could not retrieve Secure Score: $_" "WARN"
    $ManualSteps += "Check Secure Score at https://security.microsoft.com/securescore"
}

# Summary
Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║         DEFENDER PORTAL CONFIGURATION SUMMARY                    ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Settings Configured:  $($ConfiguredSettings.Count)                                       ║" "INFO"
Write-Log "║  Manual Steps Needed:  $($ManualSteps.Count)                                       ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

if ($ConfiguredSettings.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== CONFIGURED SETTINGS ===" "INFO"
    foreach ($Setting in $ConfiguredSettings) {
        Write-Log "  [+] $Setting" "INFO"
    }
}

if ($ManualSteps.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== MANUAL CONFIGURATION REQUIRED ===" "WARN"
    Write-Log "Complete these steps in the Defender Portal:" "WARN"
    Write-Log "" "INFO"
    $StepNum = 1
    foreach ($Step in $ManualSteps) {
        Write-Log "  $StepNum. $Step" "WARN"
        $StepNum++
    }
}

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                      PORTAL LINKS                                ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Defender Portal:    https://security.microsoft.com              ║" "INFO"
Write-Log "║  Incidents:          https://security.microsoft.com/incidents    ║" "INFO"
Write-Log "║  Secure Score:       https://security.microsoft.com/securescore  ║" "INFO"
Write-Log "║  Hunting:            https://security.microsoft.com/hunting      ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Defender Portal Configuration Completed ===" "INFO"

# Disconnect
Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
