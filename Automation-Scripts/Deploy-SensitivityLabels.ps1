<#
.SYNOPSIS
    Deploy sensitivity label taxonomy for data classification.

.DESCRIPTION
    Creates and publishes 5-tier sensitivity label schema (Public, Internal, Confidential, Highly Confidential, Restricted).
    Part of the Strategic Integration Framework for SMB Security - Module 3: Data Governance.

    Estimated Time Savings: 3-4 hours vs. manual configuration

.PARAMETER LabelSchema
    Label schema to deploy: "SMB-5Tier" (recommended), "SMB-3Tier" (simplified)

.PARAMETER PublishToAllUsers
    Publish labels to all users immediately ($true) or pilot group first ($false)

.PARAMETER IncludeSubLabels
    Include sub-labels for Confidential tier: Legal, Finance, HR ($true/$false)

.EXAMPLE
    .\Deploy-SensitivityLabels.ps1 -LabelSchema "SMB-5Tier" -PublishToAllUsers $true
    Deploys 5-tier schema to all users.

.EXAMPLE
    .\Deploy-SensitivityLabels.ps1 -LabelSchema "SMB-5Tier" -PublishToAllUsers $false -IncludeSubLabels $true
    Deploys 5-tier schema with sub-labels to pilot group.

.NOTES
    Author: Strategic Integration Framework for SMB Security
    Version: 1.0.0
    License: CC BY-SA 4.0
    Prerequisites:
    - Azure Information Protection (E3/E5)
    - Information Protection Administrator role
    - Exchange Online PowerShell module
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("SMB-5Tier", "SMB-3Tier")]
    [string]$LabelSchema,

    [Parameter(Mandatory = $false)]
    [bool]$PublishToAllUsers = $true,

    [Parameter(Mandatory = $false)]
    [bool]$IncludeSubLabels = $false
)

#Requires -Modules ExchangeOnlineManagement

# Initialize logging
$LogFile = "SensitivityLabels-Deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "=== Sensitivity Labels Deployment Started ===" "INFO"
Write-Log "Label Schema: $LabelSchema" "INFO"
Write-Log "Publish to All Users: $PublishToAllUsers" "INFO"
Write-Log "Include Sub-Labels: $IncludeSubLabels" "INFO"

# Connect to Security & Compliance Center
try {
    Write-Log "Connecting to Security & Compliance Center..." "INFO"
    Connect-IPPSSession -ErrorAction Stop
    Write-Log "Successfully connected" "INFO"
} catch {
    Write-Log "Failed to connect: $_" "ERROR"
    exit 1
}

# Define 5-Tier Label Schema
$Label5Tier = @(
    @{
        Name = "Public"
        DisplayName = "Public"
        Comment = "Information intended for public disclosure"
        Tooltip = "Use for marketing materials, public website content, press releases"
        Priority = 0
        EncryptionEnabled = $false
        ContentMarking = $false
        Color = "#00FF00"  # Green
    },
    @{
        Name = "Internal"
        DisplayName = "Internal"
        Comment = "General business information for internal use only"
        Tooltip = "Use for internal memos, project plans, meeting notes"
        Priority = 1
        EncryptionEnabled = $false
        ContentMarking = $true
        WatermarkText = "Internal Use Only"
        Color = "#0000FF"  # Blue
    },
    @{
        Name = "Confidential"
        DisplayName = "Confidential"
        Comment = "Sensitive business information requiring protection"
        Tooltip = "Use for financial reports, contracts, employee data"
        Priority = 2
        EncryptionEnabled = $true
        ContentMarking = $true
        WatermarkText = "CONFIDENTIAL"
        Color = "#FFFF00"  # Yellow
        PreventForwarding = $true
    },
    @{
        Name = "Highly Confidential"
        DisplayName = "Highly Confidential"
        Comment = "Critical business information with severe impact if disclosed"
        Tooltip = "Use for board minutes, M&A documents, trade secrets"
        Priority = 3
        EncryptionEnabled = $true
        ContentMarking = $true
        WatermarkText = "HIGHLY CONFIDENTIAL"
        Color = "#FFA500"  # Orange
        PreventCopy = $true
        PreventPrint = $true
        ContentExpiration = 90  # Days
    },
    @{
        Name = "Restricted"
        DisplayName = "Restricted"
        Comment = "Information subject to regulatory/legal restrictions"
        Tooltip = "Use for personal data (GDPR), health records, payment card data"
        Priority = 4
        EncryptionEnabled = $true
        ContentMarking = $true
        WatermarkText = "RESTRICTED"
        Color = "#FF0000"  # Red
        PreventCopy = $true
        PreventPrint = $true
        AuditAllAccess = $true
    }
)

