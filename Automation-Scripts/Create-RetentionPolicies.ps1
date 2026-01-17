<#
.SYNOPSIS
    Create retention policies for Microsoft 365 compliance.

.DESCRIPTION
    Creates retention policies for Email, SharePoint/OneDrive, Teams, and labeled content.
    Part of the Strategic Integration Framework for SMB Security - Module 3: Data Governance.

    Creates 4 retention policies:
    1. Email Retention (7 years - GDPR compliance)
    2. SharePoint/OneDrive Document Retention (5 years)
    3. Teams Conversations Retention (1 year)
    4. Restricted Data Short Retention (90 days)

.PARAMETER EmailRetentionYears
    Years to retain email (default: 7 for GDPR compliance)

.PARAMETER DocumentRetentionYears
    Years to retain SharePoint/OneDrive documents (default: 5)

.PARAMETER TeamsRetentionYears
    Years to retain Teams conversations (default: 1)

.EXAMPLE
    .\Create-RetentionPolicies.ps1 -EmailRetentionYears 7 -DocumentRetentionYears 5

.AUTHOR
    Woshada Dasanayake | woshada@gmail.com
    SMB Security Framework v1.0.0 (December 2025)

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - Microsoft 365 E3/E5 or Business Premium
    - Compliance Administrator role
    - ExchangeOnlineManagement module
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [int]$EmailRetentionYears = 7,

    [Parameter(Mandatory = $false)]
    [int]$DocumentRetentionYears = 5,

    [Parameter(Mandatory = $false)]
    [int]$TeamsRetentionYears = 1
)

#Requires -Modules ExchangeOnlineManagement

# Initialize logging
$LogFile = "Retention-Policies-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Retention Policies Deployment Started ===" "INFO"
Write-Log "Email Retention: $EmailRetentionYears years" "INFO"
Write-Log "Document Retention: $DocumentRetentionYears years" "INFO"
Write-Log "Teams Retention: $TeamsRetentionYears years" "INFO"

# Connect to Security & Compliance Center
try {
    Write-Log "Connecting to Security & Compliance Center..." "INFO"
    Write-Log "If prompted, sign in with your admin credentials..." "INFO"

    # Check if already connected
    $ExistingSession = Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" -and $_.State -eq "Opened" }
    if (-not $ExistingSession) {
        Connect-IPPSSession -WarningAction SilentlyContinue -ErrorAction Stop
    } else {
        Write-Log "Using existing Security & Compliance session" "INFO"
    }
    Write-Log "Successfully connected" "INFO"
} catch {
    Write-Log "Failed to connect: $_" "ERROR"
    Write-Log "TIP: Try running 'Connect-IPPSSession' manually first, then re-run this script" "WARN"
    exit 1
}

# Define Retention Policies
$RetentionPolicies = @(
    @{
        Name = "Retention-001-Email-7Years"
        DisplayName = "Email Retention - $EmailRetentionYears Years"
        Comment = "Retains all email for $EmailRetentionYears years for GDPR Article 5(e) compliance"
        RetentionDuration = $EmailRetentionYears * 365
        RetentionAction = "KeepAndDelete"
        Locations = @{
            ExchangeLocation = "All"
        }
    },
    @{
        Name = "Retention-002-Documents-5Years"
        DisplayName = "Document Retention - $DocumentRetentionYears Years"
        Comment = "Retains SharePoint and OneDrive documents for $DocumentRetentionYears years"
        RetentionDuration = $DocumentRetentionYears * 365
        RetentionAction = "KeepAndDelete"
        Locations = @{
            SharePointLocation = "All"
            OneDriveLocation = "All"
        }
    },
    @{
        Name = "Retention-003-Teams-1Year"
        DisplayName = "Teams Retention - $TeamsRetentionYears Year(s)"
        Comment = "Retains Teams conversations for $TeamsRetentionYears year(s) to manage storage costs"
        RetentionDuration = $TeamsRetentionYears * 365
        RetentionAction = "KeepAndDelete"
        Locations = @{
            TeamsChannelLocation = "All"
            TeamsChatLocation = "All"
        }
    },
    @{
        Name = "Retention-004-Restricted-90Days"
        DisplayName = "Restricted Data - 90 Days"
        Comment = "Short retention for highly sensitive data to minimize exposure risk"
        RetentionDuration = 90
        RetentionAction = "KeepAndDelete"
        ContentMatchQuery = "SensitivityLabel:Restricted"
        Locations = @{
            ExchangeLocation = "All"
            SharePointLocation = "All"
            OneDriveLocation = "All"
        }
    }
)

