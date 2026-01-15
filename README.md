# SMB Security Framework
## Strategic Integration of Microsoft 365 and Azure Security

**Author:** Woshada Dasanayake | woshada@gmail.com
**Version:** 1.0.0 (December 2025)
**License:** Open Source - Free to use and adapt

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Quick Start Guide](#quick-start-guide)
3. [Step-by-Step Implementation Workflow](#step-by-step-implementation-workflow)
4. [Framework Components](#framework-components)
5. [Detailed Usage Instructions](#detailed-usage-instructions)
6. [Expected Outcomes](#expected-outcomes)
7. [Troubleshooting](#troubleshooting)
8. [Support](#support)

---

## Overview

### The Problem

Small and medium-sized businesses (SMBs) face a critical security paradox:

- ✅ **100%** have Microsoft 365 licenses with powerful security capabilities
- ❌ **60%** struggle with implementation due to complexity
- ❌ **55%** cite configuration overwhelm as a barrier
- ❌ **50%** don't track their security posture (Microsoft Secure Score)
- ❌ **70%** dedicate fewer than 5 hours per week to security

**The challenge isn't lack of tools—it's operationalization.**

### The Solution

This framework provides a **"consultant in a box"** enabling systematic security implementation within typical SMB constraints:

| Metric | Value |
|--------|-------|
| **Total Implementation Time** | 36-55 hours (vs. 85-100 hours manual) |
| **Time Savings** | ~55% reduction through automation |
| **Duration** | 6 months (phased deployment) |
| **Weekly Effort** | 2-5 hours (sustainable) |
| **Cost Savings** | £10,000-25,000 (eliminates consultant dependency) |
| **ROI** | 400-1,100% |

---

## Quick Start Guide

### Prerequisites

**Before you begin, ensure you have:**

✅ Microsoft 365 E3, E5, or Business Premium license
✅ Azure AD Premium P1 (included in E3/E5)
✅ Global Administrator or Security Administrator role
✅ PowerShell 5.1+ installed
✅ 2-5 hours per week available
✅ Executive sponsorship secured

### Installation

```powershell
# 1. Clone or download this repository
git clone https://github.com/[your-repo]/SMB-Security-Framework
cd SMB-Security-Framework

# 2. Install required PowerShell modules
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
Install-Module Az -Scope CurrentUser -Force

# 3. Set execution policy (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Your First Steps (10 Minutes)

1. **Capture your baseline security posture:**
   ```powershell
   cd Assessment-Tools
   .\Connect-All-Services.ps1
   .\Capture-SecurityMetrics.ps1 -ReportName "BASELINE_Metrics.txt"
   ```

2. **Review your baseline report** to understand current gaps

3. **Choose your starting phase** (most organizations start with Phase 1: Identity)

---

## Step-by-Step Implementation Workflow

### 🎯 Complete Implementation Flow

```
START
  │
  ├─> STEP 1: Baseline Assessment (Week 1-2)
  │     │
  │     ├─> 1.1: Capture current security metrics
  │     ├─> 1.2: Identify gaps and priorities
  │     ├─> 1.3: Secure executive approval
  │     └─> 1.4: Communicate to organization
  │
  ├─> STEP 2: Phase 1 - Identity Foundation (Week 3-6)
  │     │
  │     ├─> 2.1: Enable MFA for all users
  │     ├─> 2.2: Deploy Conditional Access policies
  │     ├─> 2.3: Configure password protection
  │     └─> 2.4: Enable Self-Service Password Reset
  │
  ├─> STEP 3: Phase 2 - Endpoint Protection (Week 7-12)
  │     │
  │     ├─> 3.1: Deploy Defender for Endpoint
  │     ├─> 3.2: Create compliance policies
  │     └─> 3.3: Enable Attack Surface Reduction rules
  │
  ├─> STEP 4: Phase 3 - Data Governance (Week 13-20)
  │     │
  │     ├─> 4.1: Deploy sensitivity labels
  │     ├─> 4.2: Configure auto-labeling
  │     └─> 4.3: Create DLP policies
  │
  ├─> STEP 5: Phase 4 - Security Monitoring (Week 21-26)
  │     │
  │     ├─> 5.1: Enable unified audit logging
  │     ├─> 5.2: Configure Defender portal
  │     ├─> 5.3: Deploy Azure Sentinel (optional)
  │     └─> 5.4: Configure analytics rules
  │
  └─> STEP 6: Post-Implementation Assessment
        │
        ├─> 6.1: Capture final security metrics
        ├─> 6.2: Calculate improvements
        └─> 6.3: Report to stakeholders
```

---

## STEP 1: Baseline Assessment (Week 1-2, 4-6 hours)

### Objective
Establish your current security posture to measure improvements and identify priorities.

### 1.1 Capture Current Security Metrics

**Using the Capture-SecurityMetrics.ps1 Tool:**

This automated script captures comprehensive security metrics across your Microsoft 365 environment.

#### **Prerequisites:**
```powershell
# Install required modules (one-time setup)
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
Install-Module Az -Scope CurrentUser -Force
```

#### **Step-by-Step Execution:**

**Method 1: Automated Connection + Capture (Recommended)**

```powershell
# Navigate to Assessment Tools directory
cd C:\Path\To\SMB-Security-Framework\Assessment-Tools

# Step 1: Connect to all required services
.\Connect-All-Services.ps1

# What this does:
#  ✓ Connects to Microsoft Graph
#  ✓ Connects to Security & Compliance Center
#  ✓ Optionally connects to Azure (for Sentinel data)
#  ✓ Tests all connections are valid
#  ✓ Provides clear status for each connection

# Step 2: Run the metrics capture
.\Capture-SecurityMetrics.ps1 -ReportName "BASELINE_Metrics.txt"

# The script captures:
#  ✓ Microsoft Secure Score
#  ✓ MFA coverage across all users
#  ✓ Conditional Access policies
#  ✓ DLP policies
#  ✓ Sensitivity labels
#  ✓ Defender services status
#  ✓ Azure Sentinel deployment
#  ✓ Audit logging configuration
```

**Method 2: Manual Connection + Capture**

```powershell
# Connect to services manually
Connect-MgGraph -Scopes "User.Read.All", "Policy.Read.All", "Directory.Read.All", "SecurityEvents.Read.All", "Organization.Read.All"
Connect-IPPSSession
Connect-AzAccount  # Optional, for Sentinel data

# Run the capture
.\Capture-SecurityMetrics.ps1 -ReportName "BASELINE_Metrics.txt"
```

#### **Understanding Your Baseline Report:**

The script generates a comprehensive report with these sections:

1. **Tenant Information**
   - Tenant domain
   - Organization name
   - Total users

2. **Identity Security**
   - MFA coverage percentage
   - Number of users with/without MFA
   - Conditional Access policy count

3. **Microsoft Secure Score**
   - Overall score percentage
   - Points achieved vs. maximum
   - Score breakdown by category (Identity, Data, Device, Apps, Infrastructure)

4. **Data Protection**
   - Number of DLP policies
   - Number of sensitivity labels published
   - Policy and label details

5. **Defender Services**
   - Deployment status for each Defender service

6. **Azure Sentinel**
   - Deployment status
   - Workspace details (if deployed)

7. **Summary Scorecard**
   - All key metrics in one view
   - Overall security maturity assessment

#### **Example Baseline Report Output:**

```
╔══════════════════════════════════════════════════════════════════╗
║                  BASELINE SECURITY POSTURE                       ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Microsoft Secure Score:        28%  (152 / 550 points)         ║
║  MFA Coverage:                  0%   (0 / 17 users)             ║
║  Conditional Access Policies:   0 policies                      ║
║  DLP Policies:                  0 policies                      ║
║  Sensitivity Labels:            0 published                     ║
║  Sentinel:                      Not deployed                    ║
║                                                                  ║
║  OVERALL MATURITY: LOW - Significant gaps identified            ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### 1.2 Identify Gaps and Priorities

Based on your baseline, identify critical gaps:

**Common Baseline Findings:**
- 🔴 **0% MFA coverage** → Priority 1: Phase 1 (Identity)
- 🔴 **0 Conditional Access policies** → Priority 1: Phase 1
- 🔴 **0 DLP policies** → Priority 2: Phase 3 (Data Governance)
- 🔴 **50% don't track Secure Score** → Immediate action: Set up tracking
- 🔴 **60% lack SIEM** → Priority 3: Phase 4 (Monitoring)

### 1.3 Secure Executive Approval

**Use the baseline report to:**
1. Show current security posture (often revealing)
2. Demonstrate risks (e.g., "0% MFA means any compromised password = full breach")
3. Present framework solution (quantified time/cost)
4. Request 2-5 hours/week resource allocation

**Template Email:**
> Subject: Security Posture Assessment - Immediate Action Required
>
> I've completed a baseline security assessment using Microsoft's Secure Score. Key findings:
>
> - Current Score: 28% (Industry average: 60%)
> - MFA Coverage: 0% (CRITICAL: All accounts vulnerable to credential theft)
> - DLP Policies: 0 (No data exfiltration protection)
>
> I recommend implementing the SMB Security Framework (attached):
> - Duration: 6 months
> - Effort: 2-5 hours/week
> - Cost: £0 (uses existing Microsoft licenses)
> - Expected Outcome: 80%+ Secure Score, comprehensive protection
>
> Request: Approval to proceed with Phase 1 (Identity Foundation) starting [date]

### 1.4 Communicate to Organization

**Announcement template:**
```
Subject: Enhancing Our Security - New Initiative

We're launching a security improvement initiative to protect our data and systems.

What's Changing:
- Week 3-6: Multi-Factor Authentication (MFA) for all users
  [Brief explanation of MFA and why it matters]

- Weeks 7-26: Phased security enhancements
  [High-level overview]

What You Need to Do:
- [Date]: Install Microsoft Authenticator app
- [Date]: Complete MFA enrollment
- [Date]: Attend 15-minute training session

Why This Matters:
[Explain benefits in business terms, not technical jargon]

Questions? Contact: [IT Contact]
```

---

## STEP 2: Phase 1 - Identity Foundation (Week 3-6, 8-12 hours)

### Objective
Establish strong identity security as the foundation for all other controls.

### Why Identity First?

- **Highest Impact:** MFA prevents 99.9% of credential-based attacks
- **Quick Wins:** Immediate Secure Score improvement
- **Foundation:** Required for subsequent phases
- **Low Risk:** Non-disruptive to operations

### 2.1 Enable MFA for All Users (3-4 hours)

**Manual Process (Using Playbook):**
1. Open `/Playbooks/Module-1-Identity-Foundation.pdf`
2. Follow Section 1.2: "Bulk MFA Enablement"
3. Step-by-step with screenshots

**Automated Process (Using Script):**

```powershell
# Navigate to Automation Scripts
cd ..\Automation-Scripts

# Review the script first
Get-Content .\Enable-BulkMFA.ps1

# Execute bulk MFA enablement
.\Enable-BulkMFA.ps1 -TenantDomain "yourtenant.onmicrosoft.com"

# What this does:
#  ✓ Enables MFA for all licensed users
#  ✓ Excludes service accounts (if specified)
#  ✓ Sends enrollment instructions to users
#  ✓ Generates rollout report

# Verify deployment
# Check Azure AD > Users > Per-user MFA
# Should show 100% enabled
```

**Time Savings:**
- Manual: 3-4 hours for 50 users
- Automated: 15 minutes
- **Savings: ~90%**

### 2.2 Deploy Conditional Access Policies (2-3 hours)

**What Are Conditional Access Policies?**

Think of them as "smart gates" that enforce security based on conditions:
- Require MFA when signing in from outside the office
- Block sign-ins from risky locations
- Require compliant devices for accessing sensitive data

**The Framework Deploys 6 Recommended Policies:**

1. **Require MFA for All Users** - Universal MFA enforcement
2. **Block Legacy Authentication** - Prevent insecure protocols
3. **Require Compliant Devices** - Only managed devices can access
4. **Require MFA for Risky Sign-ins** - Extra protection for suspicious activity
5. **Require MFA for Azure Management** - Protect admin portals
6. **Block High-Risk Users** - Auto-block compromised accounts

**Automated Deployment:**

```powershell
# Deploy all 6 recommended policies
.\Deploy-ConditionalAccessPolicies.ps1

# What this does:
#  ✓ Creates 6 Conditional Access policies
#  ✓ Configures each with SMB-appropriate settings
#  ✓ Sets policies to "Report-Only" mode first (safe testing)
#  ✓ Provides instructions for switching to "Enforce" mode

# Verify deployment
# Azure AD > Security > Conditional Access
# Should show 6 policies
```

**Testing Workflow:**

1. **Week 3:** Deploy in Report-Only mode
2. **Week 4:** Monitor impact reports (who would be blocked?)
3. **Week 5:** Adjust exclusions if needed
4. **Week 6:** Switch to Enforce mode

### 2.3 Configure Password Protection (1 hour)

Follow `/Playbooks/Module-1-Identity-Foundation.pdf` Section 1.3

**Quick Steps:**
1. Navigate to Azure AD > Security > Authentication methods
2. Enable Password Protection
3. Configure custom banned password list
4. Enable Smart Lockout

### 2.4 Enable Self-Service Password Reset (1 hour)

Follow `/Playbooks/Module-1-Identity-Foundation.pdf` Section 1.4

**Benefits:**
- Reduces IT helpdesk burden (30-40% of tickets are password resets)
- Faster user productivity restoration
- Required for modern security posture

### 2.5 Verify Phase 1 Completion

**Run Metrics Capture Again:**

```powershell
cd ..\Assessment-Tools
.\Capture-SecurityMetrics.ps1 -ReportName "PHASE1_Complete.txt"
```

**Expected Improvements:**
- MFA Coverage: 0% → **100%** ✅
- Conditional Access: 0 → **6 policies** ✅
- Secure Score: 28% → **50-60%** ✅

---

## STEP 3: Phase 2 - Endpoint Protection (Week 7-12, 6-10 hours)

### Objective
Deploy comprehensive endpoint security and device compliance.

### 3.1 Deploy Defender for Endpoint (4-5 hours)

Follow `/Playbooks/Module-2-Endpoint-Protection.pdf`

**What It Does:**
- Real-time malware protection
- Ransomware detection and blocking
- Device vulnerability assessment
- Centralized device management

### 3.2 Create Compliance Policies (2 hours)

**Automated Deployment:**

```powershell
# Note: This script is part of Deploy-Framework.ps1
# Or follow manual steps in playbook
```

**Policies Created:**
- Minimum OS version requirements
- Encryption requirements
- Password complexity
- Device health attestation

### 3.3 Enable Attack Surface Reduction Rules (1-2 hours)

**Automated Deployment:**

```powershell
cd ..\Automation-Scripts
.\Enable-ASRRules.ps1

# What this does:
#  ✓ Enables 10+ ASR rules
#  ✓ Starts in Audit mode (no disruption)
#  ✓ Provides impact report after 2 weeks
#  ✓ Instructions for switching to Block mode
```

**Verify Phase 2 Completion:**

```powershell
cd ..\Assessment-Tools
.\Capture-SecurityMetrics.ps1 -ReportName "PHASE2_Complete.txt"
```

**Expected Improvements:**
- Defender for Endpoint: Not Deployed → **Deployed** ✅
- Compliance Policies: 0 → **5 policies** ✅
- ASR Rules: 0 → **10+ rules active** ✅
- Secure Score: 50-60% → **65-70%** ✅

---

## STEP 4: Phase 3 - Data Governance (Week 13-20, 10-15 hours)

### Objective
Classify and protect sensitive data with DLP and sensitivity labels.

### 4.1 Deploy Sensitivity Labels (3-4 hours)

**Automated Deployment:**

```powershell
cd ..\Automation-Scripts
.\Deploy-SensitivityLabels.ps1

# What this does:
#  ✓ Creates 5-tier label taxonomy:
#    - Public
#    - Internal
#    - Confidential
#    - Highly Confidential
#    - Restricted
#  ✓ Configures protection settings for each
#  ✓ Publishes labels to all users
#  ✓ Sets up auto-labeling rules
```

**Time Savings:**
- Manual: 3-4 hours
- Automated: 30 minutes
- **Savings: 85%**

### 4.2 Configure Auto-Labeling (2-3 hours)

Follow `/Playbooks/Module-3-Data-Governance.pdf` Section 3.2

**Auto-labeling Rules:**
- Credit card numbers → Highly Confidential
- Passport numbers → Restricted
- Keywords ("Confidential", "Internal Only") → Appropriate labels

### 4.3 Create DLP Policies (4-5 hours)

**Automated Deployment:**

```powershell
.\Create-DLPPolicies.ps1

# What this does:
#  ✓ Creates 5 DLP policy templates:
#    1. Financial Data Protection (credit cards, bank accounts)
#    2. PII Protection (personal identifiable information)
#    3. Health Data Protection (medical records)
#    4. Intellectual Property Protection
#    5. GDPR Compliance Policy
#  ✓ Configures across Exchange, SharePoint, OneDrive, Teams
#  ✓ Sets up policy tips and notifications
#  ✓ Generates deployment report
```

**Time Savings:**
- Manual: 4-5 hours per policy (20-25 hours total)
- Automated: 40 minutes
- **Savings: 95%**

**Verify Phase 3 Completion:**

```powershell
cd ..\Assessment-Tools
.\Capture-SecurityMetrics.ps1 -ReportName "PHASE3_Complete.txt"
```

**Expected Improvements:**
- DLP Policies: 0 → **5 policies** ✅
- Sensitivity Labels: 0 → **5 published** ✅
- Auto-labeling: 0 → **Active** ✅
- Secure Score: 65-70% → **75-80%** ✅

---

## STEP 5: Phase 4 - Security Monitoring (Week 21-26, 8-12 hours)

### Objective
Establish comprehensive security monitoring and automated response.

### 5.1 Enable Unified Audit Logging (1 hour)

Follow `/Playbooks/Module-4-Security-Monitoring.pdf` Section 4.1

### 5.2 Configure Defender Portal (2-3 hours)

**Centralized Security Management:**
- Navigate to https://security.microsoft.com
- Configure alert policies
- Set up notification rules
- Review dashboards

### 5.3 Deploy Azure Sentinel (6-8 hours, optional for E5)

**Automated Deployment:**

```powershell
# This requires Azure subscription
Connect-AzAccount

# Create resource group
New-AzResourceGroup -Name "SMB-Security-RG" -Location "UK South"

# Deploy Sentinel using ARM template
cd ..\Automation-Scripts
New-AzResourceGroupDeployment `
    -ResourceGroupName "SMB-Security-RG" `
    -TemplateFile ".\Deploy-Sentinel.json" `
    -WorkspaceName "SMB-SecurityWorkspace"

# What this does:
#  ✓ Creates Log Analytics workspace
#  ✓ Enables Sentinel
#  ✓ Configures data connectors
#  ✓ Deploys 20+ analytics rules
#  ✓ Sets up automated playbooks
```

**Time Savings:**
- Manual: 6-8 hours
- Automated: 30 minutes
- **Savings: 90%**

### 5.4 Configure Analytics Rules (2-3 hours)

Follow `/Playbooks/Module-4-Security-Monitoring.pdf` Section 4.4

**Verify Phase 4 Completion:**

```powershell
cd ..\Assessment-Tools
.\Capture-SecurityMetrics.ps1 -ReportName "PHASE4_Complete.txt"
```

**Expected Improvements:**
- Audit Logging: Basic → **Advanced** ✅
- Sentinel: Not Deployed → **Deployed with analytics** ✅
- Analytics Rules: 0 → **20+ active** ✅
- Secure Score: 75-80% → **80-85%+** ✅

---

## STEP 6: Post-Implementation Assessment

### 6.1 Capture Final Security Metrics

```powershell
cd Assessment-Tools
.\Capture-SecurityMetrics.ps1 -ReportName "FINAL_Metrics.txt"
```

### 6.2 Calculate Improvements

**Create Comparison Report:**

```
╔══════════════════════════════════════════════════════════════════╗
║              BEFORE vs AFTER FRAMEWORK IMPLEMENTATION            ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  METRIC                    BEFORE    →    AFTER      IMPROVE    ║
║  ───────────────────────────────────────────────────────────    ║
║  Secure Score              28%      →    83%         +196%      ║
║  MFA Coverage              0%       →    100%        +100%      ║
║  Conditional Access        0        →    6           +6         ║
║  DLP Policies              0        →    5           +5         ║
║  Sensitivity Labels        0        →    5           +5         ║
║  Defender Services         0        →    4           +4         ║
║  Sentinel                  No       →    Yes         ✅         ║
║                                                                  ║
║  IMPLEMENTATION TIME: 48 hours over 6 months                    ║
║  TIME SAVED: ~42 hours (47% reduction)                          ║
║  COST SAVINGS: ~£15,000 (vs. external consultant)              ║
╚══════════════════════════════════════════════════════════════════╝
```

### 6.3 Report to Stakeholders

**Executive Summary Template:**

> Subject: Security Framework Implementation - Complete (6-Month Results)
>
> **Implementation Summary:**
> Completed comprehensive security framework deployment over 6 months
>
> **Results:**
> - Microsoft Secure Score: 28% → 83% (+196% improvement)
> - MFA Coverage: 0% → 100% (all 50 users protected)
> - Data Protection: 0 → 5 DLP policies deployed
> - Security Monitoring: Azure Sentinel deployed with 24/7 threat detection
>
> **Business Impact:**
> - Cost Avoidance: £15,000 (vs. external consultant)
> - Time Invested: 48 hours total (vs. estimated 90 hours manual)
> - Risk Reduction: Comprehensive protection against credential theft, ransomware, data exfiltration
> - Compliance: Ready for GDPR, ISO 27001, Cyber Essentials audits
>
> **Next Steps:**
> - Monthly Secure Score reviews
> - Quarterly policy updates
> - Annual framework refresh
>
> Attached: Full metrics report

---

## Framework Components

### 1. Assessment Tools (`/Assessment-Tools/`)

| File | Purpose | Usage |
|------|---------|-------|
| **Capture-SecurityMetrics.ps1** | Automated security posture capture | Run before/after implementation |
| **Connect-All-Services.ps1** | Helper to connect to all Microsoft services | Run before metrics capture |
| **01-Baseline-Security-Questionnaire.md** | Manual assessment questionnaire | Alternative to automated capture |
| **02-Security-Maturity-Scorecard.md** | Post-implementation maturity scoring | Use after completion |

### 2. Automation Scripts (`/Automation-Scripts/`)

| Script | Purpose | Time Savings |
|--------|---------|--------------|
| **Enable-BulkMFA.ps1** | Bulk MFA enablement | 3-4 hours → 15 min |
| **Deploy-ConditionalAccessPolicies.ps1** | Deploy 6 CA policies | 2-3 hours → 30 min |
| **Deploy-SensitivityLabels.ps1** | Deploy 5-tier label schema | 3-4 hours → 30 min |
| **Create-DLPPolicies.ps1** | Deploy 5 DLP policy templates | 20-25 hours → 40 min |
| **Enable-ASRRules.ps1** | Enable Attack Surface Reduction | 2 hours → 20 min |
| **Deploy-Sentinel.json** | Deploy Azure Sentinel (ARM template) | 6-8 hours → 30 min |
| **Deploy-Framework.ps1** | Master deployment script (all phases) | Use for full deployment |

### 3. Governance Templates (`/Governance-Templates/`)

Pre-built policy documents ready to customize:

- Master Information Security Policy
- Acceptable Use Policy
- Data Classification Policy
- Password Policy
- Incident Response Plan
- Business Continuity Plan
- Mobile Device Policy
- Cloud Services Usage Policy
- Remote Work Policy
- Third Party Risk Management Policy
- Change Management Policy
- RACI Matrix

### 4. Playbooks (`/Playbooks/`)

Detailed implementation guides with screenshots (200+ pages total):

- Module 1: Identity Foundation (58 pages)
- Module 2: Endpoint Protection (47 pages)
- Module 3: Data Governance (54 pages)
- Module 4: Security Monitoring (41 pages)

### 5. Training Materials (`/Training-Materials/`)

User awareness and training resources:

- Video modules (10 videos, 60 minutes total)
- Quick-reference guides (8 PDFs)
- Executive presentations (3 decks)
- FAQ documentation

---

## Detailed Usage Instructions

### Using Capture-SecurityMetrics.ps1

#### Prerequisites

```powershell
# Install required modules (one-time)
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
Install-Module Az -Scope CurrentUser -Force
```

#### Basic Usage

```powershell
# Step 1: Connect to services
.\Connect-All-Services.ps1

# Step 2: Run capture
.\Capture-SecurityMetrics.ps1 -ReportName "MyReport.txt"
```

#### Advanced Usage

```powershell
# Specify custom output path
.\Capture-SecurityMetrics.ps1 -OutputPath "C:\Reports" -ReportName "Q1_2025_Baseline.txt"

# The script will:
# 1. Check Microsoft Graph connection
# 2. Retrieve tenant information
# 3. Capture identity security metrics (MFA, CA)
# 4. Capture Microsoft Secure Score
# 5. Capture data protection metrics (DLP, Labels)
# 6. Capture Defender services status
# 7. Capture Azure Sentinel status (if Azure connected)
# 8. Generate summary scorecard
# 9. Save report to specified location
# 10. Offer to open report
```

#### Troubleshooting Connection Issues

**Problem: "DeviceCodeCredential authentication failed"**

```powershell
# Solution: Disconnect and reconnect
Disconnect-MgGraph
Connect-MgGraph -Scopes "User.Read.All", "Policy.Read.All", "Directory.Read.All", "SecurityEvents.Read.All", "Organization.Read.All"

# Then re-run the script
.\Capture-SecurityMetrics.ps1 -ReportName "BASELINE.txt"
```

**Problem: "DLP Policies: Data unavailable"**

```powershell
# Solution: Connect to Security & Compliance Center
Connect-IPPSSession

# Then re-run the script
.\Capture-SecurityMetrics.ps1 -ReportName "BASELINE.txt"
```

**Problem: "Sentinel: Data unavailable"**

```powershell
# Solution: Connect to Azure (optional)
Connect-AzAccount

# Then re-run the script
.\Capture-SecurityMetrics.ps1 -ReportName "BASELINE.txt"
```

#### Report Output Explained

**Section 1: Tenant Information**
- Confirms which tenant you're assessing
- Shows total licensed users

**Section 2: Identity Security**
- **MFA Coverage:** Percentage of users with MFA enabled
  - Target: 100%
  - Red Flag: <90%

**Section 3: Microsoft Secure Score**
- **Overall Score:** Your security posture as percentage
  - Target: 80%+
  - Industry Average: 60%
  - Red Flag: <40%

**Section 4: Data Protection**
- **DLP Policies:** Number of active data loss prevention policies
  - Target: 5+ (covering financial, PII, health, IP, GDPR)
  - Red Flag: 0

**Section 5: Defender Services**
- Shows which Defender services are deployed
  - Target: All 4 services
  - Minimum: Defender for Endpoint + Office 365

**Section 6: Azure Sentinel**
- SIEM deployment status
  - Required for: E5 organizations, compliance requirements
  - Optional for: Small businesses (<50 users)

**Section 7: Summary Scorecard**
- All metrics in one view
- Overall maturity assessment (HIGH/MEDIUM/LOW)

---

## Expected Outcomes

### Security Posture Improvements

| Metric | Typical Baseline | After Framework | Improvement |
|--------|------------------|-----------------|-------------|
| **Microsoft Secure Score** | 28-35% | 80-85% | +150-200% |
| **MFA Coverage** | 0-30% | 100% | +70-100% |
| **Conditional Access** | 0-1 policies | 6 policies | +5-6 policies |
| **DLP Policies** | 0 | 5 policies | +5 policies |
| **Sensitivity Labels** | 0 | 5 published | +5 labels |
| **Defender Services** | 0-1 | 4 services | +3-4 services |
| **Sentinel** | Not deployed | Deployed + analytics | New capability |

### Operational Benefits

- **Time Savings:** 42+ hours (47% reduction)
- **Cost Avoidance:** £10,000-25,000 (consultant fees eliminated)
- **Faster Audits:** 40-60% audit preparation time reduction
- **Improved Response:** Mean Time to Detect (MTTD) and Mean Time to Respond (MTTR) improvements
- **Compliance:** Simplified GDPR, ISO 27001, Cyber Essentials demonstration

### Business Value

- **ROI:** 400-1,100%
- **Risk Reduction:** 10% breach probability reduction = £7,500 expected value savings
- **Customer Trust:** Demonstrable security posture for client contracts
- **Competitive Advantage:** Security as business differentiator
- **Insurance:** Potential cyber insurance premium reductions

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: PowerShell Scripts Won't Run

**Error:** "Running scripts is disabled on this system"

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Issue: Module Not Found

**Error:** "The term 'Connect-MgGraph' is not recognized"

**Solution:**
```powershell
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Import-Module Microsoft.Graph
```

#### Issue: Insufficient Permissions

**Error:** "Authorization_RequestDenied"

**Solution:**
- Ensure you have Global Administrator or Security Administrator role
- Check Azure AD > Roles and administrators
- Contact your tenant administrator if you don't have required permissions

#### Issue: MFA Script Fails

**Error:** "Cannot enable MFA for cloud-only accounts"

**Solution:**
- Check if you have Azure AD Premium P1 license (required for MFA)
- Verify licenses: Microsoft 365 Admin Center > Billing > Licenses
- If missing, upgrade to E3, E5, or Business Premium

#### Issue: Conditional Access Won't Deploy

**Error:** "Conditional Access requires Azure AD Premium"

**Solution:**
- Conditional Access requires Azure AD Premium P1 (included in Microsoft 365 E3/E5)
- Check your licensing: Azure AD > Licenses
- If you have Business Standard, consider upgrading to Business Premium

#### Issue: DLP Policies Don't Deploy

**Error:** "DLP requires E3 or above"

**Solution:**
- Basic DLP: Included in E3, Business Premium
- Advanced DLP: Requires E5 or E5 Compliance add-on
- Check `/Playbooks/` for feature comparison by license

#### Issue: Secure Score Not Improving

**Problem:** Deployed controls but Secure Score unchanged

**Solution:**
- Secure Score updates every 24-48 hours
- Wait 2 days after deployment
- Some improvements require policy enforcement (not just creation)
- Check Secure Score > Recommended Actions for specific requirements

---

## Support

### Documentation

- **Playbooks:** `/Playbooks/` - Detailed step-by-step guides with screenshots
- **Script Documentation:** Each `.ps1` file has detailed inline comments
- **Governance Templates:** `/Governance-Templates/README.md` - Template customization guide

### Getting Help

**Author Contact:**
- **Name:** Woshada Dasanayake
- **Email:** woshada@gmail.com
- **Response Time:** Typically within 48 hours

**Community Support:**
- GitHub Issues: Report bugs, request features, ask questions
- GitHub Discussions: Share experiences, get advice from other users

### Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with clear description

**Areas for contribution:**
- Additional automation scripts
- Playbook improvements (screenshots, troubleshooting)
- Governance template adaptations for specific industries
- Translation to other languages

---

## Citation

If you use this framework in research, publications, or presentations, please cite:

```
SMB Security Framework: Strategic Integration of Microsoft 365 and Azure Security
Author: Woshada Dasanayake (woshada@gmail.com)
Version: 1.0.0 (December 2025)
Based on: "Enhancing Cybersecurity for Small and Medium-Sized Businesses
Through Strategic Integration of Microsoft 365 and Azure Security Services"
```

---

## Version History

**v1.0.0 (December 2025)**
- Initial release based on dissertation research
- 4 configuration playbooks (200+ pages)
- 15+ automation scripts
- 12 governance templates
- 2 assessment tools (including Capture-SecurityMetrics.ps1)
- 10 training videos, 8 quick-references
- Comprehensive README with step-by-step workflow

---

## Acknowledgments

This framework was developed through Design Science Research with:
- 20 participating SMB organizations providing empirical validation
- Mixed-methods evaluation demonstrating effectiveness
- Industry best practices (NIST CSF, NCSC, Microsoft Security)

**Research Findings:**
- 95% of SMBs value automation (framework provides 55% time reduction)
- 80% prefer phased approach (framework provides 6-month phased deployment)
- 95% require non-disruptive implementation (framework designed for operational continuity)
- 70% willing to participate in pilot study (high acceptance rate)

---

**Security democratization for SMBs—one framework, one organization, one improvement at a time.**

**Author:** Woshada Dasanayake | woshada@gmail.com
**Version:** 1.0.0 | December 2025
**License:** Open Source - Free to use and adapt
