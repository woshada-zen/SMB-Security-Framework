# Module 4: Security Monitoring Playbook

**Strategic Integration Framework for SMB Security**

---

## Module Overview

**Objective:** Establish comprehensive security monitoring, threat detection, and automated incident response capabilities.

**Duration:** Weeks 21-26 (Phase 4)
**Effort:** 8-12 hours
**Priority:** **HIGH** - Visibility is critical; 50% of SMBs don't track Secure Score, 60% lack SIEM

**Key Deliverables:**
- ✅ Microsoft Defender portal configured for unified threat management
- ✅ Unified audit logging enabled (365-day retention)
- ✅ Azure Sentinel deployed with analytics rules (Optional - E5)
- ✅ 20 pre-built detection rules for common threats
- ✅ Automated response playbooks using Logic Apps
- ✅ Microsoft Secure Score tracking and action plan
- ✅ Monthly security review process established

**Expected Outcomes:**
- Centralized security visibility across M365, Azure, endpoints
- Faster threat detection (Mean Time to Detect <1 hour target)
- Automated incident response (Mean Time to Respond <4 hours)
- Continuous security posture improvement
- Secure Score increase (+8-12 points typical)

---

## Prerequisites

### Licensing Requirements

| Feature | Business Premium | E3 | E5 | Required |
|---------|-----------------|----|----|----------|
| Microsoft Defender Portal | ✅ | ✅ | ✅ | **YES** |
| Unified Audit Log | ✅ | ✅ | ✅ | **YES** |
| Microsoft Secure Score | ✅ | ✅ | ✅ | **YES** |
| Azure Sentinel | ❌ | ❌ | ✅ | Recommended |
| Logic Apps (Automation) | Pay-as-you-go | Pay-as-you-go | ✅ | Optional |
| Advanced Hunting (KQL) | ❌ | ❌ | ✅ | Optional |

### Prerequisites
- Modules 1-3 completed (Identity, Endpoints, Data Governance)
- Security Administrator or Global Administrator role
- Azure subscription (for Sentinel deployment)
- PowerShell 7+ with Az PowerShell module

---

## Implementation Procedures

### Step 1: Configure Microsoft Defender Portal (2-3 hours)

#### 1.1 Portal Overview

**Microsoft 365 Defender Portal** = Unified security dashboard integrating:
- Microsoft Defender for Endpoint (malware, device threats)
- Microsoft Defender for Office 365 (email, collaboration threats)
- Microsoft Defender for Identity (AD threats)
- Microsoft Defender for Cloud Apps (cloud app threats)

**Access:** https://security.microsoft.com

#### 1.2 Essential Configurations

**1.2.1 Email Notifications**
- Configure: Settings → Microsoft 365 Defender → Email notifications
- **Alert recipients:** IT security team email address
- **Alerts to send:**
  - ✅ High severity incidents
  - ✅ Compromised users detected
  - ✅ Malware campaigns detected
  - ✅ Automated investigation completed

**1.2.2 Incident Assignment Rules**
- Configure: Settings → Microsoft 365 Defender → Incident assignment
- **Rule:** Assign incidents to IT security team
- **Criteria:** All high-severity incidents auto-assigned

**1.2.3 Automated Investigation and Response (AIR)**
- Configure: Settings → Endpoints → Advanced features → Automated investigation
- **Enable:** Auto-remediation for high-confidence threats
- **Approval level:**
  - Fully automated: Malware quarantine, file deletion
  - Require approval: User account disable, network isolation

**1.2.4 Device Inventory Integration**
- Navigate to: Assets → Devices
- Verify: All onboarded devices visible (from Module 2)
- **Expected:** 95%+ device coverage

---

### Step 2: Enable and Configure Unified Audit Logging (1 hour)

#### 2.1 Enable Audit Log Collection

**What's Captured:**
- User activity: Sign-ins, file access, email sends
- Admin activity: Policy changes, user creation, role assignments
- Security events: MFA bypass attempts, Conditional Access failures

