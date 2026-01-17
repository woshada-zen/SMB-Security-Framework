# Example Deployment Guide
## Real-World SMB Security Framework Implementation

**Strategic Integration Framework for SMB Security**

---

## Overview

This document provides a **real-world example** of deploying the SMB Security Framework to a Microsoft 365 tenant. It demonstrates actual commands, expected outputs, and the step-by-step process followed during a complete 4-phase deployment.

**Deployment Date:** January 2026
**Tenant Size:** 17 users (typical SMB)
**License:** Microsoft 365 Business Premium
**Duration:** Single day (accelerated deployment)

---

## Pre-Deployment Baseline

Before starting, the baseline security posture was captured:

```
╔══════════════════════════════════════════════════════════════════╗
║                  BASELINE SECURITY POSTURE                       ║
╠══════════════════════════════════════════════════════════════════╣
║  Microsoft Secure Score:        28%                              ║
║  MFA Coverage:                  0%   (0 / 17 users)              ║
║  Conditional Access Policies:   0 policies                       ║
║  DLP Policies:                  0 policies                       ║
║  Sensitivity Labels:            0 published                      ║
║  Defender for Endpoint:         Not deployed                     ║
║  Audit Logging:                 Basic                            ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## Phase 1: Identity Foundation

### Step 1.1: Enable MFA for All Users

```powershell
cd "C:\SMB-Security-Framework\Automation-Scripts"
.\Enable-BulkMFA.ps1 -TenantDomain "contoso.onmicrosoft.com"
```

**Expected Output:**
```
[2026-01-17 14:02:25] [INFO] === Bulk MFA Enablement Started ===
[2026-01-17 14:02:25] [INFO] Tenant: contoso.onmicrosoft.com
[2026-01-17 14:02:28] [INFO] Found 17 users requiring MFA
[2026-01-17 14:02:35] [INFO] MFA enabled for 17 users
[2026-01-17 14:02:35] [INFO] === MFA Enablement Complete ===
```

### Step 1.2: Deploy Conditional Access Policies

```powershell
.\Deploy-ConditionalAccessPolicies.ps1 -PolicySet "SMB-Recommended" -Mode "Enabled"
```

**Expected Output:**
```
[2026-01-17 14:10:31] [INFO] === Conditional Access Policy Deployment ===
[2026-01-17 14:10:33] [INFO] Creating policy: CA001-Require-MFA-All-Users
[2026-01-17 14:10:35] [INFO] Creating policy: CA002-Block-Legacy-Auth
[2026-01-17 14:10:37] [INFO] Creating policy: CA003-Require-Compliant-Device
[2026-01-17 14:10:39] [INFO] Creating policy: CA004-Block-High-Risk-SignIns
[2026-01-17 14:10:41] [INFO] Creating policy: CA005-Require-MFA-Azure-Management
[2026-01-17 14:10:43] [INFO] Creating policy: CA006-Session-Timeout-Policy
[2026-01-17 14:10:45] [INFO] === 6 Policies Created Successfully ===
```

**Phase 1 Result:** MFA 100%, 6 Conditional Access policies active

---

## Phase 2: Endpoint Protection

### Step 2.1: Deploy Defender for Endpoint Policies

```powershell
.\Deploy-DefenderForEndpoint.ps1
```

**Expected Output:**
```
[2026-01-17 22:31:26] [INFO] === Defender for Endpoint Deployment ===
[2026-01-17 22:31:28] [INFO] Creating: SMB-EDR-Configuration
[2026-01-17 22:31:30] [INFO] Creating: SMB-ASR-Rules
[2026-01-17 22:31:32] [INFO] Creating: SMB-Windows-Security-Baseline
[2026-01-17 22:31:34] [INFO] Creating: SMB-Edge-Security-Baseline
[2026-01-17 22:31:36] [INFO] Creating: SMB-M365-Apps-Baseline
[2026-01-17 22:31:38] [INFO] Creating: SMB-Antivirus-Policy
[2026-01-17 22:31:40] [INFO] Creating: SMB-Firewall-Policy
╔══════════════════════════════════════════════════════════════════╗
║         DEFENDER FOR ENDPOINT DEPLOYMENT SUMMARY                 ║
╠══════════════════════════════════════════════════════════════════╣
║  Policies Created:    7                                          ║
║  Policies Failed:     0                                          ║
╚══════════════════════════════════════════════════════════════════╝
```

### Step 2.2: Enable ASR Rules

```powershell
.\Enable-ASRRules-v2.ps1 -Mode "Block"
```

### Step 2.3: Create Compliance Policies

```powershell
.\Create-CompliancePolicies.ps1 -PolicySet "SMB-Baseline" -Platforms "All"
```

**Expected Output:**
```
[2026-01-17 23:27:54] [INFO] === Compliance Policy Deployment ===
[2026-01-17 23:28:01] [INFO] Created: Windows 10/11 Compliance - SMB-Baseline
[2026-01-17 23:28:05] [INFO] Created: macOS Compliance - SMB-Baseline
[2026-01-17 23:28:09] [INFO] Created: iOS Compliance - SMB-Baseline
[2026-01-17 23:28:13] [INFO] Created: Android Compliance - SMB-Baseline
║  Policies Created:    4                                          ║
```

### Step 2.4: Configure Windows Update Rings

```powershell
.\Configure-WindowsUpdateRings.ps1 -RingConfiguration "Standard"
```

### Step 2.5: Create App Protection Policies

```powershell
.\Create-AppProtectionPolicies.ps1 -ProtectionLevel "Standard" -Platforms "All"
```

**Expected Output:**
```
[2026-01-17 23:44:30] [INFO] === App Protection Policies Deployment ===
[2026-01-17 23:44:32] [INFO] Created: iOS App Protection - Standard
[2026-01-17 23:44:34] [INFO] Created: Android App Protection - Standard
╔══════════════════════════════════════════════════════════════════╗
║  Protection Level:   Standard                                    ║
║  Wipe After:         90 days inactivity                          ║
║  Policies Created:   2                                           ║
╚══════════════════════════════════════════════════════════════════╝
```

**Phase 2 Result:** 7 Defender policies, 4 compliance policies, 2 app protection policies

---

## Phase 3: Data Governance

### Step 3.1: Deploy Sensitivity Labels

```powershell
.\Deploy-SensitivityLabels.ps1 -LabelSchema "SMB-5Tier" -PublishToAllUsers $true -IncludeSubLabels $true
```

**Expected Output:**
```
[2026-01-18 00:12:42] [INFO] === Sensitivity Labels Deployment ===
[2026-01-18 00:12:44] [INFO] Creating label: Public
[2026-01-18 00:12:46] [INFO] Creating label: Internal
[2026-01-18 00:12:48] [INFO] Creating label: Confidential
[2026-01-18 00:12:50] [INFO] Creating label: Highly Confidential
[2026-01-18 00:12:52] [INFO] Creating label: Restricted
[2026-01-18 00:12:54] [INFO] Creating sub-label: Confidential\Legal
[2026-01-18 00:12:56] [INFO] Creating sub-label: Confidential\Finance
[2026-01-18 00:12:58] [INFO] Creating sub-label: Confidential\HR
╔══════════════════════════════════════════════════════════════════╗
║  Labels Created: 8 (5 main + 3 sub-labels)                       ║
║  Published to: All Users                                         ║
╚══════════════════════════════════════════════════════════════════╝
```

### Step 3.2: Create DLP Policies

```powershell
.\Create-DLPPolicies.ps1 -PolicySet "SMB-Comprehensive" -Mode "TestMode"
```

**Expected Output:**
```
[2026-01-18 00:17:45] [INFO] === DLP Policies Deployment ===
[2026-01-18 00:17:47] [INFO] Creating: DLP-001-GDPR-Personal-Data-Protection
[2026-01-18 00:17:49] [INFO] Creating: DLP-002-Financial-Data-Protection
[2026-01-18 00:17:51] [INFO] Creating: DLP-003-Source-Code-Protection
[2026-01-18 00:17:53] [INFO] Creating: DLP-004-Confidential-Label-Enforcement
[2026-01-18 00:17:55] [INFO] Creating: DLP-005-Teams-Message-Protection
║  Policies Deployed: 5                                            ║
║  Mode: TestMode (users see warnings, no blocking)                ║
```

### Step 3.3: Create Retention Policies

```powershell
.\Create-RetentionPolicies.ps1 -EmailRetentionYears 7 -DocumentRetentionYears 5 -TeamsRetentionYears 1
```

**Expected Output:**
```
[2026-01-18 00:25:21] [INFO] === Retention Policies Deployment ===
[2026-01-18 00:25:23] [INFO] Creating: Email Retention - 7 Years
[2026-01-18 00:25:25] [INFO] Creating: Document Retention - 5 Years
[2026-01-18 00:25:27] [INFO] Creating: Teams Retention - 1 Year
[2026-01-18 00:25:29] [INFO] Creating: Restricted Data - 90 Days
╔══════════════════════════════════════════════════════════════════╗
║  Policies Created:    4                                          ║
║  Email Retention:     7 years (GDPR compliance)                  ║
║  Document Retention:  5 years (SharePoint/OneDrive)              ║
║  Teams Retention:     1 year (storage management)                ║
╚══════════════════════════════════════════════════════════════════╝
```

**Phase 3 Result:** 8 sensitivity labels, 5 DLP policies, 4 retention policies

---

## Phase 4: Security Monitoring

### Step 4.1: Enable Unified Audit Logging

```powershell
.\Enable-UnifiedAuditLog.ps1 -RetentionDays 365 -EnableMailboxAudit $true
```

**Expected Output:**
```
[2026-01-18 00:38:41] [INFO] === Unified Audit Log Configuration ===
[2026-01-18 00:38:43] [INFO] Enabling Unified Audit Log...
[2026-01-18 00:38:45] [INFO] Organization Audit Enabled
[2026-01-18 00:39:01] [INFO] Mailbox Auditing: 0 new + 17 existing
╔══════════════════════════════════════════════════════════════════╗
║  Settings Configured:  4                                         ║
║  Retention: 365 days (license dependent)                         ║
╚══════════════════════════════════════════════════════════════════╝
```

### Step 4.2: Configure Defender Portal

```powershell
.\Configure-DefenderPortal.ps1
```

**Expected Output:**
```
[2026-01-18 00:43:31] [INFO] === Defender Portal Configuration ===
[2026-01-18 00:43:33] [INFO] Alert Policies: 48 of 48 enabled
[2026-01-18 00:43:35] [INFO] Admin Role Alerts: 5 existing policies
[2026-01-18 00:43:37] [INFO] Secure Score Baseline: 45.8%
╔══════════════════════════════════════════════════════════════════╗
║  Alert Policies: 48 enabled                                      ║
║  Secure Score: 45.8%                                             ║
╚══════════════════════════════════════════════════════════════════╝
```

### Step 4.3: Deploy Azure Sentinel (Optional)

*Requires Azure subscription*

```powershell
.\Deploy-Sentinel.ps1 -ResourceGroupName "rg-security" -WorkspaceName "sentinel-smb" -Location "uksouth"
```

**Phase 4 Result:** Audit logging enabled, 48 alert policies, Secure Score tracked

---

## Post-Deployment Summary

### Final Security Posture

```
╔══════════════════════════════════════════════════════════════════╗
║                  FINAL SECURITY POSTURE                          ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  METRIC                    BEFORE    →    AFTER      CHANGE     ║
║  ─────────────────────────────────────────────────────────────   ║
║  Secure Score              28%      →    45.8%       +64%       ║
║  MFA Coverage              0%       →    100%        +100%      ║
║  Conditional Access        0        →    6 policies  +6         ║
║  Defender Policies         0        →    7 policies  +7         ║
║  Compliance Policies       0        →    4 policies  +4         ║
║  App Protection            0        →    2 policies  +2         ║
║  DLP Policies              0        →    5 policies  +5         ║
║  Sensitivity Labels        0        →    8 labels    +8         ║
║  Retention Policies        0        →    4 policies  +4         ║
║  Alert Policies            -        →    48 enabled  New        ║
║  Audit Logging             Basic    →    365 days    Enhanced   ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Policies Deployed Summary

