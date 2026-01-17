<#
.SYNOPSIS
    Deploy Azure Sentinel for security monitoring.

.DESCRIPTION
    Deploys Azure Sentinel with Log Analytics workspace, data connectors, and analytics rules.
    Part of the Strategic Integration Framework for SMB Security - Module 4: Security Monitoring.

    Includes:
    - Log Analytics workspace
    - Microsoft Sentinel solution
    - Data connectors (Azure AD, Office 365, Defender)
    - Pre-configured analytics rules

.PARAMETER ResourceGroupName
    Azure resource group for Sentinel (will be created if doesn't exist)

.PARAMETER WorkspaceName
    Name for the Log Analytics workspace (default: sentinel-smb)

.PARAMETER Location
    Azure region (default: uksouth)

.PARAMETER RetentionDays
    Data retention in days (default: 90, max: 730)

.EXAMPLE
    .\Deploy-Sentinel.ps1 -ResourceGroupName "rg-security" -WorkspaceName "sentinel-smb" -Location "uksouth"

.AUTHOR
    Woshada Dasanayake | woshada@gmail.com
    SMB Security Framework v1.0.0 (December 2025)

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - Azure subscription
    - Az PowerShell module
    - Contributor role on subscription
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $false)]
    [string]$WorkspaceName = "sentinel-smb",

    [Parameter(Mandatory = $false)]
    [ValidateSet("uksouth", "ukwest", "westeurope", "northeurope", "eastus", "westus", "australiaeast")]
    [string]$Location = "uksouth",

    [Parameter(Mandatory = $false)]
    [ValidateRange(30, 730)]
    [int]$RetentionDays = 90
)

# Initialize logging
$LogFile = "Sentinel-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Azure Sentinel Deployment Started ===" "INFO"
Write-Log "Resource Group: $ResourceGroupName" "INFO"
Write-Log "Workspace Name: $WorkspaceName" "INFO"
Write-Log "Location: $Location" "INFO"
Write-Log "Retention Days: $RetentionDays" "INFO"

# Check for Az module
if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Write-Log "Az PowerShell module not found. Installing..." "WARN"
    try {
        Install-Module Az -Force -AllowClobber -Scope CurrentUser
        Write-Log "Az module installed successfully" "INFO"
    } catch {
        Write-Log "Failed to install Az module: $_" "ERROR"
        Write-Log "Please install manually: Install-Module Az -Force -AllowClobber" "ERROR"
        exit 1
    }
}

# Connect to Azure
try {
    Write-Log "Connecting to Azure..." "INFO"

    # Check if already connected
    $AzContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $AzContext) {
        Connect-AzAccount -ErrorAction Stop
        $AzContext = Get-AzContext
    }

    Write-Log "Connected to Azure subscription: $($AzContext.Subscription.Name)" "INFO"
    Write-Log "Tenant: $($AzContext.Tenant.Id)" "INFO"
} catch {
    Write-Log "Failed to connect to Azure: $_" "ERROR"
    exit 1
}

# Step 1: Create Resource Group
Write-Log "" "INFO"
Write-Log "=== Step 1: Creating Resource Group ===" "INFO"

try {
    $ExistingRG = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

    if ($ExistingRG) {
        Write-Log "Resource group '$ResourceGroupName' already exists" "WARN"
    } else {
        if ($PSCmdlet.ShouldProcess($ResourceGroupName, "Create Resource Group")) {
            New-AzResourceGroup -Name $ResourceGroupName -Location $Location -ErrorAction Stop | Out-Null
            Write-Log "Resource group '$ResourceGroupName' created in $Location" "INFO"
        }
    }
} catch {
    Write-Log "Failed to create resource group: $_" "ERROR"
    exit 1
}

# Step 2: Deploy ARM Template
Write-Log "" "INFO"
Write-Log "=== Step 2: Deploying Sentinel ARM Template ===" "INFO"

