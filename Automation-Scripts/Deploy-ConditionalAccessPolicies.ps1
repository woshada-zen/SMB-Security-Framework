<#
.SYNOPSIS
    Deploy recommended Conditional Access policies for SMB security.

.DESCRIPTION
    Deploys 6 recommended Conditional Access policies based on SMB security best practices.
    Part of the Strategic Integration Framework for SMB Security - Module 1: Identity Foundation.

    Estimated Time Savings: 2-3 hours vs. manual policy creation

.PARAMETER PolicySet
    Policy set to deploy: "SMB-Recommended" (all 6 policies), "Essential" (4 core policies)

.PARAMETER Mode
    Deployment mode: "ReportOnly" (test/audit mode), "Enabled" (enforcement mode)

.PARAMETER TrustedIPs
    Comma-separated list of trusted office IP ranges for location-based policy (e.g., "203.0.113.0/24,198.51.100.0/24")

.PARAMETER EmergencyAccountUPNs
    Comma-separated list of emergency access account UPNs to exclude from policies

.EXAMPLE
    .\Deploy-ConditionalAccessPolicies.ps1 -PolicySet "SMB-Recommended" -Mode "ReportOnly"
    Deploys all 6 policies in report-only mode for 7-day testing.

.EXAMPLE
    .\Deploy-ConditionalAccessPolicies.ps1 -PolicySet "SMB-Recommended" -Mode "Enabled" -TrustedIPs "203.0.113.0/24" -EmergencyAccountUPNs "admin-emergency01@contoso.com,admin-emergency02@contoso.com"
    Deploys all policies with enforcement, trusted office IPs, and emergency account exclusions.

.AUTHOR
    Woshada Dasanayake | woshada@gmail.com
    SMB Security Framework v1.0.0 (January 2025)
    Based on MSc Cybersecurity Dissertation, 2025

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - Microsoft.Graph PowerShell module
    - Policy.ReadWrite.ConditionalAccess permission
    - Conditional Access Administrator or Global Administrator role
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("SMB-Recommended", "Essential")]
    [string]$PolicySet,

    [Parameter(Mandatory = $true)]
    [ValidateSet("ReportOnly", "Enabled")]
    [string]$Mode,

    [Parameter(Mandatory = $false)]
    [string]$TrustedIPs,

    [Parameter(Mandatory = $false)]
    [string]$EmergencyAccountUPNs
)

#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Identity.SignIns

# Initialize logging
$LogFile = "CA-Policy-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Conditional Access Policy Deployment Started ===" "INFO"
Write-Log "Policy Set: $PolicySet" "INFO"
Write-Log "Mode: $Mode" "INFO"

# Connect to Microsoft Graph
try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess", "Policy.Read.All", "Directory.Read.All" -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    exit 1
}

# Get emergency access accounts for exclusion
$EmergencyUserIds = @()
if ($EmergencyAccountUPNs) {
    Write-Log "Processing emergency access accounts..." "INFO"
    foreach ($UPN in $EmergencyAccountUPNs.Split(',')) {
        try {
            $User = Get-MgUser -Filter "userPrincipalName eq '$($UPN.Trim())'" -ErrorAction Stop
            if ($User) {
                $EmergencyUserIds += $User.Id
                Write-Log "  Added emergency account: $UPN" "INFO"
            }
        } catch {
            Write-Log "  Warning: Could not find emergency account: $UPN" "WARN"
        }
    }
}

# Get all users group ID
$AllUsersGroupId = "All"  # Special identifier for all users

# Create named location for trusted IPs (if provided)
$TrustedLocationId = $null
if ($TrustedIPs) {
    Write-Log "Creating trusted IP named location..." "INFO"
    try {
        $TrustedIPRanges = $TrustedIPs.Split(',') | ForEach-Object {
            @{
                "@odata.type" = "#microsoft.graph.iPv4CidrRange"
                cidrAddress = $_.Trim()
            }
        }

        $NamedLocationParams = @{
            "@odata.type" = "#microsoft.graph.ipNamedLocation"
            displayName = "Trusted Office IPs"
            isTrusted = $true
            ipRanges = $TrustedIPRanges
        }

        # Check if location already exists
        $ExistingLocation = Get-MgIdentityConditionalAccessNamedLocation -Filter "displayName eq 'Trusted Office IPs'" -ErrorAction SilentlyContinue
        if ($ExistingLocation) {
            Write-Log "  Trusted IP location already exists, using existing" "INFO"
            $TrustedLocationId = $ExistingLocation.Id
        } else {
            $NamedLocation = New-MgIdentityConditionalAccessNamedLocation -BodyParameter $NamedLocationParams
            $TrustedLocationId = $NamedLocation.Id
            Write-Log "  Created named location: $TrustedLocationId" "INFO"
        }
    } catch {
        Write-Log "  Error creating named location: $_" "ERROR"
    }
}

