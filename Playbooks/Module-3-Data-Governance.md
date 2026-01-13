# Module 3: Data Governance Playbook

**Strategic Integration Framework for SMB Security**

---

## Module Overview

**Objective:** Implement comprehensive data protection through classification, loss prevention, and compliance controls.

**Duration:** Weeks 13-20 (Phase 3)
**Effort:** 10-15 hours
**Priority:** **CRITICAL** - Data breaches average £75,000 cost; GDPR fines up to 4% revenue

**Key Deliverables:**
- ✅ 5-tier sensitivity label taxonomy deployed
- ✅ Auto-labeling configured for common data patterns
- ✅ Data Loss Prevention (DLP) policies enforcing protection (5 scenarios)
- ✅ Retention policies supporting compliance requirements
- ✅ Encryption and rights management enabled
- ✅ eDiscovery capabilities configured

**Expected Outcomes:**
- 100% data classified by sensitivity
- Prevent data exfiltration (email, cloud storage, USB)
- GDPR Article 32 compliance demonstration
- Secure Score increase (+12-18 points typical)
- Audit-ready data governance

---

## Prerequisites

### Licensing Requirements

| Feature | Business Premium | E3 | E5 | Required |
|---------|-----------------|----|----|----------|
| Sensitivity Labels | ✅ | ✅ | ✅ | **YES** |
| Auto-labeling (manual) | ✅ | ✅ | ✅ | **YES** |
| Auto-labeling (automatic) | ❌ | ✅ | ✅ | Recommended |
| DLP (Exchange, SharePoint, OneDrive) | ✅ | ✅ | ✅ | **YES** |
| DLP (Teams, Endpoint) | ❌ | ❌ | ✅ | Recommended |
| Retention Policies | ✅ | ✅ | ✅ | **YES** |
| Azure Information Protection | ❌ | ✅ | ✅ | Optional |
| eDiscovery (Basic) | ✅ | ✅ | ✅ | **YES** |
| eDiscovery (Advanced) | ❌ | ❌ | ✅ | Optional |

### Prerequisites
- Module 1 (Identity) and Module 2 (Endpoints) completed
- Compliance Administrator or Information Protection Administrator role
- Data classification policy documented (see `/Governance-Templates/Data-Classification-Policy.docx`)

---

## Implementation Procedures

### Step 1: Design Sensitivity Label Taxonomy (2 hours planning)

#### 1.1 Recommended 5-Tier Schema

**Label 1: Public**
- **Definition:** Information intended for public disclosure
- **Examples:** Marketing materials, public website content, press releases
- **Protection:** None (no encryption)
- **Color Code:** Green

**Label 2: Internal**
- **Definition:** General business information for internal use only
- **Examples:** Internal memos, project plans, meeting notes
- **Protection:** Watermark "Internal Use Only"
- **Color Code:** Blue

**Label 3: Confidential**
- **Definition:** Sensitive business information requiring protection
- **Examples:** Financial reports, contracts, employee data
- **Protection:** Encryption, prevent forwarding externally
- **Color Code:** Yellow

**Label 4: Highly Confidential**
- **Definition:** Critical business information with severe impact if disclosed
- **Examples:** Board minutes, M&A documents, trade secrets
- **Protection:** Encryption, prevent copy/print, expire access 90 days
- **Color Code:** Orange

**Label 5: Restricted**
- **Definition:** Information subject to regulatory/legal restrictions
- **Examples:** Personal data (GDPR), health records (HIPAA), payment card data (PCI-DSS)
- **Protection:** Encryption, audit all access, geographic restrictions
- **Color Code:** Red

#### 1.2 Sub-Labels (Optional - E3/E5)

**Confidential\:**
- Confidential\Legal (attorney-client privilege)
- Confidential\Finance (financial data)
- Confidential\HR (employee records)

**Benefit:** Granular DLP policies per data category

---

### Step 2: Deploy Sensitivity Labels (3-4 hours with automation)

