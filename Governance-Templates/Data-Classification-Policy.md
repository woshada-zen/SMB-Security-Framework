# Data Classification Policy

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** Data Protection Officer / IT Director
**Classification:** Internal

---

## 1. Purpose

This Data Classification Policy establishes a standard framework for categorizing information assets based on their sensitivity, value, and criticality. Proper classification ensures appropriate protection measures are applied to safeguard organizational data.

## 2. Scope

This policy applies to all information created, received, stored, processed, or transmitted by [Company Name], regardless of format (electronic, paper, verbal) or location (office, cloud, remote work, third-party systems).

## 3. Classification Levels

### 3.1 Five-Tier Classification Scheme

| Level | Label | Description | Examples |
|-------|-------|-------------|----------|
| **0** | **Public** | Information intended for public disclosure with no confidentiality requirements | Marketing materials, press releases, public website content, job postings, published white papers |
| **1** | **Internal** | General business information for internal use only; minimal impact if disclosed | Internal memos, project plans, meeting notes, company policies, org charts |
| **2** | **Confidential** | Sensitive business information requiring protection; moderate impact if disclosed | Financial reports, customer contracts, employee contact lists, vendor agreements, strategic plans |
| **3** | **Highly Confidential** | Critical business information with severe impact if disclosed | M&A documents, board minutes, executive compensation, trade secrets, product roadmaps, salary data |
| **4** | **Restricted** | Information subject to regulatory/legal restrictions; very severe impact if disclosed | Personal data (GDPR), payment card data (PCI), health records, national ID numbers, bank account details |

### 3.2 Classification Criteria

When determining classification level, consider:
1. **Legal/Regulatory Requirements:** Does the data fall under GDPR, PCI DSS, or other regulations?
2. **Business Impact:** What would be the consequence if this data were disclosed, modified, or lost?
3. **Competitive Advantage:** Could disclosure benefit competitors or harm market position?
4. **Confidentiality Expectations:** Have individuals been promised confidentiality?
5. **Privacy Considerations:** Does it contain personal data of customers or employees?

## 4. Handling Requirements by Classification

### 4.1 Public (Level 0)

**Storage:**
- Any storage location (public website, cloud, file shares)
- No encryption required

**Sharing:**
- May be shared publicly without restriction
- No approval required for external sharing

**Transmission:**
- Any method (email, website, public cloud)
- No encryption required

**Retention:**
- Per business need or legal requirement
- No special disposal requirements

**Labeling:**
- Apply "Public" sensitivity label in Microsoft 365 (optional)
- No marking required on printed documents

### 4.2 Internal (Level 1)

**Storage:**
- Company-approved systems only (OneDrive, SharePoint, approved file shares)
- Encryption at rest recommended but not required

**Sharing:**
- Internal users only
- External sharing requires business justification and manager approval
- Use password-protected links if shared externally

**Transmission:**
- Email within organization without restriction
- External email: Use sensitivity label with header/footer marking
- No public posting or social media

**Retention:**
- Per retention schedule (typically 3 years)
- Secure deletion when no longer needed (recycle bin/soft delete acceptable)

**Labeling:**
- Apply "Internal" sensitivity label to all documents and emails
- Printed documents: "Internal Use Only" watermark or footer

### 4.3 Confidential (Level 2)

**Storage:**
- Encrypted storage required (OneDrive/SharePoint with encryption, BitLocker for endpoints)
- Access controlled by data owner approval
- SharePoint sites with restricted permissions

**Sharing:**
- Internal sharing on need-to-know basis only
- External sharing prohibited unless with encryption AND Data Owner approval
- Use secure sharing links (expiration date, access control)
- Third-party sharing requires NDA

**Transmission:**
- Email encryption required for external recipients (Microsoft 365 Message Encryption)
- Sensitivity label applies "Do Not Forward" protection
- No personal email accounts (Gmail, Yahoo, etc.)
- No USB drives unless encrypted

**Retention:**
- Per retention schedule (typically 7 years for financial, 3 years for operational)
- Secure deletion required (permanent deletion from recycle bins, secure file shredding)

**Labeling:**
- **Mandatory** "Confidential" sensitivity label
- Printed documents: "CONFIDENTIAL" watermark on every page
- Email subject line or header: [CONFIDENTIAL]

**Access Controls:**
- Multi-factor authentication (MFA) required
- Access logged and reviewed quarterly
- Conditional Access policies enforced

### 4.4 Highly Confidential (Level 3)

**Storage:**
- Encrypted storage with restricted access (dedicated SharePoint sites, Azure Information Protection)
- Access limited to specific named individuals (no groups unless absolutely necessary)
- Cannot be synced to personal devices

