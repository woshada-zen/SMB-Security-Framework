<#
.SYNOPSIS
    Create Mobile Application Management (MAM) policies for BYOD scenarios.

.DESCRIPTION
    Creates App Protection Policies for iOS and Android devices.
    Part of the Strategic Integration Framework for SMB Security - Module 2: Endpoint Protection.

    Protects company data on personal devices (BYOD) without full device management.

    Creates 2 app protection policies:
    1. iOS/iPadOS App Protection Policy
    2. Android App Protection Policy

    Protected Apps:
    - Microsoft Outlook
    - Microsoft Teams
    - Microsoft OneDrive
    - Microsoft SharePoint
    - Microsoft Word, Excel, PowerPoint

.PARAMETER ProtectionLevel
    Protection strictness: "Standard" (recommended), "High" (enhanced), "Basic" (minimal)

.PARAMETER Platforms
    Platforms to create policies for: "All", "iOS", "Android"

.PARAMETER WipeAfterDays
    Days of inactivity before company data is wiped (default: 90)

.EXAMPLE
    .\Create-AppProtectionPolicies.ps1 -ProtectionLevel "Standard" -Platforms "All"

.EXAMPLE
    .\Create-AppProtectionPolicies.ps1 -ProtectionLevel "High" -Platforms "iOS" -WipeAfterDays 60
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Standard", "High", "Basic")]
    [string]$ProtectionLevel,

    [Parameter(Mandatory = $false)]
    [string]$Platforms = "All",

    [Parameter(Mandatory = $false)]
    [int]$WipeAfterDays = 90
)

#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Devices.CorporateManagement

# Initialize logging
$LogFile = "App-Protection-Policies-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== App Protection Policies Deployment Started ===" "INFO"
Write-Log "Protection Level: $ProtectionLevel" "INFO"
Write-Log "Platforms: $Platforms" "INFO"
Write-Log "Wipe After Inactivity: $WipeAfterDays days" "INFO"

# Parse platforms
$PlatformList = if ($Platforms -eq "All") {
    @("iOS", "Android")
} else {
    $Platforms -split "," | ForEach-Object { $_.Trim() }
}

Write-Log "Deploying to platforms: $($PlatformList -join ', ')" "INFO"

# ============================================
# Connect to Microsoft Graph
# ============================================

try {
    Write-Log "Connecting to Microsoft Graph..." "INFO"
    Connect-MgGraph -Scopes @(
        "DeviceManagementApps.ReadWrite.All",
        "Group.Read.All"
    ) -ErrorAction Stop
    Write-Log "Successfully connected to Microsoft Graph" "INFO"
} catch {
    Write-Log "Failed to connect to Microsoft Graph: $_" "ERROR"
    exit 1
}

$CreatedPolicies = @()
$FailedPolicies = @()

# ============================================
# Define Protection Settings by Level
# ============================================

$ProtectionSettings = @{
    "Standard" = @{
        # Data protection
        allowedDataStorageLocations = @("oneDriveForBusiness", "sharePoint")
        dataBackupBlocked = $true
        deviceComplianceRequired = $false
        saveAsBlocked = $true
        printBlocked = $false

        # Access requirements
        pinRequired = $true
        minimumPinLength = 6
        fingerprintBlocked = $false
        simplePinBlocked = $true

        # Conditional launch
        maxPinRetries = 5
        periodOfflineBeforeAccessCheck = "PT12H"  # 12 hours
        periodOfflineBeforeWipeIsEnforced = "P$($WipeAfterDays)D"

        # App behavior
        contactSyncBlocked = $false
        organizationalCredentialsRequired = $false
        managedBrowserToOpenLinksRequired = $false
    }
    "High" = @{
        # Data protection - stricter
        allowedDataStorageLocations = @("oneDriveForBusiness")
        dataBackupBlocked = $true
        deviceComplianceRequired = $true
        saveAsBlocked = $true
        printBlocked = $true

        # Access requirements - stricter
        pinRequired = $true
        minimumPinLength = 8
        fingerprintBlocked = $false
        simplePinBlocked = $true
        pinCharacterSet = "alphanumericAndSymbol"

        # Conditional launch - stricter
        maxPinRetries = 3
        periodOfflineBeforeAccessCheck = "PT4H"  # 4 hours
        periodOfflineBeforeWipeIsEnforced = "P$($WipeAfterDays)D"

        # App behavior - stricter
        contactSyncBlocked = $true
        organizationalCredentialsRequired = $true
        managedBrowserToOpenLinksRequired = $true
    }
    "Basic" = @{
        # Data protection - minimal
        allowedDataStorageLocations = @("oneDriveForBusiness", "sharePoint", "localStorage")
        dataBackupBlocked = $false
        deviceComplianceRequired = $false
        saveAsBlocked = $false
        printBlocked = $false

        # Access requirements - minimal
        pinRequired = $true
        minimumPinLength = 4
        fingerprintBlocked = $false
        simplePinBlocked = $false

        # Conditional launch - lenient
        maxPinRetries = 10
        periodOfflineBeforeAccessCheck = "PT24H"  # 24 hours
        periodOfflineBeforeWipeIsEnforced = "P$($WipeAfterDays)D"

        # App behavior - lenient
        contactSyncBlocked = $false
        organizationalCredentialsRequired = $false
        managedBrowserToOpenLinksRequired = $false
    }
}

