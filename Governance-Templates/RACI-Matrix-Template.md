# RACI Matrix - Security Responsibilities

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 6 months]
**Owner:** IT Director / CISO
**Classification:** Internal

---

## 1. Purpose

This RACI Matrix defines security roles and responsibilities across the organization for implementing and maintaining the SMB Security Framework. RACI ensures clarity on who is Responsible, Accountable, Consulted, and Informed for each security activity.

## 2. RACI Definitions

- **Responsible (R):** Person(s) who perform the work to complete the task
- **Accountable (A):** Person who is ultimately answerable for the task and has decision authority (only ONE per task)
- **Consulted (C):** Person(s) whose input and expertise are sought (two-way communication)
- **Informed (I):** Person(s) who are kept updated on progress or decisions (one-way communication)

## 3. Key Roles

| Role | Abbreviation | Description |
|------|--------------|-------------|
| **Chief Executive Officer** | CEO | Executive sponsor, final authority on security investments |
| **Chief Financial Officer** | CFO | Budget approval, financial risk assessment |
| **IT Director / CISO** | IT Dir | Overall security program ownership and accountability |
| **IT Security Team** | IT Sec | Implement security controls, monitor systems, incident response |
| **IT Operations Team** | IT Ops | Maintain systems, apply patches, backup/recovery |
| **Network Administrator** | NetAdmin | Network infrastructure, firewalls, VPN |
| **System Administrator** | SysAdmin | Servers, Active Directory, Azure AD, M365 admin |
| **Legal Counsel** | Legal | Compliance, contracts, Data Protection Officer (DPO) duties |
| **HR Manager** | HR | Employee training, background checks, policy acknowledgment |
| **Department Heads** | Dept Head | Business unit leaders (Sales, Finance, Marketing, etc.) |
| **Data Owners** | Data Owner | Classify data, approve access, define retention (varies by data type) |
| **All Employees** | All Staff | Follow policies, report incidents, maintain security awareness |
| **External Auditor** | Auditor | Third-party security assessments and compliance audits |
| **External Legal** | Ext Legal | Specialized legal counsel for GDPR, contracts, litigation |

## 4. RACI Matrix: SMB Security Framework Implementation

### Phase 0: Baseline Assessment & Planning (Weeks 1-2)

| Activity | CEO | CFO | IT Dir | IT Sec | IT Ops | Legal | HR | Dept Head | All Staff |
|----------|-----|-----|--------|--------|--------|-------|----|-----------|-----------|
| Complete Baseline Security Questionnaire | I | I | A/R | R | C | C | C | C | - |
| Document current Microsoft Secure Score | I | I | A | R | C | - | - | - | - |
| Review current MFA coverage | I | I | A | R | R | - | - | I | - |
| Audit existing Conditional Access policies | I | I | A | R | - | - | - | - | - |
| Secure executive sponsorship | A | C | R | C | - | C | - | - | - |
| Allocate budget for security program | A | A | R | C | C | I | - | I | - |

### Phase 1: Identity Foundation (Weeks 3-6)

| Activity | CEO | CFO | IT Dir | IT Sec | IT Ops | SysAdmin | Legal | HR | Dept Head | All Staff | Data Owner |
|----------|-----|-----|--------|--------|--------|----------|-------|----|-----------|-----------|-----------|
| **MFA Enablement** | | | | | | | | | | | |
| Deploy MFA for all users | I | I | A | R | R | R | - | I | I | I | - |
| Configure emergency access accounts | I | - | A | R | C | R | - | - | - | - | - |
| User MFA enrollment and training | I | - | A | R | - | R | - | R | C | R (enroll) | - |
| **Conditional Access Policies** | | | | | | | | | | | |
| Design CA policy set | I | I | A | R | C | C | C | - | C | - | - |
| Deploy CA policies in Report-Only mode | I | I | A | R | R | R | - | - | I | - | - |
| Review CA policy impact (7-day analysis) | I | I | A | R | C | C | - | - | C | - | - |
| Enable CA policies (production) | I | I | A | R | R | R | - | - | I | I | - |
| **Password & Account Management** | | | | | | | | | | | |
| Implement Self-Service Password Reset (SSPR) | I | - | A | R | R | R | - | - | - | I | - |
| Configure password protection (banned lists) | I | - | A | R | R | R | - | - | - | - | - |
| Establish privileged account management | I | - | A | R | R | R | C | - | - | - | - |
| Guest account governance policies | I | - | A | R | C | C | C | - | C | - | C |