**Retention:**
- **E3/E5:** 90 days default, upgrade to 365 days (recommended)
- **E5 Advanced Audit:** 10 years retention

**Enable Auditing:**

```powershell
# Enable organization-wide audit logging
Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true

# Set 365-day retention (E5 only)
Set-OrganizationConfig -AuditRetentionDuration 365

# Enable mailbox auditing for all users
Get-Mailbox -ResultSize Unlimited | Set-Mailbox -AuditEnabled $true
```

#### 2.2 Verification

**Test Audit Logging:**
1. Navigate to: Purview compliance portal → Audit
2. Search criteria:
   - Activities: User signed in
   - Date range: Last 7 days
3. Run search, verify results appear

**Expected:** Sign-in events for all users visible

---

### Step 3: Deploy Azure Sentinel (6-8 hours with ARM template)

**Note:** Azure Sentinel is **optional** but **highly recommended** for E5 customers. Provides advanced SIEM/SOAR capabilities.

#### 3.1 Sentinel Overview

**What is Sentinel:**
- Cloud-native SIEM (Security Information and Event Management)
- Centralized log collection from M365, Azure, on-prem, third-party sources
- AI-driven threat detection (machine learning analytics)
- Automated response via playbooks

**Cost Consideration:**
- Pay-per-GB ingested (~£1.50-2.00 per GB)
- Typical SMB (100 users): 5-10 GB/day = £225-600/month
- **Included with E5 Security:** 5 MB/user/day free

#### 3.2 Automated Deployment

```powershell
# One-click Sentinel deployment
.\Deploy-Sentinel.json -ResourceGroupName "rg-security" -WorkspaceName "sentinel-smb" -Region "UK South"

# Parameters:
# -ResourceGroupName: Azure resource group for Sentinel workspace
# -WorkspaceName: Log Analytics workspace name
# -Region: Azure region (UK South, West Europe, East US)
# -DataRetentionDays: 90 (default), 365 (recommended for E5)
```

**ARM Template Includes:**
- Log Analytics workspace
- Sentinel solution
- Data connectors pre-configured (Office 365, Azure AD, Defender)
- 20 analytics rules (see Step 4)

#### 3.3 Manual Deployment Steps

**Step 3.3.1: Create Log Analytics Workspace**
1. Azure Portal → Create a resource → Log Analytics Workspace
2. **Resource group:** Create new "rg-security"
3. **Name:** sentinel-smb
4. **Region:** UK South (or nearest region)
5. Create

**Step 3.3.2: Enable Sentinel**
1. Azure Portal → Microsoft Sentinel → Create
2. Select workspace: sentinel-smb
3. Add Microsoft Sentinel

**Step 3.3.3: Configure Data Connectors**
1. Sentinel → Configuration → Data connectors
2. Connect:
   - ✅ **Office 365** (Exchange, SharePoint, Teams logs)
   - ✅ **Azure Active Directory** (Sign-in logs, audit logs)
   - ✅ **Microsoft Defender for Endpoint** (device alerts)
   - ✅ **Microsoft Defender for Office 365** (email threats)
   - ✅ **Azure Activity** (Azure subscription changes)

**Expected Time:** Data begins flowing within 15 minutes

---

### Step 4: Configure Analytics Rules (2-3 hours)

#### 4.1 Pre-Built Analytics Rules (20 Rules Recommended)

**Rule Category 1: Identity Threats (6 rules)**

1. **Multiple Failed Sign-In Attempts**
   - Trigger: User >10 failed sign-ins within 1 hour
   - Severity: Medium
   - Action: Alert security team, auto-disable user account (pending review)

2. **Impossible Travel Detection**
   - Trigger: User signs in from London, then New York 2 hours later
   - Severity: High
   - Action: Alert, require MFA re-authentication

3. **Sign-In from Anonymous IP/Tor**
   - Trigger: User signs in from Tor exit node or anonymous VPN
   - Severity: High
   - Action: Block sign-in, alert security team

