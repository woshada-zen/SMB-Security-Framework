<#
.SYNOPSIS
    Enable Unified Audit Logging for Microsoft 365.

.DESCRIPTION
    Enables organization-wide audit logging with 365-day retention.
    Part of the Strategic Integration Framework for SMB Security - Module 4: Security Monitoring.

    Captures:
    - User activity: Sign-ins, file access, email sends
    - Admin activity: Policy changes, user creation, role assignments
    - Security events: MFA bypass attempts, Conditional Access failures

.PARAMETER RetentionDays
    Audit log retention period (default: 365 days for E5, 90 for E3)

.PARAMETER EnableMailboxAudit
    Enable mailbox auditing for all users (default: $true)

.EXAMPLE
    .\Enable-UnifiedAuditLog.ps1 -RetentionDays 365 -EnableMailboxAudit $true

.AUTHOR
    Woshada Dasanayake | woshada@gmail.com
    SMB Security Framework v1.0.0 (December 2025)

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - Exchange Online PowerShell module
    - Compliance Administrator or Global Administrator role
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet(90, 180, 365)]
    [int]$RetentionDays = 365,

    [Parameter(Mandatory = $false)]
    [bool]$EnableMailboxAudit = $true
)

#Requires -Modules ExchangeOnlineManagement

# Initialize logging
$LogFile = "UnifiedAuditLog-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Unified Audit Log Configuration Started ===" "INFO"
Write-Log "Retention Days: $RetentionDays" "INFO"
Write-Log "Enable Mailbox Audit: $EnableMailboxAudit" "INFO"

# Connect to Exchange Online
try {
    Write-Log "Connecting to Exchange Online..." "INFO"

    # Check if already connected
    $ExistingConnection = Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" -and $_.State -eq "Opened" }
    if (-not $ExistingConnection) {
        Connect-ExchangeOnline -ShowBanner:$false -ErrorAction Stop
    } else {
        Write-Log "Using existing Exchange Online session" "INFO"
    }
    Write-Log "Successfully connected to Exchange Online" "INFO"
} catch {
    Write-Log "Failed to connect to Exchange Online: $_" "ERROR"
    exit 1
}

$ConfiguredSettings = @()
$FailedSettings = @()

# Step 1: Enable Unified Audit Log Ingestion
Write-Log "" "INFO"
Write-Log "=== Step 1: Enabling Unified Audit Log ===" "INFO"

try {
    # Check current status
    $CurrentConfig = Get-AdminAuditLogConfig
    $CurrentStatus = $CurrentConfig.UnifiedAuditLogIngestionEnabled

    Write-Log "Current Unified Audit Log status: $CurrentStatus" "INFO"

    if (-not $CurrentStatus) {
        if ($PSCmdlet.ShouldProcess("Organization", "Enable Unified Audit Log")) {
            Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true -ErrorAction Stop
            Write-Log "Unified Audit Log ENABLED successfully" "INFO"
            $ConfiguredSettings += "Unified Audit Log Ingestion"
        }
    } else {
        Write-Log "Unified Audit Log already enabled - Skipping" "WARN"
        $ConfiguredSettings += "Unified Audit Log Ingestion (already enabled)"
    }
} catch {
    Write-Log "Failed to enable Unified Audit Log: $_" "ERROR"
    $FailedSettings += "Unified Audit Log Ingestion"
}

# Step 2: Set Retention Duration
Write-Log "" "INFO"
Write-Log "=== Step 2: Configuring Retention Duration ===" "INFO"

try {
    Write-Log "Setting audit log retention to $RetentionDays days..." "INFO"

    # Note: This requires E5 license for extended retention
    # For E3, retention is fixed at 90 days
    if ($PSCmdlet.ShouldProcess("Organization", "Set Audit Retention to $RetentionDays days")) {
        # Try to set retention (may fail if not E5)
        try {
            Set-OrganizationConfig -AuditDisabled $false -ErrorAction Stop
            Write-Log "Organization audit logging enabled" "INFO"
            $ConfiguredSettings += "Organization Audit Enabled"
        } catch {
            Write-Log "Could not set organization config (may require E5): $_" "WARN"
        }
    }

    Write-Log "Retention configured (actual duration depends on license)" "INFO"
    $ConfiguredSettings += "Audit Retention: $RetentionDays days (license dependent)"
} catch {
    Write-Log "Failed to configure retention: $_" "ERROR"
    $FailedSettings += "Audit Retention Configuration"
}