### Phase 2: Endpoint Protection (Weeks 7-12)

| Activity | CEO | CFO | IT Dir | IT Sec | IT Ops | SysAdmin | NetAdmin | Dept Head | All Staff |
|----------|-----|-----|--------|--------|--------|----------|----------|-----------|-----------|
| **Defender for Endpoint** | | | | | | | | | |
| Deploy Defender for Endpoint | I | I | A | R | R | R | C | I | - |
| Onboard devices to Defender | I | - | A | R | R | R | - | C | C (enroll device) |
| Configure automated investigation & remediation | I | - | A | R | C | C | - | - | - |
| **Device Compliance** | | | | | | | | | |
| Define device compliance policies | I | - | A | R | C | R | - | C | - |
| Enroll devices in Intune MDM | I | - | A | R | R | R | - | C | R (enroll) |
| Configure BitLocker/FileVault encryption | I | - | A | R | R | R | - | - | C |
| **Attack Surface Reduction** | | | | | | | | | |
| Deploy ASR rules in Audit mode | I | - | A | R | R | R | - | I | - |
| Review ASR audit data (14-day period) | I | - | A | R | C | C | - | C | - |
| Enable ASR rules in Block mode | I | - | A | R | R | R | - | I | I |
| **Patch Management** | | | | | | | | | |
| Configure automatic Windows updates | I | - | A | - | R | R | - | - | I |
| Monitor patch compliance | I | - | A | R | R | R | - | - | - |

### Phase 3: Data Governance (Weeks 13-20)

| Activity | CEO | CFO | IT Dir | IT Sec | IT Ops | Legal | HR | Dept Head | Data Owner | All Staff |
|----------|-----|-----|--------|--------|--------|-------|----|-----------|-----------|-----------|
| **Sensitivity Labels** | | | | | | | | | | |
| Design label taxonomy (5-tier) | I | C | A | R | - | C | C | C | C | - |
| Deploy sensitivity labels | I | - | A | R | R | - | C | - | - | - |
| Configure auto-labeling rules | I | - | A | R | R | - | - | - | C | - |
| User training on labeling | I | - | A | R | - | - | C | C | - | R (apply labels) |
| **Data Classification** | | | | | | | | | | |
| Classify data assets | I | C | A | C | - | C | C | C | R | - |
| Define data retention schedules | I | C | A | C | - | A | C | C | R | - |
| Approve access requests for Confidential+ data | I | - | I | C | - | C | - | C | A/R | - |
| Quarterly access reviews | I | - | A | R | - | C | - | C | R | - |
| **DLP Policies** | | | | | | | | | | |
| Design DLP policy set | I | C | A | R | - | C | C | C | C | - |
| Deploy DLP policies in Test mode | I | - | A | R | R | - | C | - | I | I |
| Review DLP incidents (2-3 week testing) | I | - | A | R | - | C | - | C | C | - |
| Enable DLP policies in Enforce mode | I | - | A | R | R | - | C | - | I | I |
| **Retention & Compliance** | | | | | | | | | | |
| Configure retention policies | I | I | A | R | R | - | A | - | C | - |
| Enable unified audit logging | I | - | A | R | R | - | - | - | - | - |

### Phase 4: Security Monitoring (Weeks 21-26)