4. **Privileged Account Sign-In from Unknown Location**
   - Trigger: Global Admin signs in from new country
   - Severity: Critical
   - Action: Alert, require approval to proceed

5. **Password Spray Attack Detected**
   - Trigger: Multiple users (>20) experience failed sign-in from same IP within 10 minutes
   - Severity: High
   - Action: Block IP, alert security team

6. **Dormant Account Activated**
   - Trigger: Account inactive for 90+ days suddenly signs in
   - Severity: Medium
   - Action: Alert, verify with user

---

**Rule Category 2: Endpoint Threats (5 rules)**

7. **Ransomware Behavior Detected**
   - Trigger: Device rapidly encrypts >100 files within 5 minutes
   - Severity: Critical
   - Action: Isolate device, alert security team

8. **Malware Execution Detected**
   - Trigger: Defender quarantines malware
   - Severity: High
   - Action: Alert, verify no lateral movement

9. **Suspicious PowerShell Execution**
   - Trigger: PowerShell runs with obfuscation, downloads executable
   - Severity: High
   - Action: Alert, collect forensics

10. **Credential Dumping Detected**
   - Trigger: LSASS memory access (Mimikatz-like behavior)
   - Severity: Critical
   - Action: Isolate device, force password reset for all users on device

11. **External Device USB Usage**
   - Trigger: USB device connected, files copied (ASR Rule 8 triggered)
   - Severity: Low
   - Action: Log, alert if >1 GB copied

---

**Rule Category 3: Data Exfiltration (4 rules)**

12. **Mass Email Send to External Recipients**
   - Trigger: User sends >50 emails to external domains within 1 hour
   - Severity: High
   - Action: Block mailbox send, alert security team (possible compromise)

13. **Large OneDrive Download**
   - Trigger: User downloads >10 GB from OneDrive in single session
   - Severity: Medium
   - Action: Alert, verify legitimate business need

14. **DLP Policy Violation - High Volume**
   - Trigger: User triggers >10 DLP policy violations within 24 hours
   - Severity: High
   - Action: Alert, review user activity for insider threat

15. **Sensitivity Label Downgrade**
   - Trigger: User changes document from "Confidential" to "Public"
   - Severity: Medium
   - Action: Alert, audit trail review

---

**Rule Category 4: Admin Activity Monitoring (3 rules)**

16. **Global Admin Role Assignment**
   - Trigger: User assigned Global Administrator role
   - Severity: High
   - Action: Alert, verify authorized change

17. **Conditional Access Policy Disabled**
   - Trigger: Admin disables Conditional Access policy
   - Severity: Critical
   - Action: Alert, revert change if unauthorized

18. **MFA Disabled for User**
   - Trigger: Admin disables MFA for user account
   - Severity: High
   - Action: Alert, verify business justification

---

**Rule Category 5: Compliance Monitoring (2 rules)**

19. **Guest User Access Review Overdue**
   - Trigger: Guest user access not reviewed for 90+ days
   - Severity: Low
   - Action: Alert compliance team, trigger access review

20. **Audit Logging Disabled**
   - Trigger: Admin disables unified audit logging
   - Severity: Critical
   - Action: Alert, auto-re-enable logging

---

#### 4.2 Deploying Analytics Rules

**Automated Deployment:**

```powershell
# Deploy all 20 analytics rules to Sentinel
.\Deploy-SentinelAnalyticsRules.ps1 -WorkspaceName "sentinel-smb" -RuleSet "SMB-Comprehensive"

# Parameters:
# -RuleSet: "SMB-Comprehensive" (all 20 rules), "Essential" (top 10 rules only)
# -Severity: "High,Critical" (filter by severity)
```

**Manual Configuration (Example - Rule 1):**
1. Sentinel → Analytics → Create → Scheduled query rule
2. **Name:** Multiple Failed Sign-In Attempts
3. **Query (KQL):**
```kql
SigninLogs
| where ResultType != 0  // Failed sign-in
| summarize FailedAttempts = count() by UserPrincipalName, IPAddress, bin(TimeGenerated, 1h)
| where FailedAttempts > 10
```
4. **Schedule:** Run every 1 hour
5. **Alert threshold:** >0 results
6. **Severity:** Medium
7. **Create**