# Define 3-Tier Label Schema (simplified)
$Label3Tier = @(
    $Label5Tier[0],  # Public
    $Label5Tier[2],  # Confidential (skipping Internal)
    $Label5Tier[4]   # Restricted
)

# Select schema
$LabelsToCreate = if ($LabelSchema -eq "SMB-5Tier") { $Label5Tier } else { $Label3Tier }

Write-Log "Creating $($LabelsToCreate.Count) sensitivity labels..." "INFO"

# Create labels
$CreatedLabels = @()

foreach ($LabelConfig in $LabelsToCreate) {
    try {
        Write-Log "Creating label: $($LabelConfig.DisplayName)..." "INFO"

        # Check if label already exists
        $ExistingLabel = Get-Label -Identity $LabelConfig.Name -ErrorAction SilentlyContinue

        if ($ExistingLabel) {
            Write-Log "  Label already exists - Skipping" "WARN"
            $CreatedLabels += $ExistingLabel
            continue
        }

        if ($PSCmdlet.ShouldProcess($LabelConfig.DisplayName, "Create sensitivity label")) {
            # Build label parameters
            $LabelParams = @{
                Name = $LabelConfig.Name
                DisplayName = $LabelConfig.DisplayName
                Comment = $LabelConfig.Comment
                Tooltip = $LabelConfig.Tooltip
                Priority = $LabelConfig.Priority
            }

            # Add encryption if enabled
            if ($LabelConfig.EncryptionEnabled) {
                $LabelParams.EncryptionEnabled = $true
                $LabelParams.EncryptionProtectionType = "Template"
                $LabelParams.EncryptionRightsDefinitions = "All@All:VIEW,EDIT"

                if ($LabelConfig.PreventForwarding) {
                    $LabelParams.EncryptionDoNotForward = $true
                }
            }

            # Add content marking (watermark)
            if ($LabelConfig.ContentMarking) {
                $LabelParams.ContentType = "File,Email"
                $LabelParams.ApplyWaterMarkingText = $LabelConfig.WatermarkText
                $LabelParams.ApplyWaterMarkingFontSize = 18
                $LabelParams.ApplyWaterMarkingFontColor = "#808080"
                $LabelParams.ApplyWaterMarkingLayout = "Diagonal"
            }

            # Create the label
            $NewLabel = New-Label @LabelParams
            Write-Log "  Successfully created label: $($NewLabel.ImmutableId)" "INFO"
            $CreatedLabels += $NewLabel
        }
    } catch {
        Write-Log "  Error creating label $($LabelConfig.DisplayName): $_" "ERROR"
    }
}