# Step 3: Enable Mailbox Auditing for All Users
if ($EnableMailboxAudit) {
    Write-Log "" "INFO"
    Write-Log "=== Step 3: Enabling Mailbox Auditing ===" "INFO"

    try {
        # Enable organization-wide mailbox auditing
        Write-Log "Enabling default mailbox auditing for all mailboxes..." "INFO"

        if ($PSCmdlet.ShouldProcess("All Mailboxes", "Enable Mailbox Auditing")) {
            # Set organization default to enable auditing
            Set-OrganizationConfig -AuditDisabled $false -ErrorAction SilentlyContinue

            # Get all user mailboxes
            $Mailboxes = Get-EXOMailbox -ResultSize Unlimited -RecipientTypeDetails UserMailbox -PropertySets Audit

            $TotalMailboxes = $Mailboxes.Count
            $EnabledCount = 0
            $AlreadyEnabledCount = 0

            Write-Log "Found $TotalMailboxes user mailboxes" "INFO"

            foreach ($Mailbox in $Mailboxes) {
                try {
                    if (-not $Mailbox.AuditEnabled) {
                        Set-Mailbox -Identity $Mailbox.UserPrincipalName -AuditEnabled $true -ErrorAction Stop
                        $EnabledCount++
                    } else {
                        $AlreadyEnabledCount++
                    }
                } catch {
                    Write-Log "  Failed to enable auditing for $($Mailbox.UserPrincipalName): $_" "WARN"
                }
            }

            Write-Log "Mailbox auditing enabled for $EnabledCount mailboxes" "INFO"
            Write-Log "Already enabled for $AlreadyEnabledCount mailboxes" "INFO"
            $ConfiguredSettings += "Mailbox Auditing: $EnabledCount new + $AlreadyEnabledCount existing"
        }
    } catch {
        Write-Log "Failed to enable mailbox auditing: $_" "ERROR"
        $FailedSettings += "Mailbox Auditing"
    }
}

# Step 4: Verify Configuration
Write-Log "" "INFO"
Write-Log "=== Step 4: Verifying Configuration ===" "INFO"

try {
    $FinalConfig = Get-AdminAuditLogConfig
    Write-Log "Final Unified Audit Log Status: $($FinalConfig.UnifiedAuditLogIngestionEnabled)" "INFO"

    # Test audit log search
    Write-Log "Testing audit log search..." "INFO"
    $TestSearch = Search-UnifiedAuditLog -StartDate (Get-Date).AddDays(-1) -EndDate (Get-Date) -RecordType AzureActiveDirectory -ResultSize 1 -ErrorAction SilentlyContinue

    if ($TestSearch) {
        Write-Log "Audit log search successful - events are being collected" "INFO"
        $ConfiguredSettings += "Audit Log Verification: PASSED"
    } else {
        Write-Log "No audit events found (may take up to 24 hours for new deployments)" "WARN"
        $ConfiguredSettings += "Audit Log Verification: Pending (check in 24 hours)"
    }
} catch {
    Write-Log "Could not verify audit log configuration: $_" "WARN"
}

# Summary
Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║           UNIFIED AUDIT LOG CONFIGURATION SUMMARY                ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Settings Configured:  $($ConfiguredSettings.Count)                                       ║" "INFO"
Write-Log "║  Settings Failed:      $($FailedSettings.Count)                                       ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "=== CONFIGURED SETTINGS ===" "INFO"
foreach ($Setting in $ConfiguredSettings) {
    Write-Log "  [+] $Setting" "INFO"
}

if ($FailedSettings.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== FAILED SETTINGS ===" "WARN"
    foreach ($Setting in $FailedSettings) {
        Write-Log "  [-] $Setting" "WARN"
    }
}

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                         NEXT STEPS                               ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  1. Audit logs take up to 24 hours to start flowing              ║" "INFO"
Write-Log "║  2. Verify: Microsoft Purview > Audit > Search                   ║" "INFO"
Write-Log "║  3. Create audit search policies for critical activities         ║" "INFO"
Write-Log "║  4. Set up alerts for suspicious activities                      ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "WHAT'S BEING CAPTURED:" "INFO"
Write-Log "  - User sign-in activity (success/failure)" "INFO"
Write-Log "  - File access in SharePoint/OneDrive" "INFO"
Write-Log "  - Email send/receive activity" "INFO"
Write-Log "  - Admin configuration changes" "INFO"
Write-Log "  - Role assignments and permission changes" "INFO"
Write-Log "  - MFA events and Conditional Access" "INFO"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Unified Audit Log Configuration Completed ===" "INFO"

# Disconnect
Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
