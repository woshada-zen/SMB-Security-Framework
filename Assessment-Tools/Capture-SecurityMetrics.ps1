<#
.SYNOPSIS
    Captures comprehensive security metrics for before/after framework comparison

.DESCRIPTION
    This script collects baseline security metrics across Microsoft 365 and Azure
    to demonstrate framework impact. Run BEFORE and AFTER framework implementation.

.PARAMETER OutputPath
    Path to save the metrics report (default: current directory)

.PARAMETER ReportName
    Name for the report file (default: SecurityMetrics_YYYYMMDD_HHMMSS.txt)

.EXAMPLE
    # Capture BASELINE metrics
    .\Capture-SecurityMetrics.ps1 -ReportName "BASELINE_Metrics.txt"

.EXAMPLE
    # Capture POST-IMPLEMENTATION metrics
    .\Capture-SecurityMetrics.ps1 -ReportName "POST_Metrics.txt"

.NOTES
    Author: Your Name
    Purpose: Dissertation viva demonstration
    Requirements: Microsoft.Graph, AzureAD, ExchangeOnlineManagement modules
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".",

    [Parameter(Mandatory=$false)]
    [string]$ReportName = "SecurityMetrics_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
)

# Color-coded output functions
function Write-Section {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-Metric {
    param([string]$Label, [string]$Value, [string]$Color = "White")
    Write-Host "  $($Label.PadRight(40)): " -NoNewline
    Write-Host $Value -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

# Initialize report
$reportPath = Join-Path $OutputPath $ReportName
$report = @()
$report += "╔══════════════════════════════════════════════════════════════════╗"
$report += "║  SECURITY POSTURE ASSESSMENT - METRICS CAPTURE                   ║"
$report += "╚══════════════════════════════════════════════════════════════════╝"
$report += ""
$report += "Assessment Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$report += "Assessor: $env:USERNAME"
$report += ""

# Initialize variables at script level for summary section
$dlpCount = 0
$publishedLabels = 0
$ippsConnected = $false
$azContext = $null

Write-Host "`n"
Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     SECURITY METRICS CAPTURE TOOL                                 ║" -ForegroundColor Cyan
Write-Host "║     MSc Dissertation - Framework Evaluation                       ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check and connect to required services
Write-Section "STEP 1: Connecting to Microsoft Services"

try {
    Write-Host "  Checking Microsoft Graph connection..." -NoNewline
    $graphContext = Get-MgContext -ErrorAction SilentlyContinue
    if (-not $graphContext) {
        Write-Host " Not connected" -ForegroundColor Yellow
        Write-Host "  Connecting to Microsoft Graph..."
        Connect-MgGraph -Scopes "User.Read.All", "Policy.Read.All", "Directory.Read.All", "SecurityEvents.Read.All" -NoWelcome
        Write-Success "Connected to Microsoft Graph"
    } else {
        Write-Host " Connected" -ForegroundColor Green
        Write-Success "Already connected to Microsoft Graph as $($graphContext.Account)"
    }
    $report += "Microsoft Graph: Connected"
    $report += "Tenant: $($graphContext.TenantId)"
    $report += ""
} catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    $report += "Microsoft Graph: Connection Failed"
}

# Get tenant information
Write-Section "STEP 2: Gathering Tenant Information"
try {
    $orgDetails = Get-MgOrganization
    $tenantDomain = $orgDetails.VerifiedDomains | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty Name

    Write-Metric "Tenant Domain" $tenantDomain "Green"
    Write-Metric "Tenant ID" $orgDetails.Id "White"
    Write-Metric "Organization Name" $orgDetails.DisplayName "White"

    $report += "─────────────────────────────────────────────────────────────────"
    $report += " TENANT INFORMATION"
    $report += "─────────────────────────────────────────────────────────────────"
    $report += "Tenant Domain: $tenantDomain"
    $report += "Tenant ID: $($orgDetails.Id)"
    $report += "Organization: $($orgDetails.DisplayName)"
    $report += ""
} catch {
    Write-Warning "Could not retrieve tenant details: $_"
}

# ====================
# SECTION 1: USER ACCOUNTS & MFA
# ====================
Write-Section "SECTION 1: Identity Security - Users & MFA"

try {
    # Get all users
    $allUsers = Get-MgUser -All -Property UserPrincipalName,AccountEnabled,AssignedLicenses | Where-Object {$_.AccountEnabled -eq $true}
    $totalUsers = $allUsers.Count
    $licensedUsers = ($allUsers | Where-Object {$_.AssignedLicenses.Count -gt 0}).Count

    Write-Metric "Total Active Users" $totalUsers "Green"
    Write-Metric "Licensed Users" $licensedUsers "White"

    # MFA Status - This requires Azure AD PowerShell or specific Graph API calls
    # Note: Graph API doesn't directly expose per-user MFA status easily
    # We'll check authentication methods as a proxy

    Write-Host "`n  Checking MFA registration status (this may take a moment)..."
    $mfaRegistered = 0
    $mfaNotRegistered = 0

    foreach ($user in $allUsers | Select-Object -First 20) {
        # Only check first 20 users for demo purposes to save time
        try {
            $authMethods = Get-MgUserAuthenticationMethod -UserId $user.Id -ErrorAction SilentlyContinue
            if ($authMethods.Count -gt 1) {
                $mfaRegistered++
            } else {
                $mfaNotRegistered++
            }
        } catch {
            $mfaNotRegistered++
        }
    }

    $mfaPercentage = if ($totalUsers -gt 0) { [math]::Round(($mfaRegistered / ($mfaRegistered + $mfaNotRegistered)) * 100, 2) } else { 0 }

    Write-Metric "MFA Registered Users (sample)" "$mfaRegistered of $($mfaRegistered + $mfaNotRegistered)" "White"
    Write-Metric "MFA Coverage (estimated)" "$mfaPercentage%" $(if ($mfaPercentage -ge 90) {"Green"} elseif ($mfaPercentage -ge 50) {"Yellow"} else {"Red"})

    $report += "─────────────────────────────────────────────────────────────────"
    $report += " IDENTITY SECURITY"
    $report += "─────────────────────────────────────────────────────────────────"
    $report += "Total Active Users: $totalUsers"
    $report += "Licensed Users: $licensedUsers"
    $report += "MFA Registered (sample): $mfaRegistered"
    $report += "MFA Not Registered (sample): $mfaNotRegistered"
    $report += "MFA Coverage: $mfaPercentage%"
    $report += ""

} catch {
    Write-Error "Failed to retrieve user/MFA data: $_"
}

# ====================
# SECTION 2: CONDITIONAL ACCESS POLICIES
# ====================
Write-Section "SECTION 2: Conditional Access Policies"

try {
    $caPolicies = Get-MgIdentityConditionalAccessPolicy -All
    $totalCAPolicies = $caPolicies.Count
    $enabledCAPolicies = ($caPolicies | Where-Object {$_.State -eq "enabled"}).Count
    $reportOnlyCAPolicies = ($caPolicies | Where-Object {$_.State -eq "enabledForReportingButNotEnforced"}).Count
    $disabledCAPolicies = ($caPolicies | Where-Object {$_.State -eq "disabled"}).Count

    Write-Metric "Total CA Policies" $totalCAPolicies $(if ($totalCAPolicies -eq 0) {"Red"} elseif ($totalCAPolicies -ge 5) {"Green"} else {"Yellow"})
    Write-Metric "Enabled Policies" $enabledCAPolicies $(if ($enabledCAPolicies -ge 5) {"Green"} elseif ($enabledCAPolicies -gt 0) {"Yellow"} else {"Red"})
    Write-Metric "Report-Only Policies" $reportOnlyCAPolicies "White"
    Write-Metric "Disabled Policies" $disabledCAPolicies "White"

    if ($caPolicies.Count -gt 0) {
        Write-Host "`n  Policy Details:" -ForegroundColor Cyan
        foreach ($policy in $caPolicies) {
            $statusColor = switch ($policy.State) {
                "enabled" { "Green" }
                "enabledForReportingButNotEnforced" { "Yellow" }
                "disabled" { "Red" }
                default { "White" }
            }
            Write-Host "    • " -NoNewline
            Write-Host "$($policy.DisplayName) " -NoNewline
            Write-Host "[$($policy.State)]" -ForegroundColor $statusColor
        }
    }

    $report += "─────────────────────────────────────────────────────────────────"
    $report += " CONDITIONAL ACCESS POLICIES"
    $report += "─────────────────────────────────────────────────────────────────"
    $report += "Total Policies: $totalCAPolicies"
    $report += "Enabled: $enabledCAPolicies"
    $report += "Report-Only: $reportOnlyCAPolicies"
    $report += "Disabled: $disabledCAPolicies"
    $report += ""
    if ($caPolicies.Count -gt 0) {
        $report += "Policy List:"
        foreach ($policy in $caPolicies) {
            $report += "  • $($policy.DisplayName) [$($policy.State)]"
        }
    }
    $report += ""

} catch {
    Write-Error "Failed to retrieve Conditional Access policies: $_"
    $report += "Conditional Access: Data unavailable"
}

# ====================
# SECTION 3: SECURE SCORE (requires Security Graph)
# ====================
Write-Section "SECTION 3: Microsoft Secure Score"

try {
    Write-Host "  Retrieving Secure Score (this may take a moment)..."

    # Note: Secure Score requires specific Graph permissions
    # Connect-MgGraph -Scopes "SecurityEvents.Read.All"

    $secureScore = Get-MgSecuritySecureScore -Top 1 -Sort "createdDateTime desc" -ErrorAction SilentlyContinue

    if ($secureScore) {
        $currentScore = $secureScore.CurrentScore
        $maxScore = $secureScore.MaxScore
        $percentage = [math]::Round(($currentScore / $maxScore) * 100, 2)

        $scoreColor = if ($percentage -ge 70) {"Green"} elseif ($percentage -ge 40) {"Yellow"} else {"Red"}

        Write-Metric "Current Score" "$currentScore / $maxScore points" $scoreColor
        Write-Metric "Percentage" "$percentage%" $scoreColor
        Write-Metric "Score Date" $secureScore.CreatedDateTime "White"

        $report += "─────────────────────────────────────────────────────────────────"
        $report += " MICROSOFT SECURE SCORE"
        $report += "─────────────────────────────────────────────────────────────────"
        $report += "Current Score: $currentScore points"
        $report += "Maximum Score: $maxScore points"
        $report += "Percentage: $percentage%"
        $report += "Last Updated: $($secureScore.CreatedDateTime)"
        $report += ""

        # Get control scores by category
        if ($secureScore.ControlScores) {
            Write-Host "`n  Score by Category:" -ForegroundColor Cyan
            $categories = $secureScore.ControlScores | Group-Object -Property ControlCategory

            $report += "Score by Category:"
            foreach ($cat in $categories) {
                $catScore = ($cat.Group | Measure-Object -Property Score -Sum).Sum
                $catMax = ($cat.Group | Measure-Object -Property MaxScore -Sum).Sum
                $catPercent = if ($catMax -gt 0) { [math]::Round(($catScore / $catMax) * 100, 2) } else { 0 }

                Write-Host "    • " -NoNewline
                Write-Host "$($cat.Name): " -NoNewline
                Write-Host "$catPercent% " -ForegroundColor $(if ($catPercent -ge 70) {"Green"} elseif ($catPercent -ge 40) {"Yellow"} else {"Red"}) -NoNewline
                Write-Host "($catScore / $catMax points)"

                $report += "  • $($cat.Name): $catPercent% ($catScore / $catMax points)"
            }
        }
        $report += ""

    } else {
        Write-Warning "Secure Score data not available (may require additional permissions or tenant configuration)"
        $report += "Microsoft Secure Score: Data unavailable"
        $report += "Note: Ensure SecurityEvents.Read.All permission is granted"
        $report += ""
    }

} catch {
    Write-Warning "Could not retrieve Secure Score: $_"
    $report += "Microsoft Secure Score: Data unavailable - $($_.Exception.Message)"
    $report += ""
}

# ====================
# SECTION 4: DATA PROTECTION (DLP, Sensitivity Labels)
# ====================
Write-Section "SECTION 4: Data Protection (DLP & Labels)"

Write-Host "  Note: DLP and Sensitivity Label data requires Security & Compliance Center connection"
Write-Host "  Connect using: Connect-IPPSSession" -ForegroundColor Yellow

try {
    # Check if Security & Compliance Center is connected
    $script:ippsConnected = $false
    try {
        # Try to run a simple compliance cmdlet to check connection
        $testConnection = Get-ComplianceSearch -ResultSize 1 -ErrorAction Stop 2>$null
        $script:ippsConnected = $true
        Write-Host "  ✓ Security & Compliance Center connected" -ForegroundColor Green
    } catch {
        # If that fails, check if the cmdlet exists at all
        if (Get-Command Get-DlpCompliancePolicy -ErrorAction SilentlyContinue) {
            # Cmdlet exists, try to use it
            try {
                $testDlp = Get-DlpCompliancePolicy -ErrorAction Stop 2>$null
                $script:ippsConnected = $true
                Write-Host "  ✓ Security & Compliance Center connected" -ForegroundColor Green
            } catch {
                $script:ippsConnected = $false
            }
        } else {
            $script:ippsConnected = $false
        }
    }

    if ($script:ippsConnected) {
        # Get DLP Policies
        try {
            $dlpPolicies = Get-DlpCompliancePolicy -ErrorAction Stop
            $script:dlpCount = if ($dlpPolicies) { $dlpPolicies.Count } else { 0 }

            Write-Metric "DLP Policies" $script:dlpCount $(if ($script:dlpCount -ge 5) {"Green"} elseif ($script:dlpCount -gt 0) {"Yellow"} else {"Red"})

            $report += "─────────────────────────────────────────────────────────────────"
            $report += " DATA PROTECTION"
            $report += "─────────────────────────────────────────────────────────────────"
            $report += "DLP Policies: $script:dlpCount"

            if ($dlpPolicies -and $dlpCount -gt 0) {
                Write-Host "`n  DLP Policies:" -ForegroundColor Cyan
                $report += ""
                $report += "DLP Policy List:"
                foreach ($policy in $dlpPolicies) {
                    $policyStatus = if ($policy.Enabled) {"Enabled"} else {"Disabled"}
                    $statusColor = if ($policy.Enabled) {"Green"} else {"Red"}

                    Write-Host "    • " -NoNewline
                    Write-Host "$($policy.Name) " -NoNewline
                    Write-Host "[$policyStatus]" -ForegroundColor $statusColor

                    $report += "  • $($policy.Name) [$policyStatus]"
                }
            } else {
                Write-Host "  No DLP policies found" -ForegroundColor Yellow
            }
            $report += ""
        } catch {
            Write-Warning "Could not retrieve DLP policies: $($_.Exception.Message)"
            $script:dlpCount = 0
            $report += "─────────────────────────────────────────────────────────────────"
            $report += " DATA PROTECTION"
            $report += "─────────────────────────────────────────────────────────────────"
            $report += "DLP Policies: Error retrieving data"
            $report += ""
        }

        # Get Sensitivity Labels
        try {
            $labels = Get-Label -ErrorAction Stop
            $labelCount = if ($labels) { $labels.Count } else { 0 }
            $script:publishedLabels = if ($labels) { ($labels | Where-Object {$_.Published -eq $true}).Count } else { 0 }

            Write-Metric "Sensitivity Labels (Total)" $labelCount "White"
            Write-Metric "Published Labels" $script:publishedLabels $(if ($script:publishedLabels -ge 3) {"Green"} elseif ($script:publishedLabels -gt 0) {"Yellow"} else {"Red"})

            $report += "Sensitivity Labels:"
            $report += "  Total Labels: $labelCount"
            $report += "  Published Labels: $script:publishedLabels"

            if ($labels -and $labelCount -gt 0) {
                Write-Host "`n  Sensitivity Labels:" -ForegroundColor Cyan
                $report += ""
                $report += "Label List:"
                foreach ($label in $labels) {
                    $labelStatus = if ($label.Published) {"Published"} else {"Not Published"}
                    $statusColor = if ($label.Published) {"Green"} else {"Yellow"}

                    Write-Host "    • " -NoNewline
                    Write-Host "$($label.DisplayName) " -NoNewline
                    Write-Host "[$labelStatus]" -ForegroundColor $statusColor

                    $report += "  • $($label.DisplayName) [$labelStatus]"
                }
            } else {
                Write-Host "  No sensitivity labels found" -ForegroundColor Yellow
            }
            $report += ""
        } catch {
            Write-Warning "Could not retrieve sensitivity labels: $($_.Exception.Message)"
            $report += "Sensitivity Labels: Error retrieving data"
            $report += ""
        }

    } else {
        Write-Warning "Security & Compliance Center not connected - DLP and Label data unavailable"
        Write-Host ""
        Write-Host "  To connect and capture this data:" -ForegroundColor Cyan
        Write-Host "  1. Close this PowerShell window" -ForegroundColor Yellow
        Write-Host "  2. Open a NEW PowerShell window as Administrator" -ForegroundColor Yellow
        Write-Host "  3. Run: Connect-IPPSSession" -ForegroundColor Yellow
        Write-Host "  4. Sign in with your admin account" -ForegroundColor Yellow
        Write-Host "  5. Run this script again" -ForegroundColor Yellow
        Write-Host ""

        $report += "─────────────────────────────────────────────────────────────────"
        $report += " DATA PROTECTION"
        $report += "─────────────────────────────────────────────────────────────────"
        $report += "Security & Compliance Center: Not Connected"
        $report += "DLP Policies: Data unavailable"
        $report += "Sensitivity Labels: Data unavailable"
        $report += ""
        $report += "To capture this data:"
        $report += "1. Close PowerShell and reopen as Administrator"
        $report += "2. Run: Connect-IPPSSession"
        $report += "3. Sign in with your Microsoft 365 admin account"
        $report += "4. Re-run this script"
        $report += ""
    }

} catch {
    Write-Warning "Failed to retrieve data protection info: $($_.Exception.Message)"
    $report += "─────────────────────────────────────────────────────────────────"
    $report += " DATA PROTECTION"
    $report += "─────────────────────────────────────────────────────────────────"
    $report += "Error: $($_.Exception.Message)"
    $report += ""
}

# ====================
# SECTION 5: DEFENDER SERVICES
# ====================
Write-Section "SECTION 5: Microsoft Defender Services"

Write-Host "  Checking Defender for Endpoint, Office 365, Identity, Cloud Apps..."

try {
    # Note: Checking Defender services requires specific API access
    # This is a simplified check based on available data

    $defenderStatus = @{
        "Defender for Endpoint" = "Unknown - Check at security.microsoft.com"
        "Defender for Office 365" = "Unknown - Check at security.microsoft.com"
        "Defender for Identity" = "Unknown - Check at security.microsoft.com"
        "Defender for Cloud Apps" = "Unknown - Check at security.microsoft.com"
    }

    Write-Warning "Defender service status requires manual verification"
    Write-Host "  Please verify at: https://security.microsoft.com" -ForegroundColor Yellow

    $report += "─────────────────────────────────────────────────────────────────"
    $report += " MICROSOFT DEFENDER SERVICES"
    $report += "─────────────────────────────────────────────────────────────────"
    $report += "Note: Manual verification required at security.microsoft.com"
    $report += ""
    $report += "Check these services:"
    $report += "  ☐ Defender for Endpoint: _______________"
    $report += "  ☐ Defender for Office 365: _______________"
    $report += "  ☐ Defender for Identity: _______________"
    $report += "  ☐ Defender for Cloud Apps: _______________"
    $report += ""

} catch {
    Write-Warning "Defender service check unavailable"
}

# ====================
# SECTION 6: AZURE SENTINEL
# ====================
Write-Section "SECTION 6: Azure Sentinel (SIEM)"

try {
    # Check if Azure PowerShell is connected
    $script:azContext = Get-AzContext -ErrorAction SilentlyContinue

    if ($script:azContext) {
        Write-Success "Connected to Azure as $($script:azContext.Account)"

        # Search for Sentinel workspaces
        $sentinelWorkspaces = Get-AzOperationalInsightsWorkspace | Where-Object {
            $_.ProvisioningState -eq "Succeeded"
        }

        $sentinelCount = if ($sentinelWorkspaces) { $sentinelWorkspaces.Count } else { 0 }

        Write-Metric "Sentinel Workspaces" $sentinelCount $(if ($sentinelCount -gt 0) {"Green"} else {"Red"})

        $report += "─────────────────────────────────────────────────────────────────"
        $report += " AZURE SENTINEL (SIEM)"
        $report += "─────────────────────────────────────────────────────────────────"
        $report += "Sentinel Workspaces: $sentinelCount"

        if ($sentinelWorkspaces) {
            Write-Host "`n  Sentinel Workspaces:" -ForegroundColor Cyan
            $report += ""
            $report += "Workspace Details:"
            foreach ($workspace in $sentinelWorkspaces) {
                Write-Host "    • " -NoNewline
                Write-Host "$($workspace.Name) " -NoNewline
                Write-Host "[$($workspace.Location)]" -ForegroundColor Green

                $report += "  • $($workspace.Name) - Location: $($workspace.Location)"
                $report += "    Resource Group: $($workspace.ResourceGroupName)"
            }
        } else {
            Write-Warning "No Sentinel workspaces found"
            $report += "Status: Not Deployed"
        }
        $report += ""

    } else {
        Write-Warning "Azure PowerShell not connected - Sentinel data unavailable"
        Write-Host "  To connect, run: Connect-AzAccount" -ForegroundColor Yellow

        $report += "─────────────────────────────────────────────────────────────────"
        $report += " AZURE SENTINEL (SIEM)"
        $report += "─────────────────────────────────────────────────────────────────"
        $report += "Azure Connection: Not Connected"
        $report += "Sentinel Status: Data unavailable"
        $report += ""
        $report += "To capture this data:"
        $report += "1. Run: Connect-AzAccount"
        $report += "2. Re-run this script"
        $report += ""
    }

} catch {
    Write-Warning "Failed to check Sentinel status: $_"
}

# ====================
# SECTION 7: SUMMARY SCORECARD
# ====================
Write-Section "SECTION 7: Summary Scorecard"

$scorecard = @"

┌─────────────────────────────────────────────────────────────────┐
│  SECURITY POSTURE SCORECARD                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Metric                           Status         Score          │
│  ─────────────────────────────────────────────────────────      │
│  Secure Score                     $(if ($percentage) {"$percentage%".PadRight(15)} else {"Not Available".PadRight(15)})          │
│  MFA Coverage                     $(if ($mfaPercentage) {"$mfaPercentage%".PadRight(15)} else {"Unknown".PadRight(15)})          │
│  Conditional Access Policies      $($enabledCAPolicies.ToString().PadRight(15)) policies  │
│  DLP Policies                     $(if ($ippsConnected) {$dlpCount.ToString().PadRight(15)} else {"N/A".PadRight(15)}) policies  │
│  Sensitivity Labels (Published)   $(if ($ippsConnected) {$publishedLabels.ToString().PadRight(15)} else {"N/A".PadRight(15)}) labels   │
│  Sentinel Workspaces              $(if ($azContext) {$sentinelCount.ToString().PadRight(15)} else {"N/A".PadRight(15)}) workspace │
│                                                                  │
│  Overall Security Maturity:                                     │
│  $(if ($percentage -ge 70 -and $enabledCAPolicies -ge 5) {"  ✓ HIGH - Strong security posture".PadRight(66)} elseif ($percentage -ge 40 -or $enabledCAPolicies -ge 3) {"  ≈ MEDIUM - Foundational controls present".PadRight(66)} else {"  ✗ LOW - Significant gaps identified".PadRight(66)})│
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

"@

Write-Host $scorecard

$report += "─────────────────────────────────────────────────────────────────"
$report += " SUMMARY SCORECARD"
$report += "─────────────────────────────────────────────────────────────────"
$report += ""
$report += "METRIC                              STATUS"
$report += "─────────────────────────────────────────────────────────────────"
if ($percentage) {
    $report += "Secure Score:                       $percentage% ($currentScore / $maxScore points)"
} else {
    $report += "Secure Score:                       Not Available"
}
$report += "MFA Coverage:                       $mfaPercentage%"
$report += "Conditional Access Policies:        $enabledCAPolicies enabled"
if ($ippsConnected -and $dlpCount -ge 0) {
    $report += "DLP Policies:                       $dlpCount policies"
    $report += "Sensitivity Labels (Published):     $publishedLabels labels"
} else {
    $report += "DLP Policies:                       Data unavailable"
    $report += "Sensitivity Labels:                 Data unavailable"
}
if ($azContext) {
    $report += "Sentinel Workspaces:                $sentinelCount workspace(s)"
} else {
    $report += "Sentinel Workspaces:                Data unavailable"
}
$report += ""

# Overall maturity assessment
if ($percentage -ge 70 -and $enabledCAPolicies -ge 5) {
    $report += "OVERALL MATURITY: HIGH - Strong security posture"
} elseif ($percentage -ge 40 -or $enabledCAPolicies -ge 3) {
    $report += "OVERALL MATURITY: MEDIUM - Foundational controls present"
} else {
    $report += "OVERALL MATURITY: LOW - Significant gaps identified"
}
$report += ""

# ====================
# SAVE REPORT
# ====================
Write-Section "Saving Report"

try {
    $report += "─────────────────────────────────────────────────────────────────"
    $report += " END OF REPORT"
    $report += "─────────────────────────────────────────────────────────────────"
    $report += "Report generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $report += "Generated by: $env:USERNAME on $env:COMPUTERNAME"

    $report | Out-File -FilePath $reportPath -Encoding UTF8

    Write-Success "Report saved to: $reportPath"
    Write-Host ""
    Write-Host "  You can review the report at:" -ForegroundColor Cyan
    Write-Host "  $reportPath" -ForegroundColor Yellow
    Write-Host ""

    # Offer to open the report
    Write-Host "  Would you like to open the report now? (Y/N): " -NoNewline -ForegroundColor Cyan
    $openReport = Read-Host
    if ($openReport -eq 'Y' -or $openReport -eq 'y') {
        Start-Process notepad.exe -ArgumentList $reportPath
    }

} catch {
    Write-Error "Failed to save report: $_"
}

# ====================
# COMPLETION
# ====================
Write-Host "`n"
Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ SECURITY METRICS CAPTURE COMPLETE                             ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "  1. Review the generated report at: $reportPath"
Write-Host "  2. If this is your BASELINE capture:"
Write-Host "     - Document all metrics in your viva materials"
Write-Host "     - Proceed to deploy framework using automation scripts"
Write-Host "  3. If this is your POST-IMPLEMENTATION capture:"
Write-Host "     - Compare metrics with baseline report"
Write-Host "     - Calculate improvements (e.g., Secure Score increase)"
Write-Host "     - Prepare before/after comparison slides"
Write-Host ""

Write-Host "For framework deployment guidance, see: VIVA_DEMO_GUIDE.md" -ForegroundColor Yellow
Write-Host ""