Write-Log "Creating $($RetentionPolicies.Count) retention policies..." "INFO"

$CreatedCount = 0
$SkippedCount = 0
$ErrorCount = 0

foreach ($PolicyConfig in $RetentionPolicies) {
    try {
        Write-Log "" "INFO"
        Write-Log "Creating retention policy: $($PolicyConfig.DisplayName)..." "INFO"

        # Check if policy already exists
        $ExistingPolicy = Get-RetentionCompliancePolicy -Identity $PolicyConfig.Name -ErrorAction SilentlyContinue

        if ($ExistingPolicy) {
            Write-Log "  Policy already exists - Skipping" "WARN"
            $SkippedCount++
            continue
        }

        if ($PSCmdlet.ShouldProcess($PolicyConfig.DisplayName, "Create retention policy")) {
            # Create retention policy
            $PolicyParams = @{
                Name = $PolicyConfig.Name
                Comment = $PolicyConfig.Comment
            }

            # Add locations
            if ($PolicyConfig.Locations.ExchangeLocation) {
                $PolicyParams.ExchangeLocation = $PolicyConfig.Locations.ExchangeLocation
            }
            if ($PolicyConfig.Locations.SharePointLocation) {
                $PolicyParams.SharePointLocation = $PolicyConfig.Locations.SharePointLocation
            }
            if ($PolicyConfig.Locations.OneDriveLocation) {
                $PolicyParams.OneDriveLocation = $PolicyConfig.Locations.OneDriveLocation
            }
            if ($PolicyConfig.Locations.TeamsChannelLocation) {
                $PolicyParams.TeamsChannelLocation = $PolicyConfig.Locations.TeamsChannelLocation
            }
            if ($PolicyConfig.Locations.TeamsChatLocation) {
                $PolicyParams.TeamsChatLocation = $PolicyConfig.Locations.TeamsChatLocation
            }

            $NewPolicy = New-RetentionCompliancePolicy @PolicyParams
            Write-Log "  Created policy: $($NewPolicy.Guid)" "INFO"

            # Create retention rule for the policy
            $RuleName = "$($PolicyConfig.Name)-Rule"
            $RuleParams = @{
                Name = $RuleName
                Policy = $PolicyConfig.Name
                RetentionDuration = $PolicyConfig.RetentionDuration
                RetentionComplianceAction = $PolicyConfig.RetentionAction
                ExpirationDateOption = "CreationAgeInDays"
            }

            # Add content match query for label-based policies
            if ($PolicyConfig.ContentMatchQuery) {
                $RuleParams.ContentMatchQuery = $PolicyConfig.ContentMatchQuery
            }

            $NewRule = New-RetentionComplianceRule @RuleParams
            Write-Log "  Created rule: $($NewRule.Guid)" "INFO"

            $CreatedCount++
        }
    } catch {
        Write-Log "  Error creating policy $($PolicyConfig.DisplayName): $_" "ERROR"
        $ErrorCount++
    }
}

# Summary
Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║           RETENTION POLICIES DEPLOYMENT SUMMARY                  ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Policies Created:    $CreatedCount                                          ║" "INFO"
Write-Log "║  Policies Skipped:    $SkippedCount                                          ║" "INFO"
Write-Log "║  Errors:              $ErrorCount                                          ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "=== RETENTION POLICY DETAILS ===" "INFO"
Write-Log "  [1] Email Retention:     $EmailRetentionYears years (GDPR compliance)" "INFO"
Write-Log "  [2] Document Retention:  $DocumentRetentionYears years (SharePoint/OneDrive)" "INFO"
Write-Log "  [3] Teams Retention:     $TeamsRetentionYears year(s) (storage management)" "INFO"
Write-Log "  [4] Restricted Data:     90 days (minimize exposure)" "INFO"

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                         NEXT STEPS                               ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  1. Policies take up to 24 hours to apply                        ║" "INFO"
Write-Log "║  2. Monitor: Microsoft Purview > Data lifecycle management       ║" "INFO"
Write-Log "║  3. Review retention reports after 7 days                        ║" "INFO"
Write-Log "║  4. Adjust retention periods based on regulatory requirements    ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "COMPLIANCE NOTES:" "WARN"
Write-Log "  - GDPR Article 5(e): Data should not be kept longer than necessary" "WARN"
Write-Log "  - Retention policies help demonstrate compliance during audits" "WARN"
Write-Log "  - Consider legal hold policies for litigation scenarios" "WARN"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Retention Policies Deployment Completed ===" "INFO"

# Disconnect
Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