**Sharing:**
- Internal: Only with explicit Data Owner authorization
- External: Prohibited except with legal approval and NDA
- Encryption and copy/print restrictions enforced

**Transmission:**
- Encrypted email required (OME with copy/print/forward restrictions)
- Cannot be sent to personal email under any circumstances
- Hand-delivery or secure courier for physical documents
- No cloud storage outside approved Microsoft 365 tenant

**Retention:**
- Extended retention: 10+ years or permanent (legal/compliance)
- Content expiration enforced (90 days unless renewed)
- Secure destruction with certificate of destruction for physical media

**Labeling:**
- **Mandatory** "Highly Confidential" sensitivity label
- Printed documents: "HIGHLY CONFIDENTIAL" watermark on every page in bold
- Documents numbered and tracked

**Access Controls:**
- MFA required + conditional access from trusted devices only
- Access logged and reviewed monthly
- All access requires business justification

### 4.5 Restricted (Level 4)

**Storage:**
- Encrypted storage with audit logging (SharePoint with advanced compliance)
- Access restricted to minimum necessary personnel
- Geographic restrictions if required by regulation (EU personal data stays in EU)

**Sharing:**
- Internal: Named individuals only, with legal/compliance approval
- External: Prohibited except as required by law or with Data Protection Officer approval
- Data Processing Agreements (DPAs) required for any third-party access

**Transmission:**
- Encrypted transmission only (OME with copy/print/forward disabled)
- Tracked and logged
- Physical documents: Registered mail or secure courier only

**Retention:**
- Regulatory retention period (GDPR: no longer than necessary for purpose)
- Automated deletion when retention period expires
- Destruction logged and auditable

**Labeling:**
- **Mandatory** "Restricted" sensitivity label
- Printed documents: "RESTRICTED - PERSONAL DATA" or "RESTRICTED - PCI DATA" in red
- Page numbering and tracking required

**Access Controls:**
- MFA + device compliance required
- Access from corporate-managed devices only (no BYOD)
- All access logged and reviewed weekly
- Data loss prevention (DLP) policies enforced

**Privacy/Compliance:**
- GDPR Article 32 security measures applied
- Data subject rights supported (access, deletion, portability)
- Breach notification procedures in place (72-hour requirement)
- Regular Data Protection Impact Assessments (DPIAs)

## 5. Data Classification Responsibilities

### 5.1 Data Owners

**Responsibilities:**
- Classify data assets under their control
- Define access requirements and approve access requests
- Review access rights quarterly
- Ensure compliance with handling requirements
- Approve exceptions to policy

**Typical Data Owners:**
- CFO: Financial data
- HR Director: Employee personal data
- Sales Director: Customer data
- Legal Counsel: Legal and compliance data

### 5.2 Data Custodians (IT Department)

**Responsibilities:**
- Implement technical controls based on classification
- Configure sensitivity labels and DLP policies
- Monitor for policy violations
- Manage encryption and access controls
- Maintain audit logs

### 5.3 All Users

**Responsibilities:**
- Apply appropriate sensitivity labels to documents and emails
- Handle data according to classification requirements
- Report data classification questions to manager or Data Owner
- Complete annual data classification training
- Report suspected data breaches immediately

## 6. Sensitivity Labeling in Microsoft 365

### 6.1 Label Application

**Automatic Labeling:**
- Email with credit card numbers → Confidential
- Documents with keywords "GDPR", "personal data" → Restricted
- Files with "CONFIDENTIAL" in header → Confidential
- Source code files (.java, .py, .cs) → Confidential

**Manual Labeling:**
- Users must apply label when creating documents/emails
- Default label for new documents: Internal
- Label downgrade requires justification (logged and monitored)

**Label Enforcement:**
- DLP policies prevent removal of labels
- Mandatory labeling policies in Office apps
- Audit label changes and generate alerts for downgrades

### 6.2 Label Protections

| Label | Encryption | Watermark | Copy/Print | External Sharing | Expiration |
|-------|-----------|-----------|------------|------------------|------------|
| Public | No | No | Allowed | Allowed | No |
| Internal | No | "Internal Use Only" | Allowed | Restricted | No |
| Confidential | Yes | "CONFIDENTIAL" | Allowed | Prohibited | No |
| Highly Confidential | Yes | "HIGHLY CONFIDENTIAL" | Blocked | Prohibited | 90 days |
| Restricted | Yes | "RESTRICTED" | Blocked | Prohibited | Per regulation |

### 6.3 Sub-Labels

**Confidential Sub-Labels:**
- Confidential \ Legal (legal-privilege)
- Confidential \ Finance (financial data)
- Confidential \ HR (employee data)