# Define policy configurations
$Policies = @()

# Policy 1: Require MFA for All Users
$Policies += @{
    DisplayName = "SMB-001: Require MFA for All Users"
    Description = "Baseline protection requiring MFA for all users accessing all cloud apps"
    Conditions = @{
        Users = @{
            IncludeUsers = @("All")
            ExcludeUsers = $EmergencyUserIds
        }
        Applications = @{
            IncludeApplications = @("All")
        }
    }
    GrantControls = @{
        Operator = "OR"
        BuiltInControls = @("mfa")
    }
}

# Policy 2: Block Legacy Authentication
$Policies += @{
    DisplayName = "SMB-002: Block Legacy Authentication"
    Description = "Blocks legacy authentication protocols that don't support MFA"
    Conditions = @{
        Users = @{
            IncludeUsers = @("All")
            ExcludeUsers = $EmergencyUserIds
        }
        Applications = @{
            IncludeApplications = @("All")
        }
        ClientAppTypes = @("exchangeActiveSync", "other")
    }
    GrantControls = @{
        Operator = "OR"
        BuiltInControls = @("block")
    }
}

# Policy 3: Require Compliant or Hybrid Joined Devices
$Policies += @{
    DisplayName = "SMB-003: Require Compliant or Hybrid Joined Devices"
    Description = "Requires devices to be compliant or hybrid Azure AD joined for Office 365 access"
    Conditions = @{
        Users = @{
            IncludeUsers = @("All")
            ExcludeUsers = $EmergencyUserIds
        }
        Applications = @{
            IncludeApplications = @("Office365")
        }
        Platforms = @{
            IncludePlatforms = @("windows", "macOS", "iOS", "android")
        }
    }
    GrantControls = @{
        Operator = "OR"
        BuiltInControls = @("compliantDevice", "domainJoinedDevice")
    }
}

# Policy 4: Require MFA for Administrators (Always)
$Policies += @{
    DisplayName = "SMB-004: Require MFA for Administrators"
    Description = "Enhanced MFA requirement for privileged roles - every sign-in"
    Conditions = @{
        Users = @{
            IncludeRoles = @(
                "62e90394-69f5-4237-9190-012177145e10",  # Global Administrator
                "194ae4cb-b126-40b2-bd5b-6091b380977d",  # Security Administrator
                "f28a1f50-f6e7-4571-818b-6a12f2af6b6c",  # SharePoint Administrator
                "29232cdf-9323-42fd-ade2-1d097af3e4de",  # Exchange Administrator
                "729827e3-9c14-49f7-bb1b-9608f156bbb8"   # Helpdesk Administrator
            )
            ExcludeUsers = $EmergencyUserIds
        }
        Applications = @{
            IncludeApplications = @("All")
        }
    }
    GrantControls = @{
        Operator = "OR"
        BuiltInControls = @("mfa")
    }
    SessionControls = @{
        SignInFrequency = @{
            Value = 0
            Type = "hours"
            IsEnabled = $true
        }
    }
}

# Filter policies based on PolicySet
if ($PolicySet -eq "Essential") {
    $Policies = $Policies[0..3]  # Only first 4 policies
    Write-Log "Deploying Essential policy set (4 policies)" "INFO"
} else {
    Write-Log "Deploying SMB-Recommended policy set (6 policies)" "INFO"

    # Policy 5: Block Access from Unknown Locations (requires TrustedIPs parameter)
    if ($TrustedLocationId) {
        $Policies += @{
            DisplayName = "SMB-005: Require MFA from Unknown Locations"
            Description = "Requires additional MFA verification when accessing from non-trusted locations"
            Conditions = @{
                Users = @{
                    IncludeUsers = @("All")
                    ExcludeUsers = $EmergencyUserIds
                }
                Applications = @{
                    IncludeApplications = @("All")
                }
                Locations = @{
                    IncludeLocations = @("All")
                    ExcludeLocations = @($TrustedLocationId)
                }
            }
            GrantControls = @{
                Operator = "AND"
                BuiltInControls = @("mfa", "compliantDevice")
            }
        }
    } else {
        Write-Log "  Skipping Policy 5 (location-based) - no trusted IPs provided" "WARN"
    }

    # Policy 6: Block High-Risk Sign-Ins (E5 only - requires Azure AD Identity Protection)
    $Policies += @{
        DisplayName = "SMB-006: Block High-Risk Sign-Ins"
        Description = "Blocks or requires password change for high-risk sign-ins detected by Azure AD Identity Protection (E5 only)"
        Conditions = @{
            Users = @{
                IncludeUsers = @("All")
                ExcludeUsers = $EmergencyUserIds
            }
            Applications = @{
                IncludeApplications = @("All")
            }
            SignInRiskLevels = @("high")
        }
        GrantControls = @{
            Operator = "OR"
            BuiltInControls = @("mfa", "passwordChange")
        }
    }
}