#### 2.1 Automated Deployment

```powershell
# Deploy 5-tier label schema
.\Deploy-SensitivityLabels.ps1 -LabelSchema "SMB-5Tier" -PublishToAllUsers $true

# Parameters:
# -LabelSchema: "SMB-5Tier" (recommended), "SMB-3Tier" (simplified), "Custom" (from CSV)
# -PublishToAllUsers: $true (all users), $false (pilot group first)
# -IncludeSubLabels: $true (Confidential\Legal, Finance, HR)
```

#### 2.2 Manual Configuration (for understanding)

**Create Label:**
1. Navigate to: Microsoft Purview compliance portal → Information protection → Labels
2. Click "Create a label"
3. **Name:** Confidential
4. **Scope:** Files & emails, Meetings
5. **Items:**
   - Encryption: Enabled
   - Content marking: Watermark "CONFIDENTIAL"
   - Auto-labeling: Configure patterns (see Step 3)
6. **Publish:** Create label policy → All users → Publish

**Protection Settings (Confidential Label Example):**
- **Encryption:** Yes
- **Who can access:** All authenticated users in organization
- **User permissions:**
  - ✅ View, Edit
  - ❌ Print, Copy, Forward to external recipients
- **Content expiration:** 90 days (optional, for time-sensitive data)

---

### Step 3: Configure Auto-Labeling (2-3 hours)

#### 3.1 Auto-Labeling Rules

**Objective:** Automatically classify data based on content patterns.

**Rule 1: Credit Card Numbers → Restricted**
- **Pattern:** 16-digit numbers matching Luhn algorithm (credit card format)
- **Confidence:** High (95%+)
- **Action:** Apply "Restricted" label
- **Scope:** Exchange, SharePoint, OneDrive

**Rule 2: National ID Numbers (UK NI, US SSN) → Restricted**
- **Pattern:** Regex matching national ID formats
- **Confidence:** High
- **Action:** Apply "Restricted" label

**Rule 3: "Confidential" Keyword in Header/Footer → Confidential**
- **Pattern:** Document contains "CONFIDENTIAL" in header
- **Confidence:** Medium (70%)
- **Action:** Apply "Confidential" label

**Rule 4: Financial Data (Balance Sheet, P&L) → Confidential\Finance**
- **Pattern:** Excel/CSV containing columns "Revenue", "Expenses", "Profit"
- **Confidence:** Medium
- **Action:** Apply "Confidential\Finance" sub-label

**Rule 5: Email to External Domain → Internal (minimum)**
- **Pattern:** Email recipients include external domains
- **Confidence:** High
- **Action:** Require manual classification (prevent accidental external sharing)

#### 3.2 Testing Auto-Labeling (CRITICAL)

**Week 13-14: Simulation Mode**
- Deploy auto-labeling rules in **Simulation** mode
- Rules recommend labels but don't auto-apply
- Review: Purview compliance portal → Data classification → Auto-labeling → Simulations
- Validate: Correct labels suggested? False positives?

**Week 15: Enforcement**
- Switch to **Auto-apply** mode
- Monitor for 7 days, adjust rules if needed

---

### Step 4: Create Data Loss Prevention (DLP) Policies (4-5 hours)

#### 4.1 5 DLP Policy Templates

**DLP Policy 1: Protect Personal Data (GDPR Compliance)**

**Objective:** Prevent sharing of EU personal data externally.

**Sensitive Info Types Detected:**
- EU National ID numbers (all 27 countries)
- Email addresses + full names (combined)
- Date of birth + address (combined)

**Conditions:**
- Content contains ≥10 instances of sensitive info
- Shared with external recipients (email, OneDrive link)

**Actions:**
- **Block:** External sharing
- **Notify:** User with policy tip "This document contains personal data subject to GDPR. External sharing is prohibited."
- **Incident report:** Email to compliance team

**Scope:** Exchange, SharePoint, OneDrive, Teams

---

**DLP Policy 2: Protect Financial Data**