**Restricted Sub-Labels:**
- Restricted \ GDPR (personal data)
- Restricted \ PCI (payment card data)

## 7. Data Lifecycle Management

### 7.1 Creation

- Data created with appropriate classification from inception
- Templates pre-labeled (e.g., contract template → Confidential)
- Classification reviewed when data is combined or aggregated

### 7.2 Storage

- Store data in approved locations based on classification:
  - **Public:** Any location
  - **Internal:** OneDrive, SharePoint, approved cloud
  - **Confidential:** Encrypted OneDrive/SharePoint with restricted access
  - **Highly Confidential:** Dedicated SharePoint sites with advanced security
  - **Restricted:** Compliance-grade storage with audit logging

### 7.3 Transmission

See Section 4 for transmission requirements by classification level.

### 7.4 Retention

| Data Type | Retention Period | Legal Basis | Disposition |
|-----------|------------------|-------------|-------------|
| **Financial Records** | 7 years | Tax regulations | Secure deletion |
| **Employee Records** | 7 years after termination | Employment law | Secure deletion |
| **Customer Contracts** | 7 years after expiration | Contract law | Secure deletion |
| **Personal Data (GDPR)** | As necessary for purpose | GDPR Art. 5(1)(e) | Automated deletion |
| **Email** | 3 years (business) / 30 days (transient) | Business need | Automated deletion |
| **Legal Hold Data** | Duration of litigation + 1 year | Legal requirement | Deletion after release |

### 7.5 Disposal

**Electronic Data:**
- **Public/Internal:** Standard deletion (recycle bin, then permanent)
- **Confidential:** Permanent deletion from all locations including backups
- **Highly Confidential/Restricted:** Cryptographic erasure or certified deletion service

**Physical Media:**
- **Public/Internal:** Recycling or standard disposal
- **Confidential:** Cross-cut shredding (particles < 2mm)
- **Highly Confidential/Restricted:** Certified shredding service with certificate of destruction

**Hardware Disposal:**
- All storage media wiped using NIST 800-88 guidelines (3-pass overwrite minimum)
- Hard drives physically destroyed if previously stored Restricted data
- Certificate of destruction retained for audit

## 8. Special Data Types

### 8.1 Personal Data (GDPR)

**Classification:** Restricted (minimum)

**Special Categories (higher sensitivity):**
- Racial or ethnic origin
- Political opinions
- Religious beliefs
- Trade union membership
- Genetic data
- Biometric data
- Health data
- Sex life or sexual orientation

**Requirements:**
- Lawful basis for processing documented
- Data Protection Impact Assessment (DPIA) for high-risk processing
- Data Processing Agreements (DPAs) with all processors
- Support for data subject rights (access, deletion, portability)
- Breach notification within 72 hours

### 8.2 Payment Card Data (PCI DSS)

**Classification:** Restricted

**Cardholder Data:**
- Primary Account Number (PAN) - 16-digit card number
- Cardholder name
- Expiration date
- Service code

**Sensitive Authentication Data (prohibited from storage):**
- Full magnetic stripe
- CAV2/CVC2/CVV2 codes
- PIN/PIN block

**Requirements:**
- Encrypted storage and transmission
- Masked PAN when displayed (only last 4 digits)
- Access restricted to those with business need
- Quarterly PCI DSS compliance assessment if processing >20k transactions/year

### 8.3 Source Code and Intellectual Property

**Classification:** Confidential (minimum), Highly Confidential for proprietary algorithms

**Requirements:**
- Access restricted to development team
- Source code repositories with audit logging (Azure DevOps, GitHub Enterprise)
- No storage on personal devices or public repositories
- Code review before deployment
- DLP policies prevent source code exfiltration

### 8.4 M&A and Strategic Information

**Classification:** Highly Confidential

**Requirements:**
- Project code names (no descriptive names in subject lines)
- Dedicated virtual data rooms with access logging
- NDAs required for all participants
- No electronic transmission outside secure data room
- Automatic expiration after deal closure or termination

## 9. Data Loss Prevention (DLP)

### 9.1 DLP Policies by Classification

**Confidential Data:**
- Block external sharing unless encrypted
- Alert user with policy tip before sending
- Generate incident report for security team review

**Restricted Data (Personal Data, PCI):**
- Block external sharing (no exceptions without DPO approval)
- Block upload to personal cloud storage (Dropbox, Google Drive)
- Block printing to unauthorized printers
- Block screenshots and copy/paste from protected applications

### 9.2 DLP Monitoring