| Activity | CEO | CFO | IT Dir | IT Sec | IT Ops | SysAdmin | Legal | Dept Head | Auditor |
|----------|-----|-----|--------|--------|--------|----------|-------|-----------|---------|
| **Azure Sentinel Deployment** | | | | | | | | | |
| Deploy Sentinel workspace | I | I | A | R | R | C | - | - | - |
| Configure data connectors (AAD, O365, Defender) | I | - | A | R | R | R | - | - | - |
| Deploy analytics rules (threat detection) | I | - | A | R | C | C | - | - | - |
| Configure automated response playbooks | I | - | A | R | R | C | - | - | - |
| **Monitoring & Alerting** | | | | | | | | | |
| Configure alert rules and thresholds | I | - | A | R | C | C | - | - | - |
| Set up 24/7 monitoring | I | I | A | R | - | - | - | - | - |
| Define incident escalation procedures | I | - | A | R | C | C | C | C | - |
| **Security Operations** | | | | | | | | | |
| Daily security log review | I | - | A | R | - | - | - | - | - |
| Weekly threat intelligence briefing | I | - | A | R | - | - | - | I | - |
| Monthly security metrics report to exec team | I | A | R | R | - | - | I | I | - |
| Quarterly security posture review | A | C | R | R | C | C | C | C | C |
| Annual third-party security audit | A | C | R | C | C | C | A | C | R |

## 5. RACI Matrix: Ongoing Security Operations

### Incident Response

| Activity | CEO | CFO | IT Dir | IT Sec | IT Ops | Legal | HR | Dept Head | All Staff | Ext Legal |
|----------|-----|-----|--------|--------|--------|-------|----|-----------|-----------|-----------|
| Detect security incident | I | I | I | R | R | - | - | - | R (report) | - |
| Initial incident triage and severity assignment | I | I | I | A/R | R | - | - | - | - | - |
| Activate Incident Response Team | I | I | A | R | C | C | C | I | - | - |
| Contain threat (isolate systems, disable accounts) | I | I | I | A/R | R | - | - | - | - | - |
| Forensic investigation | I | I | I | A/R | C | C | - | - | - | C |
| Eradicate threat (remove malware, patch vulns) | I | I | I | A/R | R | - | - | - | - | - |
| Recover systems (restore from backup) | I | I | I | A | R | - | - | C | - | - |
| Internal communication (staff notification) | I | I | A | R | - | - | C | C | I | - |
| External communication (customers, partners) | A | C | C | R | - | A | - | C | - | C |
| GDPR breach notification (72-hour) | I | I | C | R | - | A | - | - | - | A/R |
| Law enforcement notification (if criminal) | A | C | C | R | - | A | - | - | - | C |
| Post-incident review and lessons learned | I | I | A | R | R | C | C | C | - | - |

### User Access Management

| Activity | IT Dir | IT Sec | IT Ops | SysAdmin | HR | Dept Head | Data Owner | All Staff |
|----------|--------|--------|--------|----------|----|-----------|-----------|-----------|
| New user account provisioning | I | - | I | A/R | R (initiate) | C | - | - |
| User role/access approval | I | C | - | C | - | A | A (for their data) | - |
| User access modification (role change) | I | C | - | R | R (initiate) | A | A (for their data) | - |
| User account termination | I | C | I | A/R | R (initiate) | I | I | - |
| Quarterly access reviews | I | A | - | R | - | C | R (for their data) | - |
| Guest/external account requests | I | C | - | R | - | A | A (if accessing data) | - |
| Privileged access requests | I | A/R | - | R | - | C | - | - |

### Policy & Governance

| Activity | CEO | CFO | IT Dir | IT Sec | Legal | HR | Dept Head | All Staff | Ext Legal |
|----------|-----|-----|--------|--------|-------|----|-----------|-----------|-----------|
| Annual policy review and update | A | C | R | R | C | C | C | - | C |
| New policy creation | A | C | R | R | A | C | C | - | C |
| Policy approval | A | C | C | C | C | - | - | - | - |
| Policy communication to staff | I | - | A | R | - | R | C | I | - |
| Policy acknowledgment collection | I | - | A | R | - | R | - | R (acknowledge) | - |
| Policy exception requests | I | C | A | R | C | C | C | - | - |
| Policy exception approval | A | C | R | C | C | - | - | - | - |

