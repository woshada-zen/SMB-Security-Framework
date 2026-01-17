<#
.SYNOPSIS
    Configure Windows Update for Business rings via Intune.

.DESCRIPTION
    Creates Windows Update rings for staged patch deployment.
    Part of the Strategic Integration Framework for SMB Security - Module 2: Endpoint Protection.

    Creates 2 update rings:
    1. IT Pilot Ring (10% of devices) - Receives updates first for testing
    2. Production Ring (90% of devices) - Receives updates after pilot validation

    Benefits:
    - Staged rollout prevents widespread issues
    - Security patches deployed quickly to pilot, then production
    - Feature updates delayed for stability testing

.PARAMETER PilotGroupName
    Azure AD group name for pilot ring (will be created if doesn't exist)

.PARAMETER QualityDeferralDays
    Days to defer quality/security updates for production ring (default: 7)

.PARAMETER FeatureDeferralDays
    Days to defer feature updates for production ring (default: 90)

.EXAMPLE
    .\Configure-WindowsUpdateRings.ps1 -PilotGroupName "IT-Pilot-Group"

.EXAMPLE
    .\Configure-WindowsUpdateRings.ps1 -PilotGroupName "IT-Pilot-Group" -QualityDeferralDays 14 -FeatureDeferralDays 120
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$PilotGroupName = "Windows-Update-Pilot",

    [Parameter(Mandatory = $false)]
    [int]$QualityDeferralDays = 7,

    [Parameter(Mandatory = $false)]
    [int]$FeatureDeferralDays = 90
)

#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement, Microsoft.Graph.Groups

# Initialize logging
$LogFile = "Windows-Update-Rings-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Windows Update Rings Configuration Started ===" "INFO"
Write-Log "Pilot Group: $PilotGroupName" "INFO"
Write-Log "Quality Update Deferral (Production): $QualityDeferralDays days" "INFO"
Write-Log "Feature Update Deferral (Production): $FeatureDeferralDays days" "INFO"

# ============================================
# Connect to Microsoft Graph
# ============================================

try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes @(
        "DeviceManagementConfiguration.ReadWrite.All",
        "Group.ReadWrite.All"
    ) -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    exit 1
}

$CreatedPolicies = @()
$FailedPolicies = @()

# ============================================
# Create or Get Pilot Group
# ============================================

Write-Log "" "INFO"
Write-Log "=== Setting Up Pilot Group ===" "INFO"

try {
    $PilotGroup = Get-MgGroup -Filter "displayName eq '$PilotGroupName'" -ErrorAction SilentlyContinue

    if ($PilotGroup) {
        Write-Log "Pilot group '$PilotGroupName' already exists - ID: $($PilotGroup.Id)" "INFO"
    } else {
        Write-Log "Creating pilot group: $PilotGroupName" "INFO"
        $PilotGroup = New-MgGroup -DisplayName $PilotGroupName `
            -MailEnabled:$false `
            -MailNickname ($PilotGroupName -replace " ", "") `
            -SecurityEnabled:$true `
            -Description "Windows Update pilot group for early update testing. Add IT staff and early adopters." `
            -ErrorAction Stop
        Write-Log "Pilot group created - ID: $($PilotGroup.Id)" "INFO"
        Write-Log "NOTE: Add pilot users to this group manually in Azure AD" "WARN"
    }
} catch {
    Write-Log "Error with pilot group: $_" "ERROR"
    exit 1
}

# ============================================
# 1. IT Pilot Update Ring
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating IT Pilot Update Ring ===" "INFO"

$PilotRingName = "Windows Update Ring - IT Pilot"
$PilotRingDescription = "Receives updates first for IT testing. Quality updates: 0 days deferral. Feature updates: 30 days deferral."

$ExistingPilot = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$PilotRingName'" -ErrorAction SilentlyContinue

if ($ExistingPilot) {
    Write-Log "Policy '$PilotRingName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $PilotRingName; Reason = "Already exists" }
} else {
    $PilotRingParams = @{
        "@odata.type" = "#microsoft.graph.windowsUpdateForBusinessConfiguration"
        displayName = $PilotRingName
        description = $PilotRingDescription

        # Delivery optimization
        deliveryOptimizationMode = "httpWithPeeringNat"

        # Quality updates (security patches) - immediate for pilot
        qualityUpdatesDeferralPeriodInDays = 0
        qualityUpdatesPauseExpiryDateTime = $null
        qualityUpdatesPaused = $false

        # Feature updates - 30 days for pilot
        featureUpdatesDeferralPeriodInDays = 30
        featureUpdatesPauseExpiryDateTime = $null
        featureUpdatesPaused = $false

        # Automatic update behavior
        automaticUpdateMode = "autoInstallAtMaintenanceTime"

        # Active hours (business hours - no restarts)
        activeHoursStart = "08:00:00"
        activeHoursEnd = "18:00:00"

        # Deadline settings
        deadlineForQualityUpdatesInDays = 3
        deadlineForFeatureUpdatesInDays = 7
        deadlineGracePeriodInDays = 2

        # Driver updates
        driversExcluded = $false

        # Microsoft product updates
        microsoftUpdateServiceAllowed = $true

        # Restart checks
        skipChecksBeforeRestart = $false

        # User experience
        engagedRestartDeadlineInDays = 3
        engagedRestartSnoozeScheduleInDays = 1
        engagedRestartTransitionScheduleInDays = 2

        # Update notifications
        updateNotificationLevel = "defaultNotifications"

        # Allow Windows 11 upgrade
        allowWindows11Upgrade = $true
    }

    try {
        Write-Log "Creating Pilot update ring..." "INFO"
        $NewPilotRing = New-MgDeviceManagementDeviceConfiguration -BodyParameter $PilotRingParams -ErrorAction Stop
        Write-Log "Pilot ring created - ID: $($NewPilotRing.Id)" "INFO"

        # Assign to pilot group
        Start-Sleep -Seconds 2
        $CreatedRing = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$PilotRingName'" -ErrorAction Stop

        if ($CreatedRing) {
            $AssignmentParams = @{
                "@odata.type" = "#microsoft.graph.deviceConfigurationAssignment"
                target = @{
                    "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                    groupId = $PilotGroup.Id
                }
            }

            New-MgDeviceManagementDeviceConfigurationAssignment `
                -DeviceConfigurationId $CreatedRing.Id `
                -BodyParameter $AssignmentParams `
                -ErrorAction Stop

            Write-Log "Pilot ring assigned to group: $PilotGroupName" "INFO"

            $CreatedPolicies += @{
                Name = $PilotRingName
                Id = $CreatedRing.Id
                Type = "Pilot"
                QualityDeferral = 0
                FeatureDeferral = 30
                AssignedTo = $PilotGroupName
            }
        }
    } catch {
        Write-Log "Failed to create Pilot ring: $_" "ERROR"
        $FailedPolicies += @{ Name = $PilotRingName; Reason = $_.Exception.Message }
    }
}

