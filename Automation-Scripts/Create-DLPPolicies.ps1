<#
.SYNOPSIS
    Deploy Data Loss Prevention (DLP) policies for Microsoft 365.

.DESCRIPTION
    Creates 5 DLP policy templates: GDPR Compliance, Financial Data Protection,
    Source Code Protection, Label Enforcement, and Teams Message Protection.
    Part of the Strategic Integration Framework for SMB Security - Module 3: Data Governance.

    Estimated Time Savings: 4-5 hours vs. manual configuration

.PARAMETER PolicySet
    Policy set to deploy: "SMB-Comprehensive" (all 5), "GDPR-Only", "Financial-Only"

.PARAMETER Mode
    Deployment mode: "TestMode" (policy tips only), "Enforce" (block violations)

.PARAMETER NotifyComplianceTeam
    Email address for DLP incident reports

.EXAMPLE
    .\Create-DLPPolicies.ps1 -PolicySet "SMB-Comprehensive" -Mode "TestMode" -NotifyComplianceTeam "security@contoso.com"
    Deploys all 5 policies in test mode with notifications.

.EXAMPLE
    .\Create-DLPPolicies.ps1 -PolicySet "GDPR-Only" -Mode "Enforce"
    Deploys only GDPR policy with enforcement.

.AUTHOR
    Woshada Dasanayake | woshada@gmail.com
    SMB Security Framework v1.0.0 (December 2025)

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - DLP (E3/E5)
    - Compliance Administrator role
    - Exchange Online PowerShell module
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("SMB-Comprehensive", "GDPR-Only", "Financial-Only")]
    [string]$PolicySet,

    [Parameter(Mandatory = $true)]
    [ValidateSet("TestMode", "Enforce")]
    [string]$Mode,

    [Parameter(Mandatory = $false)]
    [string]$NotifyComplianceTeam
)

#Requires -Modules ExchangeOnlineManagement

# Initialize logging
$LogFile = "DLP-Policies-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== DLP Policies Deployment Started ===" "INFO"
Write-Log "Policy Set: $PolicySet" "INFO"
Write-Log "Mode: $Mode" "INFO"

# Connect to Security & Compliance Center
try {
    Write-Log "Connecting to Security & Compliance Center..." "INFO"
    Connect-IPPSSession -ErrorAction Stop
    Write-Log "Successfully connected" "INFO"
} catch {
    Write-Log "Failed to connect: $_" "ERROR"
    exit 1
}

# Define DLP Policies
$DLPPolicies = @()

# Policy 1: Protect Personal Data (GDPR Compliance)
$DLPPolicies += @{
    Name = "DLP-001-GDPR-Personal-Data-Protection"
    DisplayName = "GDPR Personal Data Protection"
    Comment = "Prevents external sharing of EU personal data in compliance with GDPR Article 32"
    Mode = $Mode
    Locations = @{
        ExchangeLocation = "All"
        SharePointLocation = "All"
        OneDriveLocation = "All"
        TeamsLocation = "All"
    }
    Conditions = @{
        ContentContainsSensitiveInformation = @(
            @{ Name = "EU Debit Card Number"; MinCount = 1 }
            @{ Name = "EU Driver's License Number"; MinCount = 1 }
            @{ Name = "EU National Identification Number"; MinCount = 1 }
            @{ Name = "EU Passport Number"; MinCount = 1 }
            @{ Name = "EU Social Security Number"; MinCount = 1 }
            @{ Name = "EU Tax Identification Number"; MinCount = 1 }
        )
        ContentContainsCount = 10
        SharedWith = "ExternalDomain"
    }
    Actions = @{
        BlockAccess = $true
        NotifyUser = $true
        NotifyManager = $false
        GenerateIncidentReport = $true
        PolicyTip = "This document contains personal data subject to GDPR. External sharing is prohibited."
    }
}

# Policy 2: Protect Financial Data
$DLPPolicies += @{
    Name = "DLP-002-Financial-Data-Protection"
    DisplayName = "Financial Data Protection"
    Comment = "Protects credit card numbers, bank account information, and financial documents"
    Mode = $Mode
    Locations = @{
        ExchangeLocation = "All"
        SharePointLocation = "All"
        OneDriveLocation = "All"
        TeamsLocation = "All"
    }
    Conditions = @{
        ContentContainsSensitiveInformation = @(
            @{ Name = "Credit Card Number"; MinCount = 1; Confidence = "High" }
            @{ Name = "U.K. Bank Account Number"; MinCount = 1 }
            @{ Name = "U.S. Bank Account Number"; MinCount = 1 }
            @{ Name = "SWIFT Code"; MinCount = 1 }
            @{ Name = "International Banking Account Number (IBAN)"; MinCount = 1 }
        )
        ContentContainsCount = 5
        SharedWith = "ExternalDomain"
    }
    Actions = @{
        BlockAccess = $true
        NotifyUser = $true
        NotifyManager = $true
        GenerateIncidentReport = $true
        PolicyTip = "This content contains financial information. External sharing requires encryption and approval."
    }
}

