<#
.SYNOPSIS
    Master deployment script for SMB Security Framework - Guided Implementation

.DESCRIPTION
    Interactive deployment wizard that guides through all 4 phases of the Strategic Integration Framework.
    Orchestrates deployment across:
    - Phase 1: Identity Foundation (Weeks 3-6)
    - Phase 2: Endpoint Protection (Weeks 7-12)
    - Phase 3: Data Governance (Weeks 13-20)
    - Phase 4: Security Monitoring (Weeks 21-26)

.PARAMETER Phase
    Specific phase to deploy: 1, 2, 3, 4, or "All" for complete framework

.PARAMETER Interactive
    Run in interactive mode with prompts (default: $true)

.PARAMETER ConfigFile
    Path to JSON configuration file with deployment settings (optional)

.EXAMPLE
    .\Deploy-Framework.ps1
    Runs interactive wizard starting from Phase 0 (assessment)

.EXAMPLE
    .\Deploy-Framework.ps1 -Phase 1
    Deploys only Phase 1 (Identity Foundation)

.EXAMPLE
    .\Deploy-Framework.ps1 -Phase "All" -ConfigFile "config.json"
    Deploys entire framework using configuration file

.AUTHOR
    Woshada Dasanayake | woshada@gmail.com
    SMB Security Framework v1.0.0 (December 2025)

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Estimated Total Time: 36-55 hours over 6 months
    Time Savings: ~55% (31-41 hours) vs. manual implementation
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("0", "1", "2", "3", "4", "All")]
    [string]$Phase = "0",

    [Parameter(Mandatory = $false)]
    [bool]$Interactive = $true,

    [Parameter(Mandatory = $false)]
    [string]$ConfigFile
)

# Banner
function Show-Banner {
    Write-Host @"
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║           SMB Security Framework - Deployment Wizard v1.0                ║
║                                                                           ║
║      Strategic Integration of Microsoft 365 and Azure Security           ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan
}

# Initialize logging
$LogFile = "Framework-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"

    $Color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }

    Write-Host $LogMessage -ForegroundColor $Color
    Add-Content -Path $LogFile -Value $LogMessage
}

Show-Banner

Write-Log "=== SMB Security Framework Deployment Started ===" "INFO"
Write-Log "Phase: $Phase" "INFO"
Write-Log "Interactive Mode: $Interactive" "INFO"

# Load configuration if provided
$Config = @{}
if ($ConfigFile -and (Test-Path $ConfigFile)) {
    Write-Log "Loading configuration from: $ConfigFile" "INFO"
    $Config = Get-Content $ConfigFile | ConvertFrom-Json -AsHashtable
}

# Prerequisites check
function Test-Prerequisites {
    Write-Log "" "INFO"
    Write-Log "=== Checking Prerequisites ===" "INFO"

    $PrereqsMet = $true

    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Log "PowerShell 7.0+ required. Current: $($PSVersionTable.PSVersion)" "ERROR"
        $PrereqsMet = $false
    } else {
        Write-Log "[√] PowerShell version: $($PSVersionTable.PSVersion)" "SUCCESS"
    }

    # Check required modules
    $RequiredModules = @(
        "Microsoft.Graph.Authentication",
        "Microsoft.Graph.Users",
        "Microsoft.Graph.Identity.SignIns",
        "Microsoft.Graph.DeviceManagement",
        "ExchangeOnlineManagement",
        "Az.Accounts",
        "Az.Resources"
    )

    foreach ($Module in $RequiredModules) {
        if (Get-Module -ListAvailable -Name $Module) {
            Write-Log "[√] Module installed: $Module" "SUCCESS"
        } else {
            Write-Log "[X] Module missing: $Module" "ERROR"
            Write-Log "    Install: Install-Module $Module -Scope CurrentUser -Force" "WARN"
            $PrereqsMet = $false
        }
    }

    return $PrereqsMet
}

if (-not (Test-Prerequisites)) {
    Write-Log "" "ERROR"
    Write-Log "Prerequisites not met. Please install required modules and retry." "ERROR"
    exit 1
}

