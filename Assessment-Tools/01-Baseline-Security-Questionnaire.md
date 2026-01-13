# Baseline Security Questionnaire

**Purpose:** Assess current cybersecurity posture before implementing SMB Security Framework
**Target Audience:** IT Director/Manager, CISO, Security Team
**Duration:** 45-60 minutes to complete
**Format:** Checklist with scoring (export to Excel/spreadsheet recommended)

---

## Instructions

**How to Use:**
1. Answer each question honestly based on current state (not aspirational)
2. Mark: ✓ (Yes/Implemented), ✗ (No/Not Implemented), ⚠ (Partially Implemented), N/A (Not Applicable)
3. Calculate scores for each section
4. Review gap analysis and prioritize remediation
5. Re-assess after implementing framework (track improvement)

**Scoring:**
- ✓ Yes/Implemented = 1 point
- ⚠ Partially Implemented = 0.5 points
- ✗ No/Not Implemented = 0 points
- N/A = Excluded from scoring

**Maturity Levels:**
- 0-25%: Critical (Immediate action required)
- 26-50%: Developing (Significant gaps)
- 51-75%: Managed (Good foundation, needs improvement)
- 76-100%: Optimized (Industry-leading)

---

## Section 1: Identity & Access Management (20 questions)

### Multi-Factor Authentication (MFA)

| # | Question | Response | Score |
|---|----------|----------|-------|
| 1.1 | Is MFA enabled for all user accounts? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.2 | Is MFA enabled for all administrative/privileged accounts? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.3 | Is MFA required for remote access (VPN, Remote Desktop)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.4 | Is MFA enforced via Conditional Access policies (not optional)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.5 | Are phishing-resistant MFA methods used (FIDO2, Authenticator app)? | ☐ Yes ☐ Partial ☐ No | ___ |

### Password & Authentication

| # | Question | Response | Score |
|---|----------|----------|-------|
| 1.6 | Is there a documented password policy (length, complexity)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.7 | Is the password minimum length at least 12 characters? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.8 | Are common/weak passwords blocked (Microsoft banned list)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.9 | Is Self-Service Password Reset (SSPR) enabled? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.10 | Are emergency/break-glass accounts documented and tested? | ☐ Yes ☐ Partial ☐ No | ___ |

### Access Control

| # | Question | Response | Score |
|---|----------|----------|-------|
| 1.11 | Is access granted based on least privilege principle? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.12 | Are user access rights reviewed quarterly? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.13 | Is privileged access separated from standard user accounts? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.14 | Are Conditional Access policies configured (location, device, risk)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.15 | Is guest/external user access reviewed and time-limited? | ☐ Yes ☐ Partial ☐ No | ___ |

### Account Management

| # | Question | Response | Score |
|---|----------|----------|-------|
| 1.16 | Is account provisioning automated (Azure AD, SCIM)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.17 | Are accounts disabled immediately upon termination? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.18 | Are dormant accounts (90+ days inactive) automatically disabled? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.19 | Are service accounts documented with owners assigned? | ☐ Yes ☐ Partial ☐ No | ___ |
| 1.20 | Are shared accounts prohibited (each user has unique account)? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 1 Score:** ___/20 = ___%

---

## Section 2: Endpoint Protection (15 questions)

### Device Management

| # | Question | Response | Score |
|---|----------|----------|-------|
| 2.1 | Are all devices enrolled in MDM (Intune, other)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.2 | Are device compliance policies enforced (OS version, encryption)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.3 | Is full disk encryption enabled on all devices (BitLocker, FileVault)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.4 | Are non-compliant devices blocked from accessing corporate data? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.5 | Is remote wipe capability enabled for lost/stolen devices? | ☐ Yes ☐ Partial ☐ No | ___ |

### Endpoint Security

| # | Question | Response | Score |
|---|----------|----------|-------|
| 2.6 | Is antivirus/anti-malware deployed on all endpoints? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.7 | Is Microsoft Defender for Endpoint (or equivalent) deployed? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.8 | Are Attack Surface Reduction (ASR) rules enabled? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.9 | Is automated investigation & remediation configured? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.10 | Are endpoint security events monitored centrally (SIEM)? | ☐ Yes ☐ Partial ☐ No | ___ |