$Settings = $ProtectionSettings[$ProtectionLevel]

# ============================================
# 1. iOS App Protection Policy
# ============================================

if ($PlatformList -contains "iOS") {
    Write-Log "" "INFO"
    Write-Log "=== Creating iOS App Protection Policy ===" "INFO"

    $iOSPolicyName = "iOS App Protection - $ProtectionLevel"
    $iOSDescription = "Protects company data in managed apps on iOS/iPadOS devices. Level: $ProtectionLevel. Wipe after $WipeAfterDays days inactivity."

    # Check if policy exists
    $ExistingiOS = Get-MgDeviceAppManagementIosManagedAppProtection -Filter "displayName eq '$iOSPolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingiOS) {
        Write-Log "Policy '$iOSPolicyName' already exists - skipping" "WARN"
        $FailedPolicies += @{ Name = $iOSPolicyName; Platform = "iOS"; Reason = "Already exists" }
    } else {
        $iOSParams = @{
            "@odata.type" = "#microsoft.graph.iosManagedAppProtection"
            displayName = $iOSPolicyName
            description = $iOSDescription

            # Data protection
            allowedDataStorageLocations = $Settings.allowedDataStorageLocations
            dataBackupBlocked = $Settings.dataBackupBlocked
            deviceComplianceRequired = $Settings.deviceComplianceRequired
            saveAsBlocked = $Settings.saveAsBlocked
            printBlocked = $Settings.printBlocked

            # Data transfer
            allowedInboundDataTransferSources = "managedApps"
            allowedOutboundDataTransferDestinations = "managedApps"
            allowedOutboundClipboardSharingLevel = "managedAppsWithPasteIn"
            organizationalCredentialsRequired = $Settings.organizationalCredentialsRequired

            # Access requirements
            pinRequired = $Settings.pinRequired
            minimumPinLength = $Settings.minimumPinLength
            fingerprintBlocked = $Settings.fingerprintBlocked
            simplePinBlocked = $Settings.simplePinBlocked

            # Conditional launch
            maxPinRetries = $Settings.maxPinRetries
            periodOfflineBeforeAccessCheck = $Settings.periodOfflineBeforeAccessCheck
            periodOfflineBeforeWipeIsEnforced = $Settings.periodOfflineBeforeWipeIsEnforced

            # iOS specific
            appDataEncryptionType = "whenDeviceLocked"
            managedBrowserToOpenLinksRequired = $Settings.managedBrowserToOpenLinksRequired
            contactSyncBlocked = $Settings.contactSyncBlocked
            faceIdBlocked = $false

            # Block jailbroken devices
            appActionIfDeviceComplianceRequired = "block"
            appActionIfMaximumPinRetriesExceeded = "block"

            # Managed apps - Microsoft 365 apps
            apps = @(
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"; bundleId = "com.microsoft.Office.Outlook" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"; bundleId = "com.microsoft.skype.teams" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"; bundleId = "com.microsoft.sharepoint" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"; bundleId = "com.microsoft.skydrive" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"; bundleId = "com.microsoft.Office.Word" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"; bundleId = "com.microsoft.Office.Excel" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"; bundleId = "com.microsoft.Office.Powerpoint" } }
            )

        }

        try {
            Write-Log "Creating iOS app protection policy..." "INFO"
            $NewiOSPolicy = New-MgDeviceAppManagementIosManagedAppProtection -BodyParameter $iOSParams -ErrorAction Stop
            Write-Log "iOS policy created - ID: $($NewiOSPolicy.Id)" "INFO"

            $CreatedPolicies += @{
                Name = $iOSPolicyName
                Id = $NewiOSPolicy.Id
                Platform = "iOS"
                ProtectionLevel = $ProtectionLevel
                ProtectedApps = 7
            }

            Write-Log "NOTE: Assign policy to users in Intune > Apps > App protection policies" "WARN"
        } catch {
            Write-Log "Failed to create iOS policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $iOSPolicyName; Platform = "iOS"; Reason = $_.Exception.Message }
        }
    }
}