# Create sub-labels for Confidential (if requested)
if ($IncludeSubLabels -and $LabelSchema -eq "SMB-5Tier") {
    Write-Log "" "INFO"
    Write-Log "Creating sub-labels for Confidential tier..." "INFO"

    $SubLabels = @(
        @{
            Name = "Confidential-Legal"
            DisplayName = "Confidential\Legal"
            ParentLabel = "Confidential"
            Comment = "Legal and attorney-client privileged information"
        },
        @{
            Name = "Confidential-Finance"
            DisplayName = "Confidential\Finance"
            ParentLabel = "Confidential"
            Comment = "Financial data and reports"
        },
        @{
            Name = "Confidential-HR"
            DisplayName = "Confidential\HR"
            ParentLabel = "Confidential"
            Comment = "Human resources and employee information"
        }
    )

    foreach ($SubLabelConfig in $SubLabels) {
        try {
            $ParentLabel = $CreatedLabels | Where-Object { $_.Name -eq $SubLabelConfig.ParentLabel }

            if ($ParentLabel) {
                Write-Log "  Creating sub-label: $($SubLabelConfig.DisplayName)..." "INFO"

                $SubLabelParams = @{
                    Name = $SubLabelConfig.Name
                    DisplayName = $SubLabelConfig.DisplayName
                    Comment = $SubLabelConfig.Comment
                    ParentId = $ParentLabel.ImmutableId
                    EncryptionEnabled = $true
                    EncryptionProtectionType = "Template"
                }

                $NewSubLabel = New-Label @SubLabelParams
                Write-Log "    Successfully created sub-label: $($NewSubLabel.ImmutableId)" "INFO"
            }
        } catch {
            Write-Log "    Error creating sub-label: $_" "ERROR"
        }
    }
}

# Publish labels
Write-Log "" "INFO"
Write-Log "Publishing labels..." "INFO"

try {
    $PolicyName = "Sensitivity Labels Policy - $LabelSchema"

    # Check if policy exists
    $ExistingPolicy = Get-LabelPolicy -Identity $PolicyName -ErrorAction SilentlyContinue

    $PolicyParams = @{
        Name = $PolicyName
        Labels = $CreatedLabels.Name
        Comment = "Deployed via Strategic Integration Framework"
    }

    if ($PublishToAllUsers) {
        $PolicyParams.ExchangeLocation = "All"
        $PolicyParams.SharePointLocation = "All"
        $PolicyParams.OneDriveLocation = "All"
        Write-Log "  Publishing to: All Users" "INFO"
    } else {
        # Publish to pilot group (replace with your pilot group)
        $PolicyParams.ExchangeLocation = "pilot-group@contoso.com"
        Write-Log "  Publishing to: Pilot Group" "INFO"
    }

    if ($ExistingPolicy) {
        Write-Log "  Policy already exists - Updating" "WARN"
        Set-LabelPolicy -Identity $PolicyName @PolicyParams
    } else {
        if ($PSCmdlet.ShouldProcess($PolicyName, "Create label policy")) {
            $NewPolicy = New-LabelPolicy @PolicyParams
            Write-Log "  Successfully created label policy: $($NewPolicy.ImmutableId)" "INFO"
        }
    }
} catch {
    Write-Log "  Error publishing labels: $_" "ERROR"
}

# Summary
Write-Log "" "INFO"
Write-Log "=== Sensitivity Labels Deployment Summary ===" "INFO"
Write-Log "Schema: $LabelSchema" "INFO"
Write-Log "Labels Created: $($CreatedLabels.Count)" "INFO"
Write-Log "Published to: $(if ($PublishToAllUsers) { 'All Users' } else { 'Pilot Group' })" "INFO"
Write-Log "" "INFO"
Write-Log "Created Labels:" "INFO"
foreach ($Label in $CreatedLabels) {
    Write-Log "  [√] $($Label.DisplayName)" "INFO"
}

Write-Log "" "INFO"
Write-Log "NEXT STEPS:" "WARN"
Write-Log "1. Labels will appear in Office apps within 24 hours" "WARN"
Write-Log "2. Train users on label taxonomy (see /Training-Materials/Videos/04-Classifying-and-Labeling-Documents.mp4)" "WARN"
Write-Log "3. Configure auto-labeling rules for common patterns" "WARN"
Write-Log "4. Deploy DLP policies to enforce label protection (.\Create-DLPPolicies.ps1)" "WARN"
Write-Log "5. Monitor label adoption: Microsoft Purview > Data classification > Overview" "WARN"
Write-Log "6. Target: 60%+ documents labeled within 30 days" "WARN"
Write-Log "" "INFO"
Write-Log "Log file saved to: $LogFile" "INFO"
Write-Log "=== Script Completed ===" "INFO"

# Disconnect
Disconnect-ExchangeOnline -Confirm:$false | Out-Null