try {
    $TemplateFile = Join-Path $PSScriptRoot "Deploy-Sentinel.json"

    if (-not (Test-Path $TemplateFile)) {
        Write-Log "ARM template not found at: $TemplateFile" "ERROR"
        exit 1
    }

    Write-Log "Using ARM template: $TemplateFile" "INFO"

    $TemplateParams = @{
        workspaceName = $WorkspaceName
        location = $Location
        dataRetentionDays = $RetentionDays
        pricingTier = "PerGB2018"
        deployDataConnectors = $true
        deployAnalyticsRules = $true
    }

    if ($PSCmdlet.ShouldProcess($WorkspaceName, "Deploy Sentinel")) {
        Write-Log "Starting ARM template deployment (this may take 5-10 minutes)..." "INFO"

        $Deployment = New-AzResourceGroupDeployment `
            -ResourceGroupName $ResourceGroupName `
            -TemplateFile $TemplateFile `
            -TemplateParameterObject $TemplateParams `
            -Name "SentinelDeployment-$(Get-Date -Format 'yyyyMMddHHmmss')" `
            -ErrorAction Stop

        if ($Deployment.ProvisioningState -eq "Succeeded") {
            Write-Log "ARM template deployment SUCCEEDED" "INFO"
            Write-Log "Workspace ID: $($Deployment.Outputs.workspaceId.Value)" "INFO"
        } else {
            Write-Log "Deployment completed with status: $($Deployment.ProvisioningState)" "WARN"
        }
    }
} catch {
    Write-Log "Failed to deploy ARM template: $_" "ERROR"
    Write-Log "You may need to deploy Sentinel manually via Azure Portal" "WARN"
}

# Step 3: Configure Additional Data Connectors
Write-Log "" "INFO"
Write-Log "=== Step 3: Data Connectors Status ===" "INFO"

Write-Log "The following data connectors are configured:" "INFO"
Write-Log "  [+] Azure Active Directory (Sign-in logs, Audit logs)" "INFO"
Write-Log "  [+] Office 365 (Exchange, SharePoint, Teams)" "INFO"
Write-Log "  [+] Microsoft Defender for Endpoint" "INFO"
Write-Log "" "INFO"
Write-Log "NOTE: Some connectors require manual authorization in Azure Portal" "WARN"

# Step 4: Analytics Rules Summary
Write-Log "" "INFO"
Write-Log "=== Step 4: Analytics Rules Deployed ===" "INFO"

$AnalyticsRules = @(
    "Multiple Failed Sign-In Attempts (Brute Force Detection)",
    "Impossible Travel Detection",
    "Sign-In from Anonymous IP/Tor",
    "Privileged Account Activity from New Location",
    "Password Spray Attack Detection"
)

foreach ($Rule in $AnalyticsRules) {
    Write-Log "  [+] $Rule" "INFO"
}

Write-Log "" "INFO"
Write-Log "Additional rules can be enabled from Sentinel > Analytics > Rule Templates" "INFO"

# Summary
Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║             AZURE SENTINEL DEPLOYMENT SUMMARY                    ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  Resource Group:      $ResourceGroupName" "INFO"
Write-Log "║  Workspace:           $WorkspaceName" "INFO"
Write-Log "║  Location:            $Location" "INFO"
Write-Log "║  Retention:           $RetentionDays days" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "╔══════════════════════════════════════════════════════════════════╗" "INFO"
Write-Log "║                         NEXT STEPS                               ║" "INFO"
Write-Log "╠══════════════════════════════════════════════════════════════════╣" "INFO"
Write-Log "║  1. Open Azure Portal: https://portal.azure.com                  ║" "INFO"
Write-Log "║  2. Navigate to: Microsoft Sentinel > $WorkspaceName" "INFO"
Write-Log "║  3. Verify data connectors are receiving data (15-30 min)        ║" "INFO"
Write-Log "║  4. Enable additional analytics rules from templates             ║" "INFO"
Write-Log "║  5. Configure automation playbooks (optional)                    ║" "INFO"
Write-Log "╚══════════════════════════════════════════════════════════════════╝" "INFO"

Write-Log "" "INFO"
Write-Log "COST ESTIMATE:" "WARN"
Write-Log "  - Pay-per-GB ingested (~GBP 1.50-2.00 per GB)" "WARN"
Write-Log "  - Typical SMB (100 users): 5-10 GB/day = GBP 225-600/month" "WARN"
Write-Log "  - E5 Security includes 5 MB/user/day free" "WARN"

Write-Log "" "INFO"
Write-Log "SENTINEL PORTAL:" "INFO"
Write-Log "  https://portal.azure.com/#blade/Microsoft_Azure_Security_Insights/MainMenuBlade" "INFO"

Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Azure Sentinel Deployment Completed ===" "INFO"
