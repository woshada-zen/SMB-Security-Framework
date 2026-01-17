# Automation Scripts - Usage Instructions

**Strategic Integration Framework for SMB Security**

---

## Overview

This directory contains PowerShell scripts and ARM templates automating Microsoft 365 and Azure security configuration, reducing implementation time by approximately **55% (31-41 hours savings)**.

---

## Prerequisites

### Software Requirements

**PowerShell Modules:**
```powershell
# Install required PowerShell modules
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
Install-Module Az -Scope CurrentUser -Force
Install-Module Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser -Force
```

**Minimum Versions:**
- PowerShell 7.0+ (download from: https://aka.ms/powershell)
- Microsoft Graph PowerShell SDK 2.0+
- Azure CLI 2.50+ (for Sentinel deployment)

### Authentication

**Connect to Microsoft 365:**
```powershell
# Authenticate to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "DeviceManagementConfiguration.ReadWrite.All", "Policy.ReadWrite.ConditionalAccess"

# Authenticate to Exchange Online
Connect-ExchangeOnline -UserPrincipalName admin@contoso.com

# Authenticate to Azure (for Sentinel)
Connect-AzAccount
```

### Permissions Required

- **Global Administrator** OR
- **Security Administrator** + **Intune Administrator** + **Compliance Administrator**

---

## Script Catalog

### Module 1: Identity Foundation

#### Enable-BulkMFA.ps1
**Purpose:** Bulk enable MFA for user groups

**Parameters:**
- `-UserGroup` (Required): Azure AD group name or "All Users"
- `-MFAMethod` (Optional): "MicrosoftAuthenticator" (default), "SMS", "PhoneCall"
- `-ExcludeGroup` (Optional): Emergency access accounts to exclude

**Usage:**
```powershell
# Enable MFA for all users except emergency accounts
.\Enable-BulkMFA.ps1 -UserGroup "All Users" -MFAMethod "MicrosoftAuthenticator" -ExcludeGroup "Emergency-Access-Accounts"

# Enable MFA for pilot group
.\Enable-BulkMFA.ps1 -UserGroup "Pilot-MFA-Group" -MFAMethod "MicrosoftAuthenticator"
```

**Time Savings:** 3-4 hours for 50+ users

---

#### Deploy-ConditionalAccessPolicies.ps1
**Purpose:** Deploy 6 recommended Conditional Access policies

**Parameters:**
- `-PolicySet` (Required): "SMB-Recommended" (all 6 policies), "Essential" (4 core policies)
- `-Mode` (Optional): "ReportOnly" (test mode), "Enabled" (enforce)
- `-TrustedIPs` (Optional): Comma-separated office IP ranges for location-based policy

**Usage:**
```powershell
# Deploy in test mode first (recommended)
.\Deploy-ConditionalAccessPolicies.ps1 -PolicySet "SMB-Recommended" -Mode "ReportOnly"

# Review for 7 days, then enable enforcement
.\Deploy-ConditionalAccessPolicies.ps1 -PolicySet "SMB-Recommended" -Mode "Enabled" -TrustedIPs "203.0.113.0/24,198.51.100.0/24"
```

**Time Savings:** 2-3 hours

**Policies Deployed:**
1. Require MFA for All Users
2. Block Legacy Authentication
3. Require Compliant or Hybrid Joined Devices
4. Require MFA for Administrators
5. Block Access from Unknown Locations
6. Block High-Risk Sign-Ins (E5 only)

---

### Module 2: Endpoint Protection

#### Deploy-DefenderForEndpoint.ps1
**Purpose:** Deploy Microsoft Defender for Endpoint policies via Intune (EDR, ASR, Antivirus, Firewall, Security Baselines)

**Parameters:**
- `-PolicyPrefix` (Optional): Prefix for policy names (default: "SMB")

**Usage:**
```powershell
# Deploy all 7 Defender for Endpoint policies
.\Deploy-DefenderForEndpoint.ps1

# With custom prefix
.\Deploy-DefenderForEndpoint.ps1 -PolicyPrefix "Contoso"
```

**Policies Created:**
1. EDR Configuration (Endpoint Detection & Response)
2. ASR Rules (Attack Surface Reduction)
3. Windows Security Baseline
4. Microsoft Edge Security Baseline
5. Microsoft 365 Apps Security Baseline
6. Antivirus Policy
7. Firewall Policy

**Time Savings:** 4-5 hours

---

#### Enable-ASRRules-v2.ps1
**Purpose:** Enable Attack Surface Reduction rules via Intune Settings Catalog

**Parameters:**
- `-Mode` (Required): "Audit" (test mode), "Block" (enforce)

**Usage:**
```powershell
# Deploy in Audit mode first (recommended)
.\Enable-ASRRules-v2.ps1 -Mode "Audit"

# After testing, enable enforcement
.\Enable-ASRRules-v2.ps1 -Mode "Block"
```

**Time Savings:** 1-2 hours

---

#### Create-CompliancePolicies.ps1
**Purpose:** Create device compliance policies for Windows, macOS, iOS, Android

**Parameters:**
- `-PolicySet` (Required): "SMB-Baseline" (recommended), "Strict", "Minimal"
- `-Platforms` (Optional): "All", "Windows", "macOS", "iOS", "Android"

**Usage:**
```powershell
# Deploy baseline compliance policies for all platforms
.\Create-CompliancePolicies.ps1 -PolicySet "SMB-Baseline" -Platforms "All"

# Deploy strict policies for Windows only
.\Create-CompliancePolicies.ps1 -PolicySet "Strict" -Platforms "Windows"
```

**Time Savings:** 2 hours

---

#### Configure-WindowsUpdateRings.ps1
**Purpose:** Configure Windows Update rings for phased deployment

**Parameters:**
- `-RingConfiguration` (Optional): "Standard" (default), "Fast", "Slow"

**Usage:**
```powershell
# Deploy standard update rings
.\Configure-WindowsUpdateRings.ps1 -RingConfiguration "Standard"
```

**Time Savings:** 1 hour

---

#### Create-AppProtectionPolicies.ps1
**Purpose:** Create Mobile Application Management (MAM) policies for iOS and Android BYOD

**Parameters:**
- `-ProtectionLevel` (Required): "Standard", "High", "Basic"
- `-Platforms` (Optional): "All", "iOS", "Android"
- `-WipeAfterDays` (Optional): Days before data wipe (default: 90)

**Usage:**
```powershell
# Deploy standard protection for all platforms
.\Create-AppProtectionPolicies.ps1 -ProtectionLevel "Standard" -Platforms "All"

# Deploy high protection for iOS only
.\Create-AppProtectionPolicies.ps1 -ProtectionLevel "High" -Platforms "iOS" -WipeAfterDays 60
```

**Time Savings:** 2 hours

---

### Module 3: Data Governance

#### Deploy-SensitivityLabels.ps1
**Purpose:** Create and publish 5-tier sensitivity label schema

**Parameters:**
- `-LabelSchema` (Required): "SMB-5Tier" (Public/Internal/Confidential/Highly Confidential/Restricted), "SMB-3Tier" (simplified)
- `-PublishToAllUsers` (Optional): $true (all users), $false (pilot group first)
- `-IncludeSubLabels` (Optional): $true (add Confidential\Legal, Finance, HR sub-labels)

**Usage:**
```powershell
# Deploy 5-tier schema to all users
.\Deploy-SensitivityLabels.ps1 -LabelSchema "SMB-5Tier" -PublishToAllUsers $true

# Deploy with sub-labels for granular DLP
.\Deploy-SensitivityLabels.ps1 -LabelSchema "SMB-5Tier" -PublishToAllUsers $true -IncludeSubLabels $true
```

**Time Savings:** 3-4 hours

---

#### Create-DLPPolicies.ps1
**Purpose:** Deploy 5 DLP policy templates

**Parameters:**
- `-PolicySet` (Required): "SMB-Comprehensive" (all 5 policies), "GDPR-Only", "Financial-Only"
- `-Mode` (Required): "TestMode" (policy tips only, no blocking), "Enforce" (block violations)
- `-NotifyComplianceTeam` (Optional): Email address for incident reports

**Usage:**
```powershell
# Week 15-16: Deploy in test mode
.\Create-DLPPolicies.ps1 -PolicySet "SMB-Comprehensive" -Mode "TestMode" -NotifyComplianceTeam "security@contoso.com"

# Week 19-20: Enable enforcement
.\Create-DLPPolicies.ps1 -PolicySet "SMB-Comprehensive" -Mode "Enforce" -NotifyComplianceTeam "security@contoso.com"
```

**Time Savings:** 4-5 hours

**Policies Created:**
1. Protect Personal Data (GDPR Compliance)
2. Protect Financial Data
3. Prevent Source Code Exfiltration
4. Confidential Label Enforcement
5. Teams Message Protection

---

#### Create-RetentionPolicies.ps1
**Purpose:** Create retention policies for email, documents, and Teams

**Parameters:**
- `-EmailRetentionYears` (Optional): Email retention period (default: 7)
- `-DocumentRetentionYears` (Optional): Document retention period (default: 5)
- `-TeamsRetentionYears` (Optional): Teams retention period (default: 1)

**Usage:**
```powershell
# Deploy with default retention periods
.\Create-RetentionPolicies.ps1

# Custom retention periods
.\Create-RetentionPolicies.ps1 -EmailRetentionYears 7 -DocumentRetentionYears 5 -TeamsRetentionYears 1
```

**Policies Created:**
1. Email Retention - 7 Years (GDPR compliance)
2. Document Retention - 5 Years (SharePoint/OneDrive)
3. Teams Retention - 1 Year (storage management)
4. Restricted Data - 90 Days (minimize exposure)

**Time Savings:** 1-2 hours

---

### Module 4: Security Monitoring

#### Enable-UnifiedAuditLog.ps1
**Purpose:** Enable organization-wide audit logging with extended retention

**Parameters:**
- `-RetentionDays` (Optional): 90, 180, or 365 (default: 365)
- `-EnableMailboxAudit` (Optional): Enable mailbox auditing (default: $true)

**Usage:**
```powershell
# Enable with 365-day retention
.\Enable-UnifiedAuditLog.ps1 -RetentionDays 365 -EnableMailboxAudit $true
```

**What's Captured:**
- User sign-in activity (success/failure)
- File access in SharePoint/OneDrive
- Email send/receive activity
- Admin configuration changes
- Role assignments and permission changes
- MFA events and Conditional Access

**Time Savings:** 1 hour

---

#### Configure-DefenderPortal.ps1
**Purpose:** Configure Microsoft Defender portal settings and capture Secure Score baseline

**Parameters:**
- `-SecurityTeamEmail` (Optional): Email for security notifications

**Usage:**
```powershell
# Configure with notification email
.\Configure-DefenderPortal.ps1 -SecurityTeamEmail "security@contoso.com"

# Configure without email
.\Configure-DefenderPortal.ps1
```

**Time Savings:** 2-3 hours

---

#### Deploy-Sentinel.ps1
**Purpose:** Deploy Azure Sentinel via PowerShell (requires Azure subscription)

**Parameters:**
- `-ResourceGroupName` (Required): Azure resource group name
- `-WorkspaceName` (Optional): Log Analytics workspace name (default: sentinel-smb)
- `-Location` (Optional): Azure region (default: uksouth)
- `-RetentionDays` (Optional): Data retention 30-730 days (default: 90)

**Usage:**
```powershell
# Deploy Sentinel
.\Deploy-Sentinel.ps1 -ResourceGroupName "rg-security" -WorkspaceName "sentinel-smb" -Location "uksouth" -RetentionDays 90
```

**Time Savings:** 6-8 hours

---

#### Deploy-Sentinel.json (ARM Template)
**Purpose:** One-click Azure Sentinel deployment with pre-configured data connectors and analytics rules

**Parameters (in template):**
- `workspaceName`: Log Analytics workspace name
- `location`: Azure region (ukSouth, westEurope, eastUS)
- `dataRetentionDays`: 90 (default), 365 (recommended for E5)

**Usage:**
```powershell
# Deploy via Azure CLI
az deployment group create --resource-group rg-security --template-file Deploy-Sentinel.json --parameters workspaceName=sentinel-smb location=ukSouth dataRetentionDays=365

# Or deploy via PowerShell
New-AzResourceGroupDeployment -ResourceGroupName "rg-security" -TemplateFile "Deploy-Sentinel.json" -workspaceName "sentinel-smb" -location "ukSouth" -dataRetentionDays 365
```

**Template Includes:**
- Log Analytics workspace
- Microsoft Sentinel solution
- Data connectors: Office 365, Azure AD, Defender for Endpoint, Defender for Office 365
- 20 analytics rules pre-configured
- Sample workbooks for visualization

---

## Best Practices

### 1. Test in Pilot Environment First

**Recommendation:** Always test scripts with a small pilot group before organization-wide deployment.

**Example Workflow:**
1. Create pilot Azure AD group: "Pilot-Security-Testing" (10-20 users)
2. Run script targeting pilot group
3. Monitor for 7 days, gather feedback
4. Adjust parameters based on lessons learned
5. Deploy to production

### 2. Use Report-Only / Test Mode

Many scripts support test modes:
- **Conditional Access:** `-Mode "ReportOnly"`
- **ASR Rules:** `-Mode "Audit"`
- **DLP Policies:** `-Mode "TestMode"`

**Always start in test mode**, review impact, then enable enforcement.

### 3. Document Execution

Create execution log:
```powershell
# Start transcript
Start-Transcript -Path "C:\Logs\ScriptExecution_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# Run script
.\Enable-BulkMFA.ps1 -UserGroup "All Users"

# Stop transcript
Stop-Transcript
```

### 4. Backup Before Changes

**Conditional Access:** Export existing policies before deploying new ones
```powershell
# Export current CA policies
Get-MgIdentityConditionalAccessPolicy | ConvertTo-Json -Depth 10 | Out-File "CA-Policies-Backup-$(Get-Date -Format 'yyyyMMdd').json"
```

### 5. Review Execution Results

After running scripts, verify:
- ✅ Expected objects created (policies, labels, rules)
- ✅ Assignments correct (users, groups, devices)
- ✅ No unintended side effects (blocking legitimate access)

---

## Troubleshooting

### Issue: "Insufficient privileges" error

**Cause:** Insufficient Azure AD role or API permissions

**Resolution:**
1. Verify you have Global Administrator or equivalent role
2. Re-connect with required scopes:
```powershell
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess", "User.ReadWrite.All", "DeviceManagementConfiguration.ReadWrite.All"
```

### Issue: Script times out or fails mid-execution

**Cause:** Large organization, network latency, API throttling

**Resolution:**
- Run script in smaller batches (e.g., 50 users at a time)
- Add retry logic with delays
- Check Microsoft 365 Service Health for API issues

### Issue: Objects not appearing immediately after creation

**Cause:** Azure AD replication delay

**Resolution:**
- Wait 15-30 minutes for replication
- Verify in Azure AD portal (not just PowerShell)
- Clear browser cache if viewing in portal

---

## Support

**Issues or Questions:**
- GitHub Issues: [Link to repo issues page]
- Community Discussions: [Link to discussions]
- Documentation: See `/Playbooks/` for detailed module guidance

**Contributing:**
- Improvements and bug fixes welcome
- See CONTRIBUTING.md for guidelines
- Submit pull requests with clear descriptions

---

## Security Considerations

### Credential Protection

**NEVER store credentials in scripts:**
```powershell
# ❌ BAD - Hardcoded credentials
$password = "P@ssw0rd123"

# ✅ GOOD - Prompt for credentials
$credential = Get-Credential

# ✅ BETTER - Use managed identities (Azure Automation)
Connect-MgGraph -Identity
```

### Execution Policy

Set appropriate execution policy:
```powershell
# Allow signed scripts
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# After execution, restrict again (optional)
Set-ExecutionPolicy Restricted -Scope CurrentUser
```

### Audit Logging

All script executions generate audit logs:
- Azure AD audit logs: Sign-ins, policy changes
- Unified audit log: Admin activities

Review monthly in: Purview compliance portal → Audit

---

## Version History

**v1.0.0 (December 2025):**
- Initial release with 10 core scripts
- Covers all 4 framework modules
- Tested with PowerShell 7.4, Microsoft Graph SDK 2.10

---

**Total Time Savings:** 31-41 hours (~55% reduction from manual implementation)

**Next Steps:** See `/Playbooks/` for step-by-step implementation guidance integrating these scripts.