| Phase | Category | Policies/Items |
|-------|----------|----------------|
| **Phase 1** | MFA | 100% coverage (17 users) |
| | Conditional Access | 6 policies |
| **Phase 2** | Defender for Endpoint | 7 policies (EDR, ASR, AV, FW, Baselines) |
| | Device Compliance | 4 policies (Windows, macOS, iOS, Android) |
| | App Protection (MAM) | 2 policies (iOS, Android) |
| | Windows Update | 3 rings configured |
| **Phase 3** | Sensitivity Labels | 8 labels (5 main + 3 sub) |
| | DLP Policies | 5 policies |
| | Retention Policies | 4 policies |
| **Phase 4** | Unified Audit | 365-day retention |
| | Alert Policies | 48 enabled |
| | Secure Score | 45.8% baseline |

---

## Verification Locations

After deployment, verify in these portals:

| Component | Portal | URL |
|-----------|--------|-----|
| MFA & Conditional Access | Entra ID | https://entra.microsoft.com |
| Defender & Compliance Policies | Intune | https://intune.microsoft.com |
| Sensitivity Labels & DLP | Microsoft Purview | https://compliance.microsoft.com |
| Alerts & Secure Score | Microsoft Defender | https://security.microsoft.com |
| Audit Logs | Microsoft Purview | https://compliance.microsoft.com/auditlogsearch |