# Set state based on mode
$State = if ($Mode -eq "ReportOnly") { "enabledForReportingButNotEnforced" } else { "enabled" }

# Deploy policies
$DeployedCount = 0
$ErrorCount = 0

foreach ($PolicyConfig in $Policies) {
    try {
        Write-Log "Deploying policy: $($PolicyConfig.DisplayName)..." "INFO"

        # Check if policy already exists
        $ExistingPolicy = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq '$($PolicyConfig.DisplayName)'" -ErrorAction SilentlyContinue

        if ($ExistingPolicy) {
            Write-Log "  Policy already exists - Updating" "WARN"
            if ($PSCmdlet.ShouldProcess($PolicyConfig.DisplayName, "Update existing policy")) {
                $PolicyParams = @{
                    DisplayName = $PolicyConfig.DisplayName
                    State = $State
                    Conditions = $PolicyConfig.Conditions
                    GrantControls = $PolicyConfig.GrantControls
                }
                if ($PolicyConfig.SessionControls) {
                    $PolicyParams.SessionControls = $PolicyConfig.SessionControls
                }

                Update-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $ExistingPolicy.Id -BodyParameter $PolicyParams
                Write-Log "  Successfully updated policy" "INFO"
                $DeployedCount++
            }
        } else {
            if ($PSCmdlet.ShouldProcess($PolicyConfig.DisplayName, "Create new policy")) {
                $PolicyParams = @{
                    DisplayName = $PolicyConfig.DisplayName
                    State = $State
                    Conditions = $PolicyConfig.Conditions
                    GrantControls = $PolicyConfig.GrantControls
                }
                if ($PolicyConfig.SessionControls) {
                    $PolicyParams.SessionControls = $PolicyConfig.SessionControls
                }

                $NewPolicy = New-MgIdentityConditionalAccessPolicy -BodyParameter $PolicyParams
                Write-Log "  Successfully created policy: $($NewPolicy.Id)" "INFO"
                $DeployedCount++
            }
        }
    } catch {
        Write-Log "  Error deploying policy $($PolicyConfig.DisplayName): $_" "ERROR"
        $ErrorCount++
    }
}

# Summary
Write-Log "" "INFO"
Write-Log "=== Conditional Access Deployment Summary ===" "INFO"
Write-Log "Policy Set: $PolicySet" "INFO"
Write-Log "Deployment Mode: $Mode" "INFO"
Write-Log "Policies Deployed: $DeployedCount" "INFO"
Write-Log "Errors: $ErrorCount" "INFO"
Write-Log "" "INFO"

if ($Mode -eq "ReportOnly") {
    Write-Log "NEXT STEPS (REPORT-ONLY MODE):" "WARN"
    Write-Log "1. Monitor for 7 days: Azure AD > Sign-in logs > Conditional Access tab" "WARN"
    Write-Log "2. Review 'would have been blocked' scenarios" "WARN"
    Write-Log "3. Adjust exclusions if needed (legacy apps, specific users)" "WARN"
    Write-Log "4. Re-run script with -Mode 'Enabled' to enforce policies" "WARN"
} else {
    Write-Log "NEXT STEPS (ENFORCEMENT MODE):" "WARN"
    Write-Log "1. Monitor help desk tickets for blocked users (first 48 hours)" "WARN"
    Write-Log "2. Review sign-in logs daily for legitimate blocks" "WARN"
    Write-Log "3. Communicate policy enforcement to users" "WARN"
    Write-Log "4. Document any exclusions added" "WARN"
}

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Script Completed ===" "INFO"

# Disconnect from Microsoft Graph
Disconnect-MgGraph | Out-Null