### Training & Awareness

| Activity | CEO | IT Dir | IT Sec | HR | Dept Head | All Staff |
|----------|-----|--------|--------|----|-----------|-----------|
| Annual security awareness training | I | A | R | R | C | R (complete) |
| New employee security onboarding | I | A | R | R | I | R (complete) |
| Phishing simulation campaigns | I | A | R | - | I | R (test) |
| Role-based technical training (IT staff) | I | A | R | - | - | R (IT only) |
| Department-specific training (Finance, HR) | I | C | R | R | A | R |
| Training completion tracking | I | A | R | C | C | - |
| Security awareness communications (newsletters) | I | A | R | C | I | I |

### Vendor Management

| Activity | CEO | CFO | IT Dir | IT Sec | IT Ops | Legal | Dept Head |
|----------|-----|-----|--------|--------|--------|-------|-----------|
| Vendor risk assessment (new vendors) | I | C | A | R | - | C | C (business owner) |
| Data Processing Agreement (DPA) negotiation | I | - | C | C | - | A/R | C |
| Vendor security questionnaire review | I | - | A | R | - | C | C |
| Vendor access provisioning | I | - | I | R | R | - | A (business owner) |
| Quarterly vendor access review | I | - | A | R | - | - | R (business owner) |
| Annual vendor security re-assessment | I | - | A | R | - | C | C |
| Vendor off-boarding (data return/deletion) | I | - | A | R | R | C | R (business owner) |

### Compliance & Auditing

| Activity | CEO | CFO | IT Dir | IT Sec | Legal | Dept Head | Data Owner | Auditor |
|----------|-----|-----|--------|--------|-------|-----------|-----------|---------|
| GDPR compliance program oversight | A | C | C | C | R | I | C | - |
| Data Protection Impact Assessments (DPIAs) | I | C | C | R | A | C | C | - |
| Data subject rights requests (access, deletion) | I | C | C | R | A | - | C | - |
| Consent management | I | - | C | C | A/R | - | C | - |
| Annual compliance audit (internal) | I | C | A | R | C | - | - | - |
| Annual third-party security audit | A | A | R | R | C | - | - | R |
| Compliance reporting to board | A | C | R | C | C | - | - | - |

## 6. Escalation Paths

### Security Incident Escalation

```
All Staff → IT Security Team → IT Director → CFO/CEO
           ↓
      Legal (if data breach)
           ↓
   External Legal (GDPR notification)
```

### Policy Exception Escalation

```
Requestor → Department Head → IT Director → CFO/CEO (if high-risk or high-cost)
                             ↓
                        Legal (if compliance impact)
```

### Budget Approval Escalation

```
IT Director → CFO → CEO (if >$50k or strategic investment)
```

## 7. Review and Updates

- **Frequency:** Review this RACI matrix every 6 months or after major organizational changes
- **Triggers:** New roles, departures, restructuring, mergers/acquisitions
- **Approval:** IT Director + HR Manager
- **Distribution:** All roles listed in this matrix

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

## Notes for Use

1. **Customize Roles:** Adjust role names and titles to match your organization's structure (e.g., "CISO" may be "IT Manager" in smaller SMBs)

2. **Scale Appropriately:** In small organizations, one person may hold multiple roles (e.g., IT Director = IT Security + IT Operations). Combine columns as needed.

3. **One Accountable:** Ensure only ONE "A" per activity to avoid confusion about decision authority

4. **Communicate Clearly:** Share this matrix with all stakeholders and include in new employee onboarding

5. **Track Changes:** Document when roles or responsibilities change and communicate to affected parties

6. **Integration:** Reference this RACI in all security policies, procedures, and playbooks for clarity

---

**Note:** This RACI Matrix template is derived from the Strategic Integration Framework for SMB Security. Customize to match your organization's size, structure, and maturity level.