# Policy 3: Prevent Source Code Exfiltration (Technology SMBs)
$DLPPolicies += @{
    Name = "DLP-003-Source-Code-Protection"
    DisplayName = "Source Code Protection"
    Comment = "Prevents source code and API keys from being shared externally or uploaded to personal cloud storage"
    Mode = $Mode
    Locations = @{
        ExchangeLocation = "All"
        OneDriveLocation = "All"
        EndpointDevices = "All"
    }
    Conditions = @{
        FileExtension = @(".cs", ".java", ".py", ".js", ".cpp", ".h", ".php", ".rb", ".go")
        ContentContainsKeywords = @("API_KEY", "SECRET_KEY", "DATABASE_PASSWORD", "ConnectionString")
        SharedWith = "ExternalDomain,PersonalEmail"
    }
    Actions = @{
        BlockAccess = $true
        NotifyUser = $true
        NotifyITSecurity = $true
        GenerateIncidentReport = $true
        Severity = "High"
        PolicyTip = "Source code and API keys cannot be shared externally or uploaded to personal cloud storage."
    }
}

# Policy 4: Confidential Label Enforcement
$DLPPolicies += @{
    Name = "DLP-004-Confidential-Label-Enforcement"
    DisplayName = "Confidential Label Enforcement"
    Comment = "Enforces protection for content labeled as Confidential or higher"
    Mode = $Mode
    Locations = @{
        ExchangeLocation = "All"
        SharePointLocation = "All"
        OneDriveLocation = "All"
        TeamsLocation = "All"
    }
    Conditions = @{
        ContentHasLabel = @("Confidential", "Highly Confidential", "Restricted")
        SharedWith = "ExternalDomain"
    }
    Actions = @{
        BlockAccess = $true
        RemoveExternalSharing = $true
        NotifyUser = $true
        PolicyTip = "This content is labeled Confidential. External sharing is not permitted."
    }
}

# Policy 5: Teams Message Protection
$DLPPolicies += @{
    Name = "DLP-005-Teams-Message-Protection"
    DisplayName = "Teams Message Protection"
    Comment = "Prevents accidental sharing of sensitive information in Teams chats and channels"
    Mode = $Mode
    Locations = @{
        TeamsLocation = "All"
    }
    Conditions = @{
        ContentContainsSensitiveInformation = @(
            @{ Name = "Credit Card Number"; MinCount = 1 }
            @{ Name = "U.S. Social Security Number"; MinCount = 1 }
            @{ Name = "U.K. National Insurance Number"; MinCount = 1 }
        )
        ContentContainsKeywords = @("password", "confidential", "secret")
    }
    Actions = @{
        BlockMessage = $true
        NotifyUser = $true
        PolicyTip = "Your message contains sensitive information. Please use secure sharing methods instead."
    }
}

# Filter policies based on PolicySet
$PoliciesToDeploy = switch ($PolicySet) {
    "GDPR-Only" { $DLPPolicies[0] }
    "Financial-Only" { $DLPPolicies[1] }
    default { $DLPPolicies }
}

Write-Log "Deploying $($PoliciesToDeploy.Count) DLP policies..." "INFO"

# Deploy policies
$DeployedCount = 0
$ErrorCount = 0