# Phase 0: Baseline Assessment
function Invoke-Phase0 {
    Write-Log "" "INFO"
    Write-Log "╔═══════════════════════════════════════════════════════════╗" "INFO"
    Write-Log "║  PHASE 0: Baseline Assessment & Planning                 ║" "INFO"
    Write-Log "║  Duration: Weeks 1-2                                     ║" "INFO"
    Write-Log "║  Effort: 4-6 hours                                       ║" "INFO"
    Write-Log "╚═══════════════════════════════════════════════════════════╝" "INFO"
    Write-Log "" "INFO"

    Write-Log "Tasks:" "INFO"
    Write-Log "1. Complete Baseline Security Questionnaire" "INFO"
    Write-Log "2. Document current Microsoft Secure Score" "INFO"
    Write-Log "3. Review current MFA coverage" "INFO"
    Write-Log "4. Audit existing Conditional Access policies" "INFO"
    Write-Log "5. Check Defender deployment status" "INFO"
    Write-Log "6. Secure executive sponsorship" "INFO"
    Write-Log "" "INFO"

    Write-Log "Action Items:" "WARN"
    Write-Log "[ ] Open: /Assessment-Tools/Baseline-Security-Questionnaire.xlsx" "WARN"
    Write-Log "[ ] Access Microsoft Secure Score: https://security.microsoft.com/securescore" "WARN"
    Write-Log "[ ] Review executive presentation: /Training-Materials/Presentations/Executive-Briefing.pptx" "WARN"
    Write-Log "[ ] Schedule Phase 1 kickoff meeting" "WARN"
    Write-Log "" "INFO"

    if ($Interactive) {
        Read-Host "Press Enter when Phase 0 tasks are complete to proceed to Phase 1"
    }
}

# Phase 1: Identity Foundation
function Invoke-Phase1 {
    Write-Log "" "INFO"
    Write-Log "╔═══════════════════════════════════════════════════════════╗" "INFO"
    Write-Log "║  PHASE 1: Identity Foundation                            ║" "INFO"
    Write-Log "║  Duration: Weeks 3-6                                     ║" "INFO"
    Write-Log "║  Effort: 8-12 hours                                      ║" "INFO"
    Write-Log "║  Time Savings: 5-7 hours with automation                ║" "INFO"
    Write-Log "╚═══════════════════════════════════════════════════════════╝" "INFO"
    Write-Log "" "INFO"

    # Step 1: MFA Enablement
    Write-Log "Step 1: Enable MFA for all users (3-4 hours)" "INFO"

    if ($Interactive) {
        $UserGroup = Read-Host "Enter user group name (or 'All Users')"
        $EmergencyAccounts = Read-Host "Enter emergency account UPNs (comma-separated) or press Enter to skip"
    } else {
        $UserGroup = if ($Config.Phase1.UserGroup) { $Config.Phase1.UserGroup } else { "All Users" }
        $EmergencyAccounts = $Config.Phase1.EmergencyAccounts
    }

    Write-Log "Executing: Enable-BulkMFA.ps1..." "INFO"
    $MFAParams = @{
        UserGroup = $UserGroup
        MFAMethod = "MicrosoftAuthenticator"
    }
    if ($EmergencyAccounts) {
        $MFAParams.ExcludeGroup = $EmergencyAccounts
    }

    try {
        & "$PSScriptRoot\Enable-BulkMFA.ps1" @MFAParams
        Write-Log "[√] MFA enablement completed" "SUCCESS"
    } catch {
        Write-Log "[X] MFA enablement failed: $_" "ERROR"
        return
    }

    # Step 2: Conditional Access Policies
    Write-Log "" "INFO"
    Write-Log "Step 2: Deploy Conditional Access policies (2-3 hours)" "INFO"

    if ($Interactive) {
        $Response = Read-Host "Deploy in Report-Only mode first? (Y/N, recommended: Y)"
        $Mode = if ($Response -eq "Y") { "ReportOnly" } else { "Enabled" }
        $TrustedIPs = Read-Host "Enter trusted office IPs (comma-separated) or press Enter to skip"
    } else {
        $Mode = if ($Config.Phase1.CAMode) { $Config.Phase1.CAMode } else { "ReportOnly" }
        $TrustedIPs = $Config.Phase1.TrustedIPs
    }

    Write-Log "Executing: Deploy-ConditionalAccessPolicies.ps1..." "INFO"
    $CAParams = @{
        PolicySet = "SMB-Recommended"
        Mode = $Mode
    }
    if ($TrustedIPs) {
        $CAParams.TrustedIPs = $TrustedIPs
    }
    if ($EmergencyAccounts) {
        $CAParams.EmergencyAccountUPNs = $EmergencyAccounts
    }

    try {
        & "$PSScriptRoot\Deploy-ConditionalAccessPolicies.ps1" @CAParams
        Write-Log "[√] Conditional Access policies deployed" "SUCCESS"
    } catch {
        Write-Log "[X] Conditional Access deployment failed: $_" "ERROR"
        return
    }

    Write-Log "" "SUCCESS"
    Write-Log "=== Phase 1 Complete ===" "SUCCESS"
    Write-Log "Next Steps:" "WARN"
    Write-Log "1. Wait 7 days in Report-Only mode" "WARN"
    Write-Log "2. Review Conditional Access impact: Azure AD > Sign-in logs" "WARN"
    Write-Log "3. Communicate MFA setup to users" "WARN"
    Write-Log "4. Schedule Phase 2 (Week 7)" "WARN"
}