# ============================================
# 2. Production Update Ring
# ============================================

Write-Log "" "INFO"
Write-Log "=== Creating Production Update Ring ===" "INFO"

$ProdRingName = "Windows Update Ring - Production"
$ProdRingDescription = "Production devices. Quality updates: $QualityDeferralDays days deferral. Feature updates: $FeatureDeferralDays days deferral."

$ExistingProd = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$ProdRingName'" -ErrorAction SilentlyContinue

if ($ExistingProd) {
    Write-Log "Policy '$ProdRingName' already exists - skipping" "WARN"
    $FailedPolicies += @{ Name = $ProdRingName; Reason = "Already exists" }
} else {
    $ProdRingParams = @{
        "@odata.type" = "#microsoft.graph.windowsUpdateForBusinessConfiguration"
        displayName = $ProdRingName
        description = $ProdRingDescription

        # Delivery optimization
        deliveryOptimizationMode = "httpWithPeeringNat"

        # Quality updates - deferred for production
        qualityUpdatesDeferralPeriodInDays = $QualityDeferralDays
        qualityUpdatesPauseExpiryDateTime = $null
        qualityUpdatesPaused = $false

        # Feature updates - longer deferral for production
        featureUpdatesDeferralPeriodInDays = $FeatureDeferralDays
        featureUpdatesPauseExpiryDateTime = $null
        featureUpdatesPaused = $false

        # Automatic update behavior
        automaticUpdateMode = "autoInstallAtMaintenanceTime"

        # Active hours (business hours - no restarts)
        activeHoursStart = "08:00:00"
        activeHoursEnd = "18:00:00"

        # Deadline settings - longer for production
        deadlineForQualityUpdatesInDays = 7
        deadlineForFeatureUpdatesInDays = 14
        deadlineGracePeriodInDays = 3

        # Driver updates
        driversExcluded = $false

        # Microsoft product updates
        microsoftUpdateServiceAllowed = $true

        # Restart checks
        skipChecksBeforeRestart = $false

        # User experience - more lenient for production
        engagedRestartDeadlineInDays = 5
        engagedRestartSnoozeScheduleInDays = 2
        engagedRestartTransitionScheduleInDays = 3

        # Update notifications
        updateNotificationLevel = "defaultNotifications"

        # Allow Windows 11 upgrade
        allowWindows11Upgrade = $true
    }

    try {
        Write-Log "Creating Production update ring..." "INFO"
        $NewProdRing = New-MgDeviceManagementDeviceConfiguration -BodyParameter $ProdRingParams -ErrorAction Stop
        Write-Log "Production ring created - ID: $($NewProdRing.Id)" "INFO"

        # Assign to all devices (exclude pilot group)
        Start-Sleep -Seconds 2
        $CreatedRing = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$ProdRingName'" -ErrorAction Stop

        if ($CreatedRing) {
            # Assign to all devices
            $IncludeAssignment = @{
                "@odata.type" = "#microsoft.graph.deviceConfigurationAssignment"
                target = @{
                    "@odata.type" = "#microsoft.graph.allDevicesAssignmentTarget"
                }
            }

            New-MgDeviceManagementDeviceConfigurationAssignment `
                -DeviceConfigurationId $CreatedRing.Id `
                -BodyParameter $IncludeAssignment `
                -ErrorAction Stop

            Write-Log "Production ring assigned to all devices" "INFO"

            # Exclude pilot group
            $ExcludeAssignment = @{
                "@odata.type" = "#microsoft.graph.deviceConfigurationAssignment"
                target = @{
                    "@odata.type" = "#microsoft.graph.exclusionGroupAssignmentTarget"
                    groupId = $PilotGroup.Id
                }
            }

            New-MgDeviceManagementDeviceConfigurationAssignment `
                -DeviceConfigurationId $CreatedRing.Id `
                -BodyParameter $ExcludeAssignment `
                -ErrorAction Stop

            Write-Log "Pilot group excluded from production ring" "INFO"

            $CreatedPolicies += @{
                Name = $ProdRingName
                Id = $CreatedRing.Id
                Type = "Production"
                QualityDeferral = $QualityDeferralDays
                FeatureDeferral = $FeatureDeferralDays
                AssignedTo = "All Devices (excluding $PilotGroupName)"
            }
        }
    } catch {
        Write-Log "Failed to create Production ring: $_" "ERROR"
        $FailedPolicies += @{ Name = $ProdRingName; Reason = $_.Exception.Message }
    }
}