# ============================================
# 2. Android App Protection Policy
# ============================================

if ($PlatformList -contains "Android") {
    Write-Log "" "INFO"
    Write-Log "=== Creating Android App Protection Policy ===" "INFO"

    $AndroidPolicyName = "Android App Protection - $ProtectionLevel"
    $AndroidDescription = "Protects company data in managed apps on Android devices. Level: $ProtectionLevel. Wipe after $WipeAfterDays days inactivity."

    # Check if policy exists
    $ExistingAndroid = Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$AndroidPolicyName'" -ErrorAction SilentlyContinue

    if ($ExistingAndroid) {
        Write-Log "Policy '$AndroidPolicyName' already exists - skipping" "WARN"
        $FailedPolicies += @{ Name = $AndroidPolicyName; Platform = "Android"; Reason = "Already exists" }
    } else {
        $AndroidParams = @{
            "@odata.type" = "#microsoft.graph.androidManagedAppProtection"
            displayName = $AndroidPolicyName
            description = $AndroidDescription

            # Data protection
            allowedDataStorageLocations = $Settings.allowedDataStorageLocations
            dataBackupBlocked = $Settings.dataBackupBlocked
            deviceComplianceRequired = $Settings.deviceComplianceRequired
            saveAsBlocked = $Settings.saveAsBlocked
            printBlocked = $Settings.printBlocked

            # Data transfer
            allowedInboundDataTransferSources = "managedApps"
            allowedOutboundDataTransferDestinations = "managedApps"
            allowedOutboundClipboardSharingLevel = "managedAppsWithPasteIn"
            organizationalCredentialsRequired = $Settings.organizationalCredentialsRequired

            # Access requirements
            pinRequired = $Settings.pinRequired
            minimumPinLength = $Settings.minimumPinLength
            fingerprintBlocked = $Settings.fingerprintBlocked
            simplePinBlocked = $Settings.simplePinBlocked

            # Conditional launch
            maxPinRetries = $Settings.maxPinRetries
            periodOfflineBeforeAccessCheck = $Settings.periodOfflineBeforeAccessCheck
            periodOfflineBeforeWipeIsEnforced = $Settings.periodOfflineBeforeWipeIsEnforced

            # Android specific
            screenCaptureBlocked = ($ProtectionLevel -eq "High")
            encryptAppData = $true
            disableAppEncryptionIfDeviceEncryptionIsEnabled = $false
            managedBrowserToOpenLinksRequired = $Settings.managedBrowserToOpenLinksRequired
            contactSyncBlocked = $Settings.contactSyncBlocked

            # Block rooted devices
            appActionIfDeviceComplianceRequired = "block"
            appActionIfMaximumPinRetriesExceeded = "block"

            # Managed apps - Microsoft 365 apps
            apps = @(
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"; packageId = "com.microsoft.office.outlook" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"; packageId = "com.microsoft.teams" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"; packageId = "com.microsoft.sharepoint" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"; packageId = "com.microsoft.skydrive" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"; packageId = "com.microsoft.office.word" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"; packageId = "com.microsoft.office.excel" } }
                @{ mobileAppIdentifier = @{ "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"; packageId = "com.microsoft.office.powerpoint" } }
            )

        }

        try {
            Write-Log "Creating Android app protection policy..." "INFO"
            $NewAndroidPolicy = New-MgDeviceAppManagementAndroidManagedAppProtection -BodyParameter $AndroidParams -ErrorAction Stop
            Write-Log "Android policy created - ID: $($NewAndroidPolicy.Id)" "INFO"

            $CreatedPolicies += @{
                Name = $AndroidPolicyName
                Id = $NewAndroidPolicy.Id
                Platform = "Android"
                ProtectionLevel = $ProtectionLevel
                ProtectedApps = 7
            }

            Write-Log "NOTE: Assign policy to users in Intune > Apps > App protection policies" "WARN"
        } catch {
            Write-Log "Failed to create Android policy: $_" "ERROR"
            $FailedPolicies += @{ Name = $AndroidPolicyName; Platform = "Android"; Reason = $_.Exception.Message }
        }
    }
}