### Patch Management

| # | Question | Response | Score |
|---|----------|----------|-------|
| 2.11 | Are security updates deployed within 7 days of release? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.12 | Is automatic update enforcement configured (Windows Update, WSUS)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.13 | Is patch compliance monitored and reported monthly? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.14 | Are third-party applications patched regularly (Java, Adobe, browsers)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 2.15 | Is there a process for emergency patching (zero-day vulnerabilities)? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 2 Score:** ___/15 = ___%

---

## Section 3: Data Governance & Protection (18 questions)

### Data Classification

| # | Question | Response | Score |
|---|----------|----------|-------|
| 3.1 | Is there a documented data classification policy? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.2 | Are sensitivity labels deployed (Microsoft Information Protection)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.3 | Are users trained on applying sensitivity labels? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.4 | Is auto-labeling configured for sensitive data types? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.5 | Are label downgrade actions monitored and audited? | ☐ Yes ☐ Partial ☐ No | ___ |

### Data Loss Prevention (DLP)

| # | Question | Response | Score |
|---|----------|----------|-------|
| 3.6 | Are DLP policies deployed (email, OneDrive, SharePoint, Teams)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.7 | Are DLP policies configured for GDPR personal data? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.8 | Are DLP policies configured for financial data (PCI, bank info)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.9 | Are DLP incidents reviewed weekly? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.10 | Are DLP policies enforced (not just test/audit mode)? | ☐ Yes ☐ Partial ☐ No | ___ |

### Data Storage & Sharing

| # | Question | Response | Score |
|---|----------|----------|-------|
| 3.11 | Is data stored in approved cloud services (OneDrive, SharePoint)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.12 | Is external sharing controlled (default: disabled or restricted)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.13 | Are shared links time-limited and password-protected? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.14 | Is data encrypted at rest and in transit? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.15 | Are retention policies configured (email, files, Teams)? | ☐ Yes ☐ Partial ☐ No | ___ |

### GDPR Compliance

| # | Question | Response | Score |
|---|----------|----------|-------|
| 3.16 | Is personal data processing documented (Article 30 record)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.17 | Are Data Processing Agreements (DPAs) signed with all processors? | ☐ Yes ☐ Partial ☐ No | ___ |
| 3.18 | Is there a process for data subject rights requests (access, deletion)? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 3 Score:** ___/18 = ___%

---

## Section 4: Security Monitoring & Incident Response (17 questions)

### Logging & Monitoring

| # | Question | Response | Score |
|---|----------|----------|-------|
| 4.1 | Is unified audit logging enabled (Microsoft 365)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.2 | Are logs retained for at least 90 days (365 days recommended)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.3 | Is a SIEM deployed (Azure Sentinel, Splunk, other)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.4 | Are security events monitored 24/7 (or business hours minimum)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.5 | Are analytics rules configured for threat detection? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.6 | Are alerts prioritized by severity (P1-P4)? | ☐ Yes ☐ Partial ☐ No | ___ |

### Threat Detection

| # | Question | Response | Score |
|---|----------|----------|-------|
| 4.7 | Is Microsoft Defender portal monitored daily? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.8 | Are impossible travel/anomalous login alerts enabled? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.9 | Are failed sign-in attempts monitored (brute force detection)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.10 | Is Cloud App Security monitoring shadow IT usage? | ☐ Yes ☐ Partial ☐ No | ___ |

### Incident Response

| # | Question | Response | Score |
|---|----------|----------|-------|
| 4.11 | Is there a documented Incident Response Plan? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.12 | Is an Incident Response Team (IRT) identified with contact info? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.13 | Is the IR plan tested annually (tabletop exercise)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.14 | Is there a 24/7 incident reporting mechanism? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.15 | Are incident response playbooks documented (ransomware, phishing, breach)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.16 | Are security incidents tracked and reviewed post-incident? | ☐ Yes ☐ Partial ☐ No | ___ |
| 4.17 | Is GDPR 72-hour breach notification process documented? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 4 Score:** ___/17 = ___%