# ============================================
# Deployment Summary
# ============================================

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║          WINDOWS UPDATE RINGS DEPLOYMENT SUMMARY                 ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Update Rings Created:  $($CreatedPolicies.Count)" "INFO"
Write-Log "║  Rings Skipped:         $($FailedPolicies.Count)" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "=== UPDATE RING CONFIGURATION ===" "INFO"
Write-Log "" "INFO"
Write-Log "┌─────────────────────────────────────────────────────────────────┐" "INFO"
Write-Log "│  RING           │ QUALITY UPDATES │ FEATURE UPDATES │ TARGET   │" "INFO"
Write-Log "├─────────────────────────────────────────────────────────────────┤" "INFO"
Write-Log "│  IT Pilot       │ 0 days (immediate) │ 30 days       │ Pilot Group │" "INFO"
Write-Log "│  Production     │ $QualityDeferralDays days            │ $FeatureDeferralDays days       │ All Others  │" "INFO"
Write-Log "└─────────────────────────────────────────────────────────────────┘" "INFO"

Write-Log "" "INFO"
Write-Log "=== CREATED POLICIES ===" "INFO"
foreach ($Policy in $CreatedPolicies) {
    Write-Log "  [+] $($Policy.Name)" "INFO"
    Write-Log "      Type: $($Policy.Type)" "INFO"
    Write-Log "      Quality Deferral: $($Policy.QualityDeferral) days" "INFO"
    Write-Log "      Feature Deferral: $($Policy.FeatureDeferral) days" "INFO"
    Write-Log "      Assigned To: $($Policy.AssignedTo)" "INFO"
    Write-Log "      ID: $($Policy.Id)" "INFO"
}

if ($FailedPolicies.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== SKIPPED/FAILED POLICIES ===" "WARN"
    foreach ($Policy in $FailedPolicies) {
        Write-Log "  [-] $($Policy.Name): $($Policy.Reason)" "WARN"
    }
}

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                         NEXT STEPS                               ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  1. Add IT staff to pilot group: '$PilotGroupName'" "INFO"
Write-Log "║  2. Verify rings in Intune: Devices > Windows > Update rings     ║" "INFO"
Write-Log "║  3. Monitor update compliance in Intune reports                  ║" "INFO"
Write-Log "║  4. Review pilot ring results before updates hit production      ║" "INFO"
Write-Log "║  5. Pause updates if issues detected (via Intune portal)         ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "IMPORTANT: Add users to the pilot group before updates are released!" "WARN"
Write-Log "Azure AD > Groups > $PilotGroupName > Members > Add members" "WARN"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Windows Update Rings Configuration Completed ===" "INFO"

Disconnect-MgGraph | Out-Null

# Return summary
return @{
    Success = $true
    RingsCreated = $CreatedPolicies.Count
    RingsFailed = $FailedPolicies.Count
    PilotGroupId = $PilotGroup.Id
    PilotGroupName = $PilotGroupName
    CreatedPolicies = $CreatedPolicies
    FailedPolicies = $FailedPolicies
}