---

### Step 5: Create Automated Response Playbooks (2-3 hours)

#### 5.1 Playbook Overview

**Playbooks** = Automated workflows using Azure Logic Apps responding to incidents.

**Example Use Cases:**
- Auto-disable compromised user account
- Isolate infected device from network
- Send email notification to security team
- Create ServiceNow/Jira ticket
- Block malicious IP in firewall

#### 5.2 Pre-Built Playbooks

**Playbook 1: Disable Compromised User Account**

**Trigger:** Sentinel alert "Impossible Travel" or "Sign-in from Tor"
**Actions:**
1. Disable user account in Azure AD
2. Revoke all active sessions
3. Force password reset on next sign-in
4. Send email to security team with alert details
5. Create incident ticket in Sentinel

**Deploy:**
```powershell
.\Deploy-PlaybookDisableUser.json -ResourceGroup "rg-security" -PlaybookName "playbook-disable-compromised-user"
```

---

**Playbook 2: Isolate Infected Device**

**Trigger:** Defender alert "Ransomware detected" or "Malware execution"
**Actions:**
1. Isolate device from network (Defender API)
2. Collect full memory dump for forensics
3. Alert security team
4. Create high-priority incident

---

**Playbook 3: Block Malicious IP**

**Trigger:** Sentinel alert "Password spray attack from IP"
**Actions:**
1. Add IP to Conditional Access named location "Blocked IPs"
2. Block all sign-ins from IP
3. Alert security team
4. Create incident report

---

### Step 6: Configure Microsoft Secure Score Monitoring (1 hour)

#### 6.1 Secure Score Overview

**What is Secure Score:**
- 0-100% score representing security posture
- Higher score = better security configuration
- Provides actionable recommendations to improve

**Access:** Microsoft 365 Defender portal → Secure Score

#### 6.2 Establish Baseline

**Week 21: Initial Measurement**
- Record current Secure Score (expected: 65-75% after Modules 1-3)
- Document score breakdown by category:
  - Identity: X points
  - Device: X points
  - Data: X points
  - Apps: X points

#### 6.3 Create Action Plan

**Prioritization:**
1. **High Impact, Low Effort:** Implement first (quick wins)
2. **High Impact, High Effort:** Schedule for next quarter
3. **Low Impact:** Defer

**Example Action Items:**
- Enable Security Defaults (+10 points, 15 minutes) → DONE in Module 1
- Configure password protection (+5 points, 30 minutes) → DONE in Module 1
- Enable Microsoft Defender for Office 365 (+12 points, 1 hour)
- Configure ASR rules (+8 points, 2 hours) → DONE in Module 2

#### 6.4 Monthly Review Process

**Establish Cadence:**
- **When:** First Monday of each month
- **Who:** IT security team + executive sponsor
- **Agenda:**
  1. Review current Secure Score (trend: up/down?)
  2. Celebrate improvements (+5 points this month!)
  3. Select 2-3 actions to implement this month
  4. Assign owners, set deadlines

**Template:** `/Governance-Templates/Monthly-Security-Review-Meeting-Agenda.docx`

---

## Verification and Validation

### Post-Implementation Checklist

- [ ] **Defender Portal:** Configured, email alerts enabled
- [ ] **Audit Logging:** Enabled, 365-day retention (E5), collecting events
- [ ] **Sentinel Deployed:** Workspace created, data connectors active (E5)
- [ ] **Analytics Rules:** 20 rules deployed, generating alerts
- [ ] **Playbooks:** 3 automated response playbooks deployed
- [ ] **Secure Score:** Baseline documented, monthly review scheduled
- [ ] **Incident Response Plan:** Tested (see `/Governance-Templates/Incident-Response-Procedures.docx`)
- [ ] **MTTD:** <1 hour for critical incidents (test with simulation)
- [ ] **MTTR:** <4 hours for containment (test with tabletop exercise)
- [ ] **Visibility:** 100% of M365 services monitored