---

## Manual Steps Required

Some configurations require manual action after script deployment:

1. **App Protection Policies**: Assign to user groups in Intune > Apps > App protection policies
2. **DLP Policies**: After TestMode period, switch to Enforce mode
3. **Sensitivity Labels**: Train users on label selection (appears in Office apps within 24 hours)
4. **Secure Score**: Review improvement recommendations monthly

---

## Time Summary

| Phase | Estimated Manual | With Automation | Savings |
|-------|-----------------|-----------------|---------|
| Phase 1 | 8-12 hours | 2 hours | 75-83% |
| Phase 2 | 12-16 hours | 3 hours | 75-81% |
| Phase 3 | 10-15 hours | 2 hours | 80-87% |
| Phase 4 | 8-12 hours | 1 hour | 88-92% |
| **Total** | **38-55 hours** | **8 hours** | **~80%** |

---

## Next Steps

1. **Week 2-3**: Monitor DLP policy matches, adjust rules if needed
2. **Week 4**: Switch DLP from TestMode to Enforce
3. **Monthly**: Review Secure Score, implement top improvements
4. **Quarterly**: Review and update Conditional Access policies
5. **Annually**: Refresh framework with new Microsoft security features

---

**Framework Version:** 1.0.0
**Deployment Guide Version:** 1.0.0 (January 2026)
**Author:** Woshada Dasanayake | woshada@gmail.com