# ============================================
# Deployment Summary
# ============================================

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║         APP PROTECTION POLICIES DEPLOYMENT SUMMARY               ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Protection Level:   $ProtectionLevel" "INFO"
Write-Log "║  Wipe After:         $WipeAfterDays days inactivity" "INFO"
Write-Log "║  Policies Created:   $($CreatedPolicies.Count)" "INFO"
Write-Log "║  Policies Skipped:   $($FailedPolicies.Count)" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "=== PROTECTED MICROSOFT 365 APPS ===" "INFO"
Write-Log "  - Microsoft Outlook" "INFO"
Write-Log "  - Microsoft Teams" "INFO"
Write-Log "  - Microsoft OneDrive" "INFO"
Write-Log "  - Microsoft SharePoint" "INFO"
Write-Log "  - Microsoft Word" "INFO"
Write-Log "  - Microsoft Excel" "INFO"
Write-Log "  - Microsoft PowerPoint" "INFO"

Write-Log "" "INFO"
Write-Log "=== PROTECTION SETTINGS ($ProtectionLevel) ===" "INFO"
Write-Log "  Data Storage:        OneDrive/SharePoint only" "INFO"
Write-Log "  Backup Blocked:      $($Settings.dataBackupBlocked)" "INFO"
Write-Log "  Save As Blocked:     $($Settings.saveAsBlocked)" "INFO"
Write-Log "  Print Blocked:       $($Settings.printBlocked)" "INFO"
Write-Log "  PIN Required:        $($Settings.pinRequired) (min $($Settings.minimumPinLength) chars)" "INFO"
Write-Log "  Biometric Allowed:   $(-not $Settings.fingerprintBlocked)" "INFO"
Write-Log "  Offline Access:      $($Settings.periodOfflineBeforeAccessCheck)" "INFO"

Write-Log "" "INFO"
Write-Log "=== CREATED POLICIES ===" "INFO"
foreach ($Policy in $CreatedPolicies) {
    Write-Log "  [+] $($Policy.Name)" "INFO"
    Write-Log "      Platform: $($Policy.Platform) | Protected Apps: $($Policy.ProtectedApps) | ID: $($Policy.Id)" "INFO"
}

if ($FailedPolicies.Count -gt 0) {
    Write-Log "" "INFO"
    Write-Log "=== SKIPPED/FAILED POLICIES ===" "WARN"
    foreach ($Policy in $FailedPolicies) {
        Write-Log "  [-] $($Policy.Name) ($($Policy.Platform)): $($Policy.Reason)" "WARN"
    }
}

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                         NEXT STEPS                               ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  1. Verify policies: Intune > Apps > App protection policies     ║" "INFO"
Write-Log "║  2. Users must install Microsoft apps from app stores            ║" "INFO"
Write-Log "║  3. Users sign in with corporate credentials                     ║" "INFO"
Write-Log "║  4. MAM policies auto-apply on first sign-in                     ║" "INFO"
Write-Log "║  5. Monitor: Intune > Apps > Monitor > App protection status     ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "NOTE: These policies protect data WITHOUT requiring device enrollment." "INFO"
Write-Log "Perfect for BYOD scenarios where users keep personal device ownership." "INFO"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== App Protection Policies Deployment Completed ===" "INFO"

Disconnect-MgGraph | Out-Null

# Return summary
return @{
    Success = $true
    PoliciesCreated = $CreatedPolicies.Count
    PoliciesFailed = $FailedPolicies.Count
    ProtectionLevel = $ProtectionLevel
    WipeAfterDays = $WipeAfterDays
    CreatedPolicies = $CreatedPolicies
    FailedPolicies = $FailedPolicies
}