---

## Section 5: Email & Communication Security (12 questions)

### Email Protection

| # | Question | Response | Score |
|---|----------|----------|-------|
| 5.1 | Is email filtering deployed (Exchange Online Protection, other)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.2 | Are anti-phishing policies configured? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.3 | Are anti-spam and anti-malware policies configured? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.4 | Is Safe Links protection enabled (URL rewriting)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.5 | Is Safe Attachments protection enabled (sandbox detonation)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.6 | Is external email tagged with warning banners? | ☐ Yes ☐ Partial ☐ No | ___ |

### Email Authentication

| # | Question | Response | Score |
|---|----------|----------|-------|
| 5.7 | Is SPF (Sender Policy Framework) configured for your domain? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.8 | Is DKIM (DomainKeys Identified Mail) enabled? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.9 | Is DMARC (Domain-based Message Authentication) configured? | ☐ Yes ☐ Partial ☐ No | ___ |

### Email Policies

| # | Question | Response | Score |
|---|----------|----------|-------|
| 5.10 | Is external email forwarding blocked or restricted? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.11 | Are large attachments blocked (>10MB) with file sharing encouraged? | ☐ Yes ☐ Partial ☐ No | ___ |
| 5.12 | Is email encryption enabled for sensitive communications? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 5 Score:** ___/12 = ___%

---

## Section 6: Network & Infrastructure Security (13 questions)

### Network Security

| # | Question | Response | Score |
|---|----------|----------|-------|
| 6.1 | Is a firewall deployed and configured (default-deny)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.2 | Is network segmentation implemented (corporate, guest, IoT)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.3 | Is VPN or zero-trust network access configured for remote users? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.4 | Are Network Security Groups (NSGs) configured in Azure? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.5 | Is intrusion detection/prevention (IDS/IPS) deployed? | ☐ Yes ☐ Partial ☐ No | ___ |

### Wireless Security

| # | Question | Response | Score |
|---|----------|----------|-------|
| 6.6 | Is corporate Wi-Fi encrypted with WPA2/WPA3? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.7 | Is guest Wi-Fi separated from corporate network? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.8 | Are default Wi-Fi router credentials changed? | ☐ Yes ☐ Partial ☐ No | ___ |

### Cloud Infrastructure

| # | Question | Response | Score |
|---|----------|----------|-------|
| 6.9 | Is Azure Security Center/Defender for Cloud enabled? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.10 | Are cloud resources tagged and governed (policies, budgets)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.11 | Is Just-In-Time (JIT) VM access enabled for management ports? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.12 | Are cloud backups encrypted and tested quarterly? | ☐ Yes ☐ Partial ☐ No | ___ |
| 6.13 | Is multi-region redundancy configured for critical workloads? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 6 Score:** ___/13 = ___%

---

## Section 7: Backup & Business Continuity (10 questions)

### Backup

| # | Question | Response | Score |
|---|----------|----------|-------|
| 7.1 | Are backups performed automatically (daily minimum)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.2 | Are backups stored off-site or in separate Azure region? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.3 | Are backups encrypted at rest? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.4 | Are backup restores tested quarterly? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.5 | Are backups immutable or air-gapped (ransomware protection)? | ☐ Yes ☐ Partial ☐ No | ___ |

### Business Continuity

| # | Question | Response | Score |
|---|----------|----------|-------|
| 7.6 | Is there a documented Business Continuity Plan (BCP)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.7 | Are Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO) defined? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.8 | Is the BCP tested annually? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.9 | Are critical business functions identified and prioritized? | ☐ Yes ☐ Partial ☐ No | ___ |
| 7.10 | Is cyber insurance coverage maintained? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 7 Score:** ___/10 = ___%

---

## Section 8: Security Awareness & Training (10 questions)

### Training Program

| # | Question | Response | Score |
|---|----------|----------|-------|
| 8.1 | Is annual security awareness training mandatory for all employees? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.2 | Is security training provided to new hires within 14 days? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.3 | Are quarterly phishing simulations conducted? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.4 | Is training completion tracked and reported? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.5 | Is role-based training provided (IT, finance, HR, managers)? | ☐ Yes ☐ Partial ☐ No | ___ |