**Sensitive Info Types:**
- Credit card numbers
- Bank account numbers (UK/US/EU formats)
- SWIFT/IBAN codes

**Conditions:**
- Content contains ≥5 instances
- Shared externally OR copied to USB/cloud storage

**Actions:**
- **Block + Encrypt:** Require encryption if sharing with external auditors (exception)
- **Notify:** User + manager
- **Audit:** Log all attempts

---

**DLP Policy 3: Prevent Source Code Exfiltration (Technology SMBs)**

**Sensitive Info Types (Custom):**
- Files with extensions: .cs, .java, .py, .js, .cpp (source code)
- Content contains: API keys, database connection strings (regex patterns)

**Conditions:**
- Source code file uploaded to personal cloud storage (Dropbox, Google Drive)
- Source code emailed to personal email address

**Actions:**
- **Block**
- **Notify:** User + IT security team
- **Incident report:** High severity

---

**DLP Policy 4: Confidential Label Enforcement**

**Objective:** Enforce protection for labeled content.

**Conditions:**
- Content has sensitivity label: "Confidential" or higher

**Actions:**
- **Block external sharing** unless recipient in approved partner list
- **Remove external links** on SharePoint/OneDrive
- **Prevent download** to unmanaged devices

---

**DLP Policy 5: Teams Message Protection**

**Objective:** Prevent accidental sharing in Teams chat.

**Conditions:**
- Teams message contains: Credit card, SSN, password (keyword detection)

**Actions:**
- **Block message send**
- **Policy tip:** "Your message contains sensitive information. Please use secure sharing methods."

---

#### 4.2 Automated DLP Deployment

```powershell
# Deploy all 5 DLP policies
.\Create-DLPPolicies.ps1 -PolicySet "SMB-Comprehensive" -Mode "TestMode"

# Parameters:
# -PolicySet: "SMB-Comprehensive" (all 5 policies), "GDPR-Only", "Financial-Only"
# -Mode: "TestMode" (policy tips only, no blocking), "Enforce" (block actions)
# -NotifyComplianceTeam: Email address for incident reports
```

#### 4.3 DLP Phased Rollout

**Week 15-16: Test Mode**
- Deploy policies in **Test** mode (policy tips only, no blocking)
- Users see warnings but can override
- Monitor: Purview compliance portal → DLP → Policy matches

**Week 17-18: Pilot Enforcement**
- Enforce for pilot group (IT, management)
- Validate: No business disruption, false positives minimal

**Week 19-20: Full Enforcement**
- Enforce for all users
- Communicate: User training video `/Training-Materials/Videos/04-Classifying-and-Labeling-Documents.mp4`

---

### Step 5: Configure Retention Policies (1-2 hours)

#### 5.1 Retention Policy Recommendations

**Policy 1: Email Retention (GDPR Compliance)**
- **Scope:** All user mailboxes
- **Retention:** 7 years
- **Deletion:** Auto-delete after 7 years
- **Rationale:** Legal/regulatory requirements, GDPR Article 5(e) storage limitation

**Policy 2: SharePoint/OneDrive Document Retention**
- **Scope:** All sites
- **Retention:** 5 years (adjust per industry)
- **Deletion:** Move to recycle bin, permanent delete after 30 days

**Policy 3: Teams Conversations**
- **Scope:** All teams
- **Retention:** 1 year (reduce storage costs)
- **Exception:** Channels tagged "Legal Hold" retain indefinitely

**Policy 4: Restricted Data - Short Retention**
- **Scope:** Items labeled "Restricted"
- **Retention:** 90 days
- **Deletion:** Auto-delete (minimize data exposure)

**Configure:**
```powershell
.\Create-RetentionPolicies.ps1 -EmailRetentionYears 7 -DocumentRetentionYears 5
```

---

### Step 6: Enable Encryption and Rights Management (1 hour)

#### 6.1 Azure Information Protection (AIP)