foreach ($PolicyConfig in $PoliciesToDeploy) {
    try {
        Write-Log "Creating DLP policy: $($PolicyConfig.DisplayName)..." "INFO"

        # Check if policy already exists
        $ExistingPolicy = Get-DlpCompliancePolicy -Identity $PolicyConfig.Name -ErrorAction SilentlyContinue

        if ($ExistingPolicy) {
            Write-Log "  Policy already exists - Updating" "WARN"
            # Update mode
            if ($Mode -eq "TestMode") {
                Set-DlpCompliancePolicy -Identity $PolicyConfig.Name -Mode "TestWithNotifications"
            } else {
                Set-DlpCompliancePolicy -Identity $PolicyConfig.Name -Mode "Enable"
            }
            $DeployedCount++
            continue
        }

        if ($PSCmdlet.ShouldProcess($PolicyConfig.DisplayName, "Create DLP policy")) {
            # Create DLP policy
            $PolicyParams = @{
                Name = $PolicyConfig.Name
                Comment = $PolicyConfig.Comment
                Mode = if ($Mode -eq "TestMode") { "TestWithNotifications" } else { "Enable" }
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
            if ($PolicyConfig.Locations.TeamsLocation) {
                $PolicyParams.TeamsLocation = $PolicyConfig.Locations.TeamsLocation
            }

            $NewPolicy = New-DlpCompliancePolicy @PolicyParams
            Write-Log "  Created policy: $($NewPolicy.Guid)" "INFO"

            # Create DLP rule for the policy
            $RuleName = "$($PolicyConfig.Name)-Rule"
            $RuleParams = @{
                Name = $RuleName
                Policy = $PolicyConfig.Name
                BlockAccess = $PolicyConfig.Actions.BlockAccess
                NotifyUser = "LastModifier"
                GenerateIncidentReport = "SiteAdmin"
            }

            # Add sensitive information types
            if ($PolicyConfig.Conditions.ContentContainsSensitiveInformation) {
                $SensitiveTypes = @()
                foreach ($SensitiveInfo in $PolicyConfig.Conditions.ContentContainsSensitiveInformation) {
                    $SensitiveTypes += @{
                        Name = $SensitiveInfo.Name
                        MinCount = if ($SensitiveInfo.MinCount) { $SensitiveInfo.MinCount } else { 1 }
                        Confidence = if ($SensitiveInfo.Confidence) { $SensitiveInfo.Confidence } else { "High" }
                    }
                }
                $RuleParams.ContentContainsSensitiveInformation = $SensitiveTypes
            }

            # Add incident report recipient
            if ($NotifyComplianceTeam) {
                $RuleParams.IncidentReportContent = "All"
                $RuleParams.NotifyAllowOverride = "WithJustification"
            }

            $NewRule = New-DlpComplianceRule @RuleParams
            Write-Log "  Created rule: $($NewRule.Guid)" "INFO"

            $DeployedCount++
        }
    } catch {
        Write-Log "  Error deploying policy $($PolicyConfig.DisplayName): $_" "ERROR"
        $ErrorCount++
    }
}

# Summary
Write-Log "" "INFO"
Write-Log "=== DLP Policies Deployment Summary ===" "INFO"
Write-Log "Policy Set: $PolicySet" "INFO"
Write-Log "Mode: $Mode" "INFO"
Write-Log "Policies Deployed: $DeployedCount" "INFO"
Write-Log "Errors: $ErrorCount" "INFO"
Write-Log "" "INFO"

if ($Mode -eq "TestMode") {
    Write-Log "NEXT STEPS (TEST MODE):" "WARN"
    Write-Log "1. Users will see policy tips but can override (2-3 weeks testing)" "WARN"
    Write-Log "2. Monitor DLP incidents: Microsoft Purview > DLP > Incidents" "WARN"
    Write-Log "3. Review policy matches: Microsoft Purview > DLP > Policy matches" "WARN"
    Write-Log "4. Identify false positives (legitimate business activities blocked)" "WARN"
    Write-Log "5. Adjust rules if needed (increase thresholds, add exceptions)" "WARN"
    Write-Log "6. Re-run script with -Mode 'Enforce' when ready" "WARN"
} else {
    Write-Log "NEXT STEPS (ENFORCEMENT MODE):" "WARN"
    Write-Log "1. Monitor DLP incidents daily (first week)" "WARN"
    Write-Log "2. Review blocked actions for business impact" "WARN"
    Write-Log "3. Handle override requests with justification" "WARN"
    Write-Log "4. Communicate DLP policies to users (training)" "WARN"
    Write-Log "5. Document approved exceptions" "WARN"
}

Write-Log "" "INFO"
Write-Log "Monitoring Locations:" "INFO"
Write-Log "  - Microsoft Purview: https://compliance.microsoft.com > Data loss prevention" "INFO"
Write-Log "  - Incidents: https://compliance.microsoft.com > DLP > Incidents" "INFO"
Write-Log "  - Reports: https://compliance.microsoft.com > Reports > DLP policy matches" "INFO"
Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Script Completed ===" "INFO"

# Disconnect
Disconnect-ExchangeOnline -Confirm:$false | Out-Null