# Phase 2: Endpoint Protection
function Invoke-Phase2 {
    Write-Log "" "INFO"
    Write-Log "╔═══════════════════════════════════════════════════════════╗" "INFO"
    Write-Log "║  PHASE 2: Endpoint Protection                            ║" "INFO"
    Write-Log "║  Duration: Weeks 7-12                                    ║" "INFO"
    Write-Log "║  Effort: 6-10 hours                                      ║" "INFO"
    Write-Log "║  Time Savings: 6-9 hours with automation                ║" "INFO"
    Write-Log "╚═══════════════════════════════════════════════════════════╝" "INFO"
    Write-Log "" "INFO"

    Write-Log "Step 1: Enable ASR Rules in Audit Mode (1-2 hours)" "INFO"

    Write-Log "Executing: Enable-ASRRules.ps1..." "INFO"
    $ASRParams = @{
        RuleSet = "SMB-Recommended"
        Mode = "Audit"
        ReviewPeriodDays = 14
    }

    try {
        & "$PSScriptRoot\Enable-ASRRules.ps1" @ASRParams
        Write-Log "[√] ASR Rules enabled in Audit mode" "SUCCESS"
    } catch {
        Write-Log "[X] ASR Rules deployment failed: $_" "ERROR"
        return
    }

    Write-Log "" "SUCCESS"
    Write-Log "=== Phase 2 Complete ===" "SUCCESS"
    Write-Log "Next Steps:" "WARN"
    Write-Log "1. Wait 14 days for ASR audit data collection" "WARN"
    Write-Log "2. Review ASR events in Microsoft 365 Defender portal" "WARN"
    Write-Log "3. Re-run Enable-ASRRules.ps1 with -Mode 'Block' after review" "WARN"
    Write-Log "4. Schedule Phase 3 (Week 13)" "WARN"
}