### Security Culture

| # | Question | Response | Score |
|---|----------|----------|-------|
| 8.6 | Is there a clear process for reporting security incidents? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.7 | Are employees encouraged to report suspicious activity without fear? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.8 | Is executive management visibly supportive of security initiatives? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.9 | Are security policies accessible and easy to understand? | ☐ Yes ☐ Partial ☐ No | ___ |
| 8.10 | Are security successes celebrated (phishing reports, compliance)? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 8 Score:** ___/10 = ___%

---

## Section 9: Governance & Compliance (12 questions)

### Policies & Procedures

| # | Question | Response | Score |
|---|----------|----------|-------|
| 9.1 | Is there a Master Information Security Policy? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.2 | Is there an Acceptable Use Policy (AUP)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.3 | Are security policies reviewed annually? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.4 | Do employees acknowledge policies upon hire and updates? | ☐ Yes ☐ Partial ☐ No | ___ |

### Risk Management

| # | Question | Response | Score |
|---|----------|----------|-------|
| 9.5 | Is a risk register maintained and reviewed quarterly? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.6 | Are third-party vendor security assessments conducted? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.7 | Are Data Processing Agreements (DPAs) signed with vendors? | ☐ Yes ☐ Partial ☐ No | ___ |

### Compliance

| # | Question | Response | Score |
|---|----------|----------|-------|
| 9.8 | Is GDPR compliance documented and auditable? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.9 | Are annual compliance audits conducted (internal or external)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.10 | Is a Data Protection Officer (DPO) appointed or designated? | ☐ Yes ☐ Partial ☐ No | ___ |

### Reporting

| # | Question | Response | Score |
|---|----------|----------|-------|
| 9.11 | Are security metrics reported to executive management monthly? | ☐ Yes ☐ Partial ☐ No | ___ |
| 9.12 | Is the Board of Directors briefed on cybersecurity risks quarterly? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 9 Score:** ___/12 = ___%

---

## Section 10: Physical & Operational Security (8 questions)

### Physical Security

| # | Question | Response | Score |
|---|----------|----------|-------|
| 10.1 | Is office access controlled (badge readers, locks)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 10.2 | Is visitor access logged and escorted? | ☐ Yes ☐ Partial ☐ No | ___ |
| 10.3 | Is a clean desk policy enforced for sensitive materials? | ☐ Yes ☐ Partial ☐ No | ___ |
| 10.4 | Are confidential documents shredded (cross-cut shredder available)? | ☐ Yes ☐ Partial ☐ No | ___ |

### Operational Security

| # | Question | Response | Score |
|---|----------|----------|-------|
| 10.5 | Are background checks conducted for employees with sensitive access? | ☐ Yes ☐ Partial ☐ No | ___ |
| 10.6 | Is equipment disposal process secure (data sanitization)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 10.7 | Are security cameras deployed in sensitive areas (server rooms)? | ☐ Yes ☐ Partial ☐ No | ___ |
| 10.8 | Is there an insider threat awareness program? | ☐ Yes ☐ Partial ☐ No | ___ |

**Section 10 Score:** ___/8 = ___%

---

## Overall Results

### Score Summary

| Section | Score | Percentage | Maturity Level |
|---------|-------|------------|----------------|
| 1. Identity & Access Management | ___/20 | ___% | _______________ |
| 2. Endpoint Protection | ___/15 | ___% | _______________ |
| 3. Data Governance & Protection | ___/18 | ___% | _______________ |
| 4. Security Monitoring & IR | ___/17 | ___% | _______________ |
| 5. Email & Communication | ___/12 | ___% | _______________ |
| 6. Network & Infrastructure | ___/13 | ___% | _______________ |
| 7. Backup & Business Continuity | ___/10 | ___% | _______________ |
| 8. Security Awareness & Training | ___/10 | ___% | _______________ |
| 9. Governance & Compliance | ___/12 | ___% | _______________ |
| 10. Physical & Operational | ___/8 | ___% | _______________ |
| **TOTAL** | **___/135** | **___%** | **_______________** |