---

## Troubleshooting Guide

### Issue 1: Sentinel Not Collecting Data

**Symptom:** Data connectors show "Connected" but no logs in Sentinel

**Diagnosis:**
- Check data connector status: Sentinel → Configuration → Data connectors
- Verify Azure AD permissions: Sentinel service principal has Reader role

**Resolution:**
- Re-authenticate data connector
- Grant additional permissions if required
- Wait 15-30 minutes for initial data flow

### Issue 2: Analytics Rule Generating False Positives

**Symptom:** Too many low-value alerts, alert fatigue

**Diagnosis:**
- Review alert history: Which rule generating most alerts?
- Analyze false positive patterns

**Resolution:**
- Adjust rule threshold (e.g., >10 failed attempts → >20)
- Add exclusion for known scenarios (VPN IP ranges for "Unknown location")
- Disable overly sensitive rules

### Issue 3: Playbook Failing to Execute

**Symptom:** Playbook triggered but action not taken (user not disabled)

**Diagnosis:**
- Check playbook run history: Logic Apps → Runs
- Look for failed steps

**Resolution:**
- Verify Logic App has sufficient Azure AD permissions (Contributor role)
- Check API connection authentication
- Re-authorize connections

---

## Compliance Mapping

### NIST Cybersecurity Framework

| NIST Function | Implementation |
|---------------|----------------|
| **Detect (DE.AE)** | Sentinel analytics rules detect anomalies |
| **Detect (DE.CM)** | Unified audit logging provides continuous monitoring |
| **Respond (RS.AN)** | Defender portal incident investigation |
| **Respond (RS.MI)** | Automated playbooks mitigate threats |

### ISO 27001 Annex A

- **A.12.4.1 Event logging:** Unified audit log
- **A.12.4.2 Protection of log information:** Immutable logs, 365-day retention
- **A.12.4.3 Administrator and operator logs:** Privileged activity monitoring
- **A.16.1.2 Reporting information security events:** Automated alerting

---

## Next Steps

**Upon Completion of Module 4:**

1. **Framework Complete:** All 4 phases deployed (Weeks 1-26)
2. **Conduct Post-Implementation Assessment:**
   - Complete: `/Assessment-Tools/Maturity-Scorecard.xlsx`
   - Compare to baseline (Week 1)
   - Document improvements
3. **Celebrate Success:**
   - Executive presentation: Security posture improvements
   - Metrics: Secure Score increase, incident response times, coverage
4. **Transition to Continuous Improvement:**
   - Monthly Secure Score reviews
   - Quarterly Conditional Access policy reviews
   - Annual framework update (new Microsoft features)

---

## Continuous Improvement

### Monthly Security Operations Tasks

- [ ] Review Secure Score, implement 2-3 improvements
- [ ] Review Sentinel analytics rule effectiveness
- [ ] Audit guest user access (quarterly)
- [ ] Test incident response playbooks (tabletop exercise)
- [ ] Review DLP policy violations, adjust as needed
- [ ] Patch compliance check (95%+ target)
- [ ] Phishing simulation campaign (quarterly)

---

**Module 4 Complete - Full Framework Deployed ✅**

**Congratulations! Your organization has achieved comprehensive Microsoft 365/Azure security integration.**

**Estimated Security Posture Improvement:**
- Secure Score: 65% → 80%+ (15-25 point increase)
- MFA Coverage: 70% → 95%+
- Endpoint Protection: 70% → 95%+
- Data Classification: 0% → 80%+
- SIEM Visibility: 0% → 100%

**Total Implementation:** 36-55 hours over 6 months
**Cost Savings:** £10,000-25,000 (external consultant avoided)
**ROI:** 400-1,100%

---

**Security democratization achieved—one framework, one organization, one step at a time.**
