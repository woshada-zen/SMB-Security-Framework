# Phase 1 - MFA Enrollment Monitoring Script
# Purpose: Track MFA registration progress during rollout
# Run every 2 hours on rollout day, then daily until 100% coverage

param(
    [switch]$ExportCsv = $true
)

# Connect to Microsoft Graph
Write-Host "`nConnecting to Microsoft Graph..." -ForegroundColor Cyan
try {
    Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All", "User.Read.All" -NoWelcome
    Write-Host "✓ Connected successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Connection failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Get all users (exclude emergency accounts)
Write-Host "`nRetrieving user list..." -ForegroundColor Cyan
$users = Get-MgUser -All -Property UserPrincipalName, Id, DisplayName |
         Where-Object { $_.UserPrincipalName -notlike "emergencyadmin*" }

Write-Host "✓ Found $($users.Count) users (excluding emergency accounts)" -ForegroundColor Green

# Check MFA registration for each user
$enrolled = @()
$notEnrolled = @()
$enrollmentDetails = @()

Write-Host "`nChecking MFA registration status..." -ForegroundColor Cyan

$progress = 0
foreach ($user in $users) {
    $progress++
    Write-Progress -Activity "Checking MFA enrollment" -Status "$progress of $($users.Count)" -PercentComplete (($progress / $users.Count) * 100)

    try {
        $authMethods = Get-MgUserAuthenticationMethod -UserId $user.Id -ErrorAction SilentlyContinue

        # Check for Microsoft Authenticator
        $hasAuthenticator = $authMethods | Where-Object {
            $_.AdditionalProperties.'@odata.type' -match 'microsoft.graph.microsoftAuthenticatorAuthenticationMethod'
        }

        # Check for phone methods
        $hasPhone = $authMethods | Where-Object {
            $_.AdditionalProperties.'@odata.type' -match 'microsoft.graph.phoneAuthenticationMethod'
        }

        # User is enrolled if they have ANY MFA method
        $hasMFA = $hasAuthenticator -or $hasPhone

        if ($hasMFA) {
            $enrolled += $user.UserPrincipalName

            $methods = @()
            if ($hasAuthenticator) { $methods += "Authenticator App" }
            if ($hasPhone) { $methods += "Phone" }

            $enrollmentDetails += [PSCustomObject]@{
                UserPrincipalName = $user.UserPrincipalName
                DisplayName = $user.DisplayName
                Status = "Enrolled"
                Methods = $methods -join ", "
                CheckedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            }
        } else {
            $notEnrolled += $user.UserPrincipalName

            $enrollmentDetails += [PSCustomObject]@{
                UserPrincipalName = $user.UserPrincipalName
                DisplayName = $user.DisplayName
                Status = "Not Enrolled"
                Methods = "None"
                CheckedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            }
        }
    } catch {
        Write-Host "⚠️ Error checking $($user.UserPrincipalName): $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Progress -Activity "Checking MFA enrollment" -Completed

# Calculate coverage
$coverage = if ($users.Count -gt 0) {
    [math]::Round(($enrolled.Count / $users.Count) * 100, 2)
} else {
    0
}

# Display results
Write-Host "`n╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  MFA ENROLLMENT STATUS - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📊 Summary:" -ForegroundColor White
Write-Host "  Total Users: $($users.Count)" -ForegroundColor White
Write-Host "  Enrolled: $($enrolled.Count) " -NoNewline
Write-Host "✓" -ForegroundColor Green
Write-Host "  Not Enrolled: $($notEnrolled.Count) " -NoNewline
if ($notEnrolled.Count -eq 0) {
    Write-Host "✓" -ForegroundColor Green
} else {
    Write-Host "⚠️" -ForegroundColor Yellow
}

Write-Host "`n📈 Coverage: " -NoNewline
if ($coverage -eq 100) {
    Write-Host "$coverage% ✓✓✓ TARGET MET" -ForegroundColor Green
} elseif ($coverage -ge 80) {
    Write-Host "$coverage% ✓ Good progress" -ForegroundColor Green
} elseif ($coverage -ge 50) {
    Write-Host "$coverage% ⚠️ Needs attention" -ForegroundColor Yellow
} else {
    Write-Host "$coverage% ⚠️ Critical - follow up urgently" -ForegroundColor Red
}

# Show unenrolled users
if ($notEnrolled.Count -gt 0) {
    Write-Host "`n⚠️ Users Not Yet Enrolled:" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow

    foreach ($userUPN in $notEnrolled) {
        $userDetails = $enrollmentDetails | Where-Object { $_.UserPrincipalName -eq $userUPN }
        Write-Host "  • $($userDetails.DisplayName) ($userUPN)" -ForegroundColor Yellow
    }

    Write-Host "`n💡 Recommended Actions:" -ForegroundColor Cyan
    Write-Host "  1. Send follow-up email to unenrolled users"
    Write-Host "  2. Contact users directly for 1-on-1 support"
    Write-Host "  3. Check if users have smartphones available"
    Write-Host "  4. Verify users are not blocked from registration"
}

# Export to CSV
if ($ExportCsv) {
    $csvPath = "MFA-Enrollment-Details.csv"
    $enrollmentDetails | Export-Csv -Path $csvPath -NoTypeInformation -Force
    Write-Host "`n✓ Detailed report saved to: $csvPath" -ForegroundColor Green

    # Also append to log file
    $logPath = "MFA-Enrollment-Log.csv"
    $logEntry = [PSCustomObject]@{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TotalUsers = $users.Count
        Enrolled = $enrolled.Count
        NotEnrolled = $notEnrolled.Count
        Coverage = $coverage
        NotEnrolledUsers = ($notEnrolled -join "; ")
    }

    if (Test-Path $logPath) {
        $logEntry | Export-Csv -Path $logPath -Append -NoTypeInformation
    } else {
        $logEntry | Export-Csv -Path $logPath -NoTypeInformation
    }

    Write-Host "✓ Progress logged to: $logPath" -ForegroundColor Green
}

# Disconnect
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Disconnect-MgGraph | Out-Null

# Exit with status code
if ($coverage -eq 100) {
    Write-Host "🎉 MFA enrollment complete! All users registered." -ForegroundColor Green
    exit 0
} else {
    Write-Host "⏳ MFA enrollment in progress. Run this script again later to check progress." -ForegroundColor Yellow
    exit 1
}
