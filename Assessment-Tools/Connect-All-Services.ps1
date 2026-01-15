<#
.SYNOPSIS
    Connects to all required Microsoft services for metrics capture

.DESCRIPTION
    This script connects to:
    - Microsoft Graph (for Secure Score, MFA, Conditional Access)
    - Security & Compliance Center (for DLP and Sensitivity Labels)
    - Azure (for Sentinel)

.EXAMPLE
    .\Connect-All-Services.ps1

.NOTES
    Run this BEFORE running Capture-SecurityMetrics.ps1
#>

Write-Host "`n"
Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     CONNECT TO ALL MICROSOFT SERVICES                            ║" -ForegroundColor Cyan
Write-Host "║     Pre-requisite for Metrics Capture                           ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Function to display status
function Write-Status {
    param(
        [string]$Service,
        [string]$Status,
        [string]$Color = "White"
    )
    Write-Host "  $($Service.PadRight(40)): " -NoNewline
    Write-Host $Status -ForegroundColor $Color
}

# ====================
# 1. MICROSOFT GRAPH
# ====================
Write-Host "[1/3] Connecting to Microsoft Graph..." -ForegroundColor Cyan
Write-Host ""

try {
    $context = Get-MgContext -ErrorAction SilentlyContinue
    $needsReconnect = $false

    if ($context) {
        Write-Host "  Existing connection found" -ForegroundColor Yellow
        Write-Host "      Account: $($context.Account)" -ForegroundColor White
        Write-Host "      Tenant: $($context.TenantId)" -ForegroundColor White

        # Test if connection is valid
        Write-Host "  Testing connection validity..." -ForegroundColor Yellow
        try {
            $testUser = Get-MgUser -Top 1 -ErrorAction Stop
            Write-Status "Microsoft Graph" "Connected and Valid ✓" "Green"
        } catch {
            Write-Host "  ⚠ Connection exists but is invalid/stale" -ForegroundColor Yellow
            Write-Host "  Disconnecting and reconnecting..." -ForegroundColor Yellow
            Disconnect-MgGraph -ErrorAction SilentlyContinue
            $needsReconnect = $true
        }
    } else {
        $needsReconnect = $true
    }

    if ($needsReconnect) {
        Write-Host "  Connecting to Microsoft Graph (device code will appear)..." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Required Scopes:" -ForegroundColor Cyan
        Write-Host "    • User.Read.All" -ForegroundColor White
        Write-Host "    • Policy.Read.All" -ForegroundColor White
        Write-Host "    • Directory.Read.All" -ForegroundColor White
        Write-Host "    • SecurityEvents.Read.All" -ForegroundColor White
        Write-Host "    • Organization.Read.All" -ForegroundColor White
        Write-Host ""

        # Connect with device code (more reliable than browser)
        Connect-MgGraph -Scopes "User.Read.All", "Policy.Read.All", "Directory.Read.All", "SecurityEvents.Read.All", "Organization.Read.All" 

        # Verify connection
        $context = Get-MgContext
        if ($context) {
            # Double-check with actual API call
            try {
                $testUser = Get-MgUser -Top 1 -ErrorAction Stop
                Write-Status "Microsoft Graph" "Connected Successfully ✓" "Green"
                Write-Host "      Account: $($context.Account)" -ForegroundColor White
                Write-Host "      Tenant: $($context.TenantId)" -ForegroundColor White
            } catch {
                Write-Status "Microsoft Graph" "Connected but API test failed ✗" "Red"
                Write-Host "      Error: $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Status "Microsoft Graph" "Connection Failed ✗" "Red"
        }
    }
} catch {
    Write-Status "Microsoft Graph" "Error: $($_.Exception.Message)" "Red"
    Write-Host ""
    Write-Host "  Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Make sure Microsoft.Graph module is installed" -ForegroundColor White
    Write-Host "  2. Try: Install-Module Microsoft.Graph -Force -Scope CurrentUser" -ForegroundColor White
    Write-Host "  3. Close and reopen PowerShell as Administrator" -ForegroundColor White
}

Write-Host ""

# ====================
# 2. SECURITY & COMPLIANCE CENTER (for DLP and Labels)
# ====================
Write-Host "[2/3] Connecting to Security & Compliance Center..." -ForegroundColor Cyan
Write-Host "      (Required for DLP policies and Sensitivity Labels)" -ForegroundColor White
Write-Host ""

try {
    # Check if already connected
    $ippsConnected = $false
    try {
        $testConnection = Get-ComplianceSearch -ResultSize 1 -ErrorAction Stop 2>$null
        $ippsConnected = $true
    } catch {
        $ippsConnected = $false
    }

    if ($ippsConnected) {
        Write-Status "Security & Compliance Center" "Already Connected ✓" "Green"
    } else {
        Write-Host "  Connecting to Security & Compliance Center..." -ForegroundColor Yellow
        Write-Host "  (A sign-in window will appear)" -ForegroundColor Yellow

        Connect-IPPSSession

        # Test connection
        try {
            $testConnection = Get-ComplianceSearch -ResultSize 1 -ErrorAction Stop 2>$null
            Write-Status "Security & Compliance Center" "Connected ✓" "Green"
        } catch {
            Write-Status "Security & Compliance Center" "Connection unclear" "Yellow"
            Write-Host "      Note: Connection might still work, will test during metrics capture" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Status "Security & Compliance Center" "Error: $($_.Exception.Message)" "Red"
    Write-Host ""
    Write-Host "  Troubleshooting tips:" -ForegroundColor Yellow
    Write-Host "  - Make sure ExchangeOnlineManagement module is installed" -ForegroundColor White
    Write-Host "  - Close PowerShell and reopen as Administrator" -ForegroundColor White
    Write-Host "  - Run: Install-Module ExchangeOnlineManagement -Force" -ForegroundColor White
    Write-Host ""
}

Write-Host ""

# ====================
# 3. AZURE (for Sentinel - Optional)
# ====================
Write-Host "[3/3] Connecting to Azure (Optional)..." -ForegroundColor Cyan
Write-Host "      (Only needed if checking Sentinel deployment)" -ForegroundColor White
Write-Host ""

Write-Host "  Would you like to connect to Azure? (Y/N): " -NoNewline -ForegroundColor Yellow
$connectAzure = Read-Host

if ($connectAzure -eq 'Y' -or $connectAzure -eq 'y') {
    try {
        $azContext = Get-AzContext -ErrorAction SilentlyContinue
        if ($azContext) {
            Write-Status "Azure" "Already Connected ✓" "Green"
            Write-Host "      Account: $($azContext.Account)" -ForegroundColor White
            Write-Host "      Subscription: $($azContext.Subscription.Name)" -ForegroundColor White
        } else {
            Write-Host "  Connecting to Azure (browser will open)..." -ForegroundColor Yellow
            Connect-AzAccount

            $azContext = Get-AzContext
            if ($azContext) {
                Write-Status "Azure" "Connected ✓" "Green"
                Write-Host "      Account: $($azContext.Account)" -ForegroundColor White
            } else {
                Write-Status "Azure" "Failed ✗" "Red"
            }
        }
    } catch {
        Write-Status "Azure" "Error: $($_.Exception.Message)" "Red"
    }
} else {
    Write-Status "Azure" "Skipped" "Yellow"
    Write-Host "      Note: Sentinel data will not be available" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# ====================
# SUMMARY
# ====================
Write-Host "CONNECTION SUMMARY:" -ForegroundColor Cyan
Write-Host ""

$graphConnected = (Get-MgContext) -ne $null
$ippsConnected = $false
try {
    $testConnection = Get-ComplianceSearch -ResultSize 1 -ErrorAction Stop 2>$null
    $ippsConnected = $true
} catch {
    # Try alternative test
    if (Get-Command Get-DlpCompliancePolicy -ErrorAction SilentlyContinue) {
        try {
            Get-DlpCompliancePolicy -ErrorAction Stop 2>$null | Out-Null
            $ippsConnected = $true
        } catch {}
    }
}
$azureConnected = (Get-AzContext -ErrorAction SilentlyContinue) -ne $null

Write-Status "Microsoft Graph" $(if ($graphConnected) {"✓ Connected"} else {"✗ Not Connected"}) $(if ($graphConnected) {"Green"} else {"Red"})
Write-Status "Security & Compliance Center" $(if ($ippsConnected) {"✓ Connected"} else {"✗ Not Connected"}) $(if ($ippsConnected) {"Green"} else {"Red"})
Write-Status "Azure" $(if ($azureConnected) {"✓ Connected"} else {"○ Not Connected (Optional)"}) $(if ($azureConnected) {"Green"} else {"Yellow"})

Write-Host ""

if ($graphConnected -and $ippsConnected) {
    Write-Host "✓ All required services connected!" -ForegroundColor Green
    Write-Host ""
    Write-Host "NEXT STEP:" -ForegroundColor Cyan
    Write-Host "  Run the metrics capture script:" -ForegroundColor White
    Write-Host ""
    Write-Host "  .\Capture-SecurityMetrics.ps1 -ReportName 'BASELINE_Metrics.txt'" -ForegroundColor Yellow
    Write-Host ""
} elseif ($graphConnected) {
    Write-Host "⚠ Partial connection - some data will be unavailable" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Missing:" -ForegroundColor Yellow
    if (-not $ippsConnected) {
        Write-Host "  ✗ Security & Compliance Center (DLP and Labels data will be missing)" -ForegroundColor Red
        Write-Host ""
        Write-Host "To connect:" -ForegroundColor Cyan
        Write-Host "  1. Close PowerShell completely" -ForegroundColor White
        Write-Host "  2. Open NEW PowerShell as Administrator" -ForegroundColor White
        Write-Host "  3. Run: Connect-IPPSSession" -ForegroundColor White
        Write-Host "  4. Run this script again" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "You can still run the capture script, but DLP/Label data will be missing:" -ForegroundColor Yellow
    Write-Host "  .\Capture-SecurityMetrics.ps1 -ReportName 'BASELINE_Metrics.txt'" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "✗ Connection failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Close PowerShell completely" -ForegroundColor White
    Write-Host "  2. Open NEW PowerShell as Administrator" -ForegroundColor White
    Write-Host "  3. Run: Install-Module Microsoft.Graph -Force" -ForegroundColor White
    Write-Host "  4. Run: Install-Module ExchangeOnlineManagement -Force" -ForegroundColor White
    Write-Host "  5. Run this script again" -ForegroundColor White
    Write-Host ""
}

Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