- Weekly DLP incident reviews by security team
- Monthly reports to Data Owners
- Quarterly trend analysis to executive management
- User coaching for policy violations (not malicious)

## 10. Classification Review and Reclassification

### 10.1 Review Triggers

Data classification must be reviewed when:
- Major changes to content or purpose
- Regulatory changes affecting data
- Merger, acquisition, or divestiture
- End of project or contract
- Annually for all Highly Confidential and Restricted data

### 10.2 Declassification

Data may be declassified when:
- Information becomes publicly available through official channels
- Legal/regulatory retention period expires
- Business need no longer exists
- Data Owner approves in writing

**Procedure:**
1. Data Owner submits declassification request with justification
2. Legal/Compliance review (if Restricted data)
3. Update sensitivity label
4. Communicate to users with access
5. Document decision in classification register

## 11. Third-Party Data Sharing

### 11.1 Data Processing Agreements (DPAs)

Required for all third parties processing:
- Personal data (GDPR requirement)
- Confidential or higher data

**DPA Must Include:**
- Description of processing activities
- Data types and categories of data subjects
- Processor security obligations
- Sub-processor authorization and list
- Data breach notification requirements
- Data return or deletion upon contract termination
- Audit rights

### 11.2 Vendor Risk Assessment

Before sharing Confidential or higher data:
- [ ] Vendor security questionnaire completed
- [ ] DPA signed
- [ ] Vendor's security certifications reviewed (ISO 27001, SOC 2)
- [ ] Data residency confirmed (GDPR: EU data stays in EU)
- [ ] Access limited by principle of least privilege
- [ ] Annual vendor security review scheduled

## 12. Training and Awareness

### 12.1 Mandatory Training

**Annual Training for All Users:**
- Data classification levels and examples
- How to apply sensitivity labels in Microsoft 365
- Handling requirements by classification
- Recognizing personal data (GDPR)
- Reporting data breaches

**Role-Based Training:**
- **Data Owners:** Classification decisions, access approval, quarterly reviews
- **IT Staff:** Technical implementation of controls, DLP administration
- **HR:** Handling employee personal data
- **Finance:** PCI DSS requirements
- **Developers:** Source code protection

### 12.2 Awareness Materials

- Monthly security newsletter with data classification tips
- Quick reference card (wallet-sized) with classification levels
- Email signature reminder about labeling requirements
- Posters in office areas for clean desk policy

## 13. Compliance and Enforcement

### 13.1 Policy Violations

- Unintentional violations: Coaching and re-training
- Repeat violations: Formal written warning
- Intentional violations: Disciplinary action up to termination
- Malicious violations: Legal action, law enforcement notification

### 13.2 Monitoring and Auditing

- Monthly DLP incident reports
- Quarterly access reviews for Confidential+ data
- Annual data classification audit (sample of documents)
- Penetration testing includes data exfiltration scenarios

## 14. Exceptions

- Exceptions require written request to Data Owner
- Legal/Compliance review for Restricted data
- Executive approval for Highly Confidential exceptions
- Documented compensating controls
- Exception validity: 6 months maximum, then re-review

---

## Appendices

### Appendix A: Classification Decision Tree
[Flowchart to help users determine correct classification level]

### Appendix B: Sensitivity Label Quick Reference

| Label | When to Use | Email Behavior | SharePoint Sharing |
|-------|-------------|----------------|-------------------|
| Public | Press releases, marketing | No restrictions | Anyone |
| Internal | Memos, project plans | Internal only, header/footer | Internal only |
| Confidential | Contracts, financials | Do Not Forward, encrypted | Named users |
| Highly Confidential | Trade secrets, M&A | No copy/print/forward | Named users, expiration |
| Restricted | Personal data, PCI | No external, audit all access | Dedicated sites, logged |

### Appendix C: Common Data Classification Examples

- **Public:** Job postings, product brochures, blog posts
- **Internal:** All-hands meeting notes, org chart, office policies
- **Confidential:** Customer contracts, vendor agreements, financial reports, employee contact lists
- **Highly Confidential:** Board minutes, executive salaries, M&A documents, strategic plans
- **Restricted:** Customer personal data, employee national ID numbers, payment card data, health records

### Appendix D: GDPR Personal Data Examples

- Name, email, phone number
- National identification number (SSN, passport number)
- IP address, cookie identifiers
- Location data
- Financial information (bank account, credit card)
- Biometric data (fingerprints, facial recognition)
- Health information
- Racial/ethnic origin, political opinions, religious beliefs (special category)

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

**Note:** This Data Classification Policy template is derived from the Strategic Integration Framework for SMB Security. Customize data types, retention periods, and regulatory requirements to match your organization's specific needs and jurisdiction.