### Maturity Level Interpretation

**0-25% (Critical):**
- Significant security gaps exposing organization to high risk
- Immediate action required across multiple areas
- Recommend engaging external security consultant
- Priority: Implement Phase 1 (Identity Foundation) immediately

**26-50% (Developing):**
- Basic security controls in place but inconsistently applied
- Substantial improvement needed
- Recommend implementing full SMB Security Framework (all 4 phases)
- Timeline: 6 months to reach Managed level

**51-75% (Managed):**
- Good security foundation with room for improvement
- Focus on gaps identified in assessment
- Recommend completing missing framework components
- Timeline: 3-4 months to reach Optimized level

**76-100% (Optimized):**
- Industry-leading security posture for SMB
- Continue monitoring and continuous improvement
- Focus on emerging threats and advanced capabilities
- Annual re-assessment to maintain posture

---

## Gap Analysis & Remediation Plan

### Critical Gaps (Score 0 in high-priority areas)

**Priority 1 - Address Immediately:**
| Section | Question # | Gap Identified | Remediation Action | Owner | Deadline |
|---------|------------|----------------|-------------------|-------|----------|
| | | | | | |
| | | | | | |
| | | | | | |

**Priority 2 - Address Within 30 Days:**
| Section | Question # | Gap Identified | Remediation Action | Owner | Deadline |
|---------|------------|----------------|-------------------|-------|----------|
| | | | | | |
| | | | | | |

**Priority 3 - Address Within 90 Days:**
| Section | Question # | Gap Identified | Remediation Action | Owner | Deadline |
|---------|------------|----------------|-------------------|-------|----------|
| | | | | | |
| | | | | | |

---

## Recommendations Based on Score

### If Overall Score <50%: Emergency Plan
1. **Week 1:** Enable MFA for all users (highest ROI control)
2. **Week 2:** Deploy Defender for Endpoint on all devices
3. **Week 3:** Implement basic DLP policies (GDPR, financial data)
4. **Week 4:** Begin security awareness training
5. **Months 2-6:** Implement full SMB Security Framework

### If Overall Score 50-75%: Structured Plan
1. **Focus on lowest-scoring sections** from assessment
2. **Implement SMB Security Framework** modules addressing gaps:
   - Low Identity score → Phase 1 (Identity Foundation)
   - Low Endpoint score → Phase 2 (Endpoint Protection)
   - Low Data Governance → Phase 3 (Data Governance)
   - Low Monitoring → Phase 4 (Security Monitoring)

### If Overall Score >75%: Optimization Plan
1. **Address specific gaps** identified in assessment
2. **Advanced capabilities:** SOAR, threat hunting, deception technology
3. **Certifications:** Pursue ISO 27001, SOC 2, Cyber Essentials Plus
4. **Benchmarking:** Compare with industry peers, aim for top quartile

---

## Next Steps

1. **Complete Assessment:** Fill out all 135 questions honestly
2. **Calculate Scores:** Tally each section and overall percentage
3. **Identify Gaps:** Highlight all "No" responses (critical gaps)
4. **Prioritize:** Focus on Sections 1-4 (Identity, Endpoint, Data, Monitoring) first
5. **Create Remediation Plan:** Use gap analysis template above
6. **Present to Leadership:** Use results to justify SMB Security Framework investment
7. **Implement Framework:** Follow 4-phase rollout plan
8. **Re-Assess:** Complete assessment again after 6 months (track improvement)

---

## Supporting Materials

**Export to Spreadsheet:** Convert this questionnaire to Excel/Google Sheets for easier tracking and scoring automation

**Related Documents:**
- Microsoft Secure Score Tracker (compare with this assessment)
- Security Maturity Scorecard (visual dashboard of results)
- SMB Security Framework README (remediation guidance)

---

**License:** CC BY-SA 4.0
**Version:** 1.0
**Last Updated:** [Date]
**Framework:** Strategic Integration Framework for SMB Security