**Features:**
- Encryption enforced by sensitivity labels
- Track document access (who opened, when, from where)
- Revoke access to previously shared documents

**Configuration:**
1. Purview compliance portal → Information protection → Labels
2. Edit label (e.g., "Confidential") → Encryption → Configure
3. Permissions:
   - Organization users: View, Edit
   - External partners (optional): View only, expires 30 days

#### 6.2 Office Message Encryption (OME)

**Use Case:** Encrypt emails to external recipients (partners, customers).

**Configuration:**
- Exchange admin center → Mail flow rules → Create rule
- Condition: Recipient is outside organization AND subject contains "Secure:"
- Action: Apply Office 365 Message Encryption

**User Experience:**
- User sends email with subject "Secure: Q4 Financial Report"
- External recipient receives encrypted message, authenticates via OTP

---

## Verification and Validation

### Post-Implementation Checklist

- [ ] **Sensitivity Labels:** 5-tier schema published to all users
- [ ] **Label Adoption:** 60%+ documents labeled within 30 days
- [ ] **Auto-Labeling:** 5 rules configured, tested in simulation mode, enforced
- [ ] **DLP Policies:** 5 policies deployed, enforced (post-testing)
- [ ] **DLP Incidents:** <10 false positives per 100 users per month
- [ ] **Retention Policies:** Email, SharePoint, Teams retention configured
- [ ] **Encryption:** Confidential+ labels enforce encryption
- [ ] **User Training:** 80%+ users completed data classification training
- [ ] **Secure Score:** +12-18 point increase
- [ ] **Audit Readiness:** Evidence collection for GDPR/ISO 27001

---

## Troubleshooting Guide

### Issue 1: Users Cannot Open Encrypted Documents

**Symptom:** "You don't have permission to access this document"

**Diagnosis:**
- Check user's Azure AD authentication
- Verify label permissions (who has access?)
- Check if document expired (time-based restrictions)

**Resolution:**
- Add user to label permissions
- Extend expiration date
- Provide view-only access if appropriate

### Issue 2: DLP Policy Blocking Legitimate Business Activity

**Symptom:** "This action violates DLP policy" blocking critical external sharing

**Diagnosis:**
- Review DLP incident report (Purview compliance portal → DLP → Incidents)
- Identify policy, condition, action

**Resolution:**
- **Short-term:** Override (if user has justification)
- **Long-term:** Add exception to DLP policy for approved external domains/partners
- Document business justification

### Issue 3: Auto-Labeling False Positives

**Symptom:** Public documents incorrectly labeled "Confidential"

**Diagnosis:**
- Review auto-labeling simulation results
- Identify pattern causing mismatch

**Resolution:**
- Adjust confidence threshold (95% → 98%)
- Refine regex pattern
- Add exclusion for specific document types

---

## Compliance Mapping

### GDPR Article 32 - Technical Measures

| Requirement | Implementation |
|-------------|----------------|
| Pseudonymization and encryption | Sensitivity labels enforce encryption |
| Confidentiality | DLP prevents unauthorized disclosure |
| Integrity | Retention policies ensure data not altered/deleted prematurely |
| Availability | Backup and retention ensure data accessible when needed |
| Regular testing | DLP simulation mode, monthly policy review |

### ISO 27001 Annex A

- **A.8.2.1 Classification of information:** Sensitivity label taxonomy
- **A.8.2.2 Labelling of information:** Auto-labeling, user labeling
- **A.8.2.3 Handling of assets:** DLP policies enforce handling procedures
- **A.18.1.3 Protection of records:** Retention policies

---

## Next Steps

**Upon Completion of Module 3:**

1. **Document Compliance:** Generate evidence report for GDPR/ISO 27001 audit
2. **User Training:** Deliver data classification awareness training
3. **Schedule Phase 4:** Module 4 - Security Monitoring (Weeks 21-26)

---

**Module 3 Complete - Data Governance Established ✅**

**Proceed to Module 4: Security Monitoring** (Weeks 21-26)