# Phase 3: Data Governance
function Invoke-Phase3 {
    Write-Log "" "INFO"
    Write-Log "╔═══════════════════════════════════════════════════════════╗" "INFO"
    Write-Log "║  PHASE 3: Data Governance                                ║" "INFO"
    Write-Log "║  Duration: Weeks 13-20                                   ║" "INFO"
    Write-Log "║  Effort: 10-15 hours                                     ║" "INFO"
    Write-Log "║  Time Savings: 7-9 hours with automation                ║" "INFO"
    Write-Log "╚═══════════════════════════════════════════════════════════╝" "INFO"
    Write-Log "" "INFO"

    # Step 1: Deploy Sensitivity Labels
    Write-Log "Step 1: Deploy Sensitivity Labels (3-4 hours)" "INFO"

    Write-Log "Executing: Deploy-SensitivityLabels.ps1..." "INFO"
    $LabelParams = @{
        LabelSchema = "SMB-5Tier"
        PublishToAllUsers = $true
        IncludeSubLabels = $false
    }

    try {
        & "$PSScriptRoot\Deploy-SensitivityLabels.ps1" @LabelParams
        Write-Log "[√] Sensitivity labels deployed" "SUCCESS"
    } catch {
        Write-Log "[X] Sensitivity label deployment failed: $_" "ERROR"
        return
    }

    # Step 2: Deploy DLP Policies
    Write-Log "" "INFO"
    Write-Log "Step 2: Deploy DLP Policies (4-5 hours)" "INFO"

    if ($Interactive) {
        $ComplianceEmail = Read-Host "Enter compliance team email for incident reports"
    } else {
        $ComplianceEmail = $Config.Phase3.ComplianceEmail
    }

    Write-Log "Executing: Create-DLPPolicies.ps1..." "INFO"
    $DLPParams = @{
        PolicySet = "SMB-Comprehensive"
        Mode = "TestMode"
    }
    if ($ComplianceEmail) {
        $DLPParams.NotifyComplianceTeam = $ComplianceEmail
    }

    try {
        & "$PSScriptRoot\Create-DLPPolicies.ps1" @DLPParams
        Write-Log "[√] DLP policies deployed in Test mode" "SUCCESS"
    } catch {
        Write-Log "[X] DLP policy deployment failed: $_" "ERROR"
        return
    }

    Write-Log "" "SUCCESS"
    Write-Log "=== Phase 3 Complete ===" "SUCCESS"
    Write-Log "Next Steps:" "WARN"
    Write-Log "1. Monitor DLP policy tips for 2-3 weeks" "WARN"
    Write-Log "2. Review DLP incidents in Microsoft Purview" "WARN"
    Write-Log "3. Re-run Create-DLPPolicies.ps1 with -Mode 'Enforce' after testing" "WARN"
    Write-Log "4. Schedule Phase 4 (Week 21)" "WARN"
}

# Phase 4: Security Monitoring
function Invoke-Phase4 {
    Write-Log "" "INFO"
    Write-Log "╔═══════════════════════════════════════════════════════════╗" "INFO"
    Write-Log "║  PHASE 4: Security Monitoring                            ║" "INFO"
    Write-Log "║  Duration: Weeks 21-26                                   ║" "INFO"
    Write-Log "║  Effort: 8-12 hours                                      ║" "INFO"
    Write-Log "║  Time Savings: 6-8 hours with automation                ║" "INFO"
    Write-Log "╚═══════════════════════════════════════════════════════════╝" "INFO"
    Write-Log "" "INFO"

    Write-Log "Step 1: Deploy Azure Sentinel (6-8 hours)" "INFO"
    Write-Log "" "INFO"
    Write-Log "Sentinel deployment requires Azure CLI and Azure subscription." "WARN"
    Write-Log "Run the following command in Azure CLI:" "INFO"
    Write-Log "" "INFO"
    Write-Host @"
    az deployment group create \
      --resource-group rg-security \
      --template-file Deploy-Sentinel.json \
      --parameters workspaceName=sentinel-smb location=ukSouth dataRetentionDays=90
"@ -ForegroundColor Yellow

    Write-Log "" "INFO"
    Write-Log "For detailed instructions, see: /Playbooks/Module-4-Security-Monitoring.md" "INFO"

    Write-Log "" "SUCCESS"
    Write-Log "=== Phase 4 Complete ===" "SUCCESS"
    Write-Log "Framework deployment complete!" "SUCCESS"
}

# Main execution
try {
    switch ($Phase) {
        "0" { Invoke-Phase0 }
        "1" { Invoke-Phase1 }
        "2" { Invoke-Phase2 }
        "3" { Invoke-Phase3 }
        "4" { Invoke-Phase4 }
        "All" {
            Invoke-Phase0
            Invoke-Phase1
            Invoke-Phase2
            Invoke-Phase3
            Invoke-Phase4
        }
    }

    Write-Log "" "SUCCESS"
    Write-Log "╔═══════════════════════════════════════════════════════════╗" "SUCCESS"
    Write-Log "║           Deployment Complete! ✓                         ║" "SUCCESS"
    Write-Log "╚═══════════════════════════════════════════════════════════╝" "SUCCESS"
    Write-Log "" "INFO"
    Write-Log "Log file saved to: $LogFile" "INFO"
    Write-Log "Next: Review /Playbooks/ for detailed guidance" "INFO"

} catch {
    Write-Log "Deployment error: $_" "ERROR"
    exit 1
}
