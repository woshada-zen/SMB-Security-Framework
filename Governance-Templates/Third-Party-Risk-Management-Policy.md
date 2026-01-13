# Third-Party Risk Management Policy

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** IT Director / Procurement Manager
**Classification:** Internal

---

## 1. Purpose

This Third-Party Risk Management Policy establishes requirements for assessing, monitoring, and managing security and privacy risks associated with vendors, suppliers, contractors, and service providers that access [Company Name]'s systems or data.

## 2. Scope

This policy applies to all third parties that:
- Access company information systems or networks
- Process, store, or transmit company data (especially Confidential or higher)
- Provide cloud services or software applications
- Have physical access to company facilities
- Provide services critical to business operations

## 3. Third-Party Categories and Risk Levels

### 3.1 Risk Classification

| Risk Level | Criteria | Assessment Frequency | Examples |
|------------|----------|---------------------|----------|
| **Critical** | Access to Restricted data (personal data, PCI)<br>Business-critical services<br>Admin access to systems | Annual assessment<br>Quarterly reviews | Microsoft 365, payroll provider, CRM system, managed IT services |
| **High** | Access to Confidential data<br>Significant business impact if unavailable | Annual assessment | Accounting software, backup service, email security gateway |
| **Medium** | Access to Internal data<br>Moderate business impact | Biennial assessment | Marketing automation, project management tools, video conferencing |
| **Low** | No access to company data<br>Minimal business impact | Initial assessment only | Office supplies, catering, non-IT services |

## 4. Third-Party Lifecycle Management

### 4.1 Phase 1: Pre-Engagement (Vendor Selection)

**Step 1: Business Need Justification**
- Document business requirement and proposed solution
- Evaluate build vs. buy vs. cloud service
- Check if existing vendor can provide service
- Budget approval from appropriate authority

**Step 2: Initial Risk Assessment**
- Determine risk classification (Critical/High/Medium/Low)
- Identify data types vendor will access (classification level)
- Assess vendor's role: Processor or Controller (GDPR determination)
- Document in Vendor Risk Register

**Step 3: Security Due Diligence**

For Critical and High risk vendors:
- [ ] Request and review security questionnaire (Appendix A)
- [ ] Review vendor's security certifications:
  - ISO 27001 (Information Security Management)
  - SOC 2 Type II (Service Organization Controls)
  - Cyber Essentials Plus (UK-specific)
  - Industry-specific: PCI DSS, HIPAA, FedRAMP
- [ ] Review vendor's security policies and procedures
- [ ] Request recent penetration test results or security audit reports
- [ ] Verify data residency and geographic restrictions (GDPR compliance)
- [ ] Check for data breach history (public disclosures, news)
- [ ] Assess vendor's cyber insurance coverage

**Step 4: Legal and Compliance Review**

- [ ] Data Processing Agreement (DPA) if processing personal data (GDPR requirement)
- [ ] Non-Disclosure Agreement (NDA) for Confidential data
- [ ] Service Level Agreement (SLA) with uptime guarantees
- [ ] Right to audit clause included in contract
- [ ] Data breach notification requirements (within 24 hours)
- [ ] Data return or deletion upon contract termination
- [ ] Liability and indemnification clauses
- [ ] Compliance with applicable laws and regulations

**Approval Authority:**
| Risk Level | Approval Required |
|------------|-------------------|
| Critical | IT Director + Legal + CFO |
| High | IT Director + Department Head |
| Medium | Department Head |
| Low | Manager |

### 4.2 Phase 2: Onboarding

**Step 1: Access Provisioning**
- Apply principle of least privilege (minimum necessary access)
- Create vendor-specific accounts (no shared credentials)
- Require MFA for all vendor access
- Set access expiration date aligned with contract
- Document access granted in Vendor Access Log

**Step 2: Security Configuration**
- Configure Conditional Access policies for vendor accounts
- Apply appropriate DLP policies
- Enable audit logging for vendor activities
- Segment vendor access from internal network (if remote access)
- Provide security awareness training if applicable

**Step 3: Data Sharing Agreement**
- Document what data will be shared and how
- Apply sensitivity labels to shared data
- Use secure sharing methods (encrypted SharePoint, not email attachments)
- Configure external sharing settings (expiration, access controls)

### 4.3 Phase 3: Ongoing Monitoring

**Monthly:**
- Review vendor access logs for suspicious activity
- Monitor vendor service availability and performance

**Quarterly:**
- Review access rights (still appropriate and needed?)
- Check for vendor security incidents or breaches (news, vendor notifications)
- Review invoices for unexpected charges or anomalies

**Annually (Critical/High vendors):**
- Request updated security questionnaire
- Review renewed/updated security certifications (ISO 27001, SOC 2)
- Verify compliance with contract security requirements
- Conduct vendor performance review (SLA compliance, security posture)
- Assess if continued use is justified vs. alternatives

**Biennial (Medium vendors):**
- Basic security questionnaire refresh
- Verify certifications still valid

**Ad-Hoc Triggers:**
- Vendor experiences data breach
- Vendor changes ownership (M&A)
- Vendor changes data processing location or sub-processors
- Contract renewal or scope change
- Regulatory changes affecting vendor obligations

### 4.4 Phase 4: Off-Boarding

**When contract ends or vendor is terminated:**

1. **Data Return or Deletion (within 30 days):**
   - Request return of all company data in usable format
   - OR request certified deletion of all company data
   - Obtain certificate of deletion signed by vendor officer

2. **Access Revocation (within 24 hours of termination):**
   - Disable vendor user accounts
   - Revoke API keys, service accounts, and integrations
   - Remove from email distribution lists and Teams channels
   - Revoke physical access (badges, keys)

3. **Document Retention:**
   - Archive contract and all related documentation
   - Retain DPA, SLA, and security assessments
   - Retention period: 7 years (or per legal requirements)

4. **Exit Interview (for significant vendors):**
   - Lessons learned
   - Knowledge transfer to replacement vendor or internal team
   - Final invoice reconciliation

## 5. Data Processing Agreements (DPAs)

### 5.1 When DPA is Required

**Mandatory for vendors that:**
- Process personal data on behalf of [Company Name] (GDPR "Processor" role)
- Access employee personal data
- Access customer personal data
- Store or transmit any personal data

**Examples:** Payroll providers, CRM systems, email services, cloud backup, HR systems

### 5.2 Required DPA Clauses

- **Subject Matter:** Description of processing (e.g., "payroll processing for employees")
- **Duration:** Processing period aligned with contract term
- **Nature and Purpose:** Business purpose of processing
- **Personal Data Types:** Categories (names, emails, addresses, financial, etc.)
- **Data Subjects:** Categories of individuals (employees, customers, applicants)
- **Processor Obligations:**
  - Process data only on documented instructions from Company
  - Ensure confidentiality of personnel processing data
  - Implement appropriate technical and organizational security measures
  - Assist with data subject rights requests (access, deletion, portability)
  - Notify Company of data breaches within 24 hours
  - Delete or return data upon contract termination
  - Make available all information necessary to demonstrate compliance
- **Sub-Processors:**
  - List of authorized sub-processors
  - Requirement to notify Company before adding new sub-processors
  - Same data protection obligations flow down to sub-processors
- **International Transfers:** If data transferred outside EU/UK, use Standard Contractual Clauses (SCCs)
- **Audit Rights:** Company right to audit compliance (on-site or documentation review)

### 5.3 DPA Template

Use company-approved DPA template (Appendix B) or vendor's DPA if meets above requirements (subject to legal review).

## 6. Vendor Security Assessment

### 6.1 Security Questionnaire

**Core Areas (for all vendors with data access):**
1. **Information Security Program**
   - Dedicated security personnel/team?
   - ISO 27001 or equivalent certification?
   - Annual security audits or penetration tests?

2. **Access Controls**
   - Multi-factor authentication for admin access?
   - Principle of least privilege enforced?
   - Access reviews conducted how often?

3. **Data Protection**
   - Encryption at rest and in transit?
   - Encryption standards (AES-256, TLS 1.2+)?
   - Data backup frequency and retention?
   - Geographic location of data storage?

4. **Incident Response**
   - Incident response plan in place?
   - Breach notification commitment (timeline)?
   - Recent security incidents (last 2 years)?

5. **Business Continuity**
   - Disaster recovery plan tested annually?
   - RTO/RPO commitments?
   - Redundancy and failover capabilities?

6. **Compliance**
   - SOC 2 Type II report available?
   - GDPR compliance measures?
   - Industry-specific compliance (PCI DSS, HIPAA)?

7. **Personnel Security**
   - Background checks for employees?
   - Security awareness training?
   - NDA signed by all employees?

8. **Subcontractors**
   - List of sub-processors?
   - Same security standards applied to subs?
   - Notification before changing sub-processors?

**Advanced Areas (Critical risk vendors):**
- Vulnerability management program
- Secure software development lifecycle (SDLC)
- Third-party penetration testing results
- Security monitoring and SIEM
- Physical security controls

### 6.2 Risk Scoring

| Question Area | Weight | Vendor Score | Weighted Score |
|---------------|--------|--------------|----------------|
| Access Controls | 25% | __/10 | __ |
| Data Protection | 25% | __/10 | __ |
| Compliance | 20% | __/10 | __ |
| Incident Response | 15% | __/10 | __ |
| Business Continuity | 10% | __/10 | __ |
| Personnel Security | 5% | __/10 | __ |
| **Total** | **100%** | | **__/10** |

**Risk Determination:**
- 8.0-10.0: Low Risk (Acceptable, proceed with standard monitoring)
- 6.0-7.9: Medium Risk (Acceptable with remediation plan or compensating controls)
- 4.0-5.9: High Risk (Require remediation before contract or escalate to leadership)
- <4.0: Unacceptable (Do not proceed or terminate existing relationship)

## 7. Access Management for Third Parties

### 7.1 Account Types

**Azure AD Guest Accounts (preferred):**
- For vendors needing access to SharePoint, Teams, or Microsoft 365 apps
- MFA required
- Conditional Access policies applied
- Access reviews every 90 days
- Automatic expiration aligned with contract end date

**Service Accounts / API Keys:**
- For system integrations (e.g., CRM to marketing automation)
- Separate account per vendor (no sharing)
- Credentials stored in Azure Key Vault
- Rotate credentials every 90 days
- Log all API calls for audit

**VPN Access:**
- For vendors requiring network access (remote IT support)
- Dedicated VPN profile for vendors
- Separate VLAN from internal network
- Access to specific systems only (not full network)
- Session logging and monitoring

### 7.2 Access Approval Process

1. **Request:** Business owner submits vendor access request form
2. **Risk Assessment:** IT Security reviews and assigns risk level
3. **Approval:** Per approval matrix (Section 4.1 Step 4)
4. **Provisioning:** IT creates account with appropriate permissions
5. **Documentation:** Log in Vendor Access Register
6. **Notification:** Vendor receives credentials and acceptable use guidelines

### 7.3 Access Review

**Quarterly Access Reviews:**
- IT generates report of all active vendor accounts
- Business owners confirm access still required
- Remove access for completed projects or expired contracts
- Update access for scope changes

**Just-in-Time Access:**
- For infrequent vendor access needs (e.g., annual audit)
- Grant time-limited access (e.g., 7-day window)
- Automatically revoke after expiration
- Require re-approval for subsequent access

## 8. Cloud Service Providers (SaaS)

### 8.1 Shadow IT Prevention

- IT maintains catalog of approved SaaS applications
- Microsoft Cloud App Security monitors for unsanctioned cloud app usage
- Users must request approval before subscribing to new cloud services
- IT evaluates security, integration, and cost before approval

### 8.2 SaaS Security Requirements

**Minimum requirements for approval:**
- [ ] SSO via Azure AD (SAML 2.0 or OAuth)
- [ ] MFA support (required for admin accounts)
- [ ] Data encryption at rest and in transit
- [ ] SOC 2 Type II report within last 12 months
- [ ] GDPR-compliant data processing agreement
- [ ] Data residency options (prefer EU for GDPR compliance)
- [ ] API for integration and data export (vendor lock-in mitigation)
- [ ] Audit logging and retention (minimum 90 days)
- [ ] Regular security updates and patching
- [ ] Acceptable SLA (99.5%+ uptime for business-critical)

**Preferred (not mandatory):**
- ISO 27001 certification
- Penetration testing by third party
- Bug bounty program
- Incident response partnership

### 8.3 SaaS Configuration Review

After deployment, IT Security reviews:
- Default security settings changed to secure configuration
- External sharing disabled or restricted
- Admin roles assigned to minimum necessary users
- Audit logging enabled
- Integration with SIEM (Azure Sentinel) for monitoring

## 9. Incident Management

### 9.1 Vendor Security Incidents

**Vendor must notify [Company Name] within 24 hours if:**
- Data breach affecting company data
- Ransomware or malware incident
- Unauthorized access to company systems or data
- Service disruption affecting SLA
- Changes to sub-processors or data location

**Company Response:**
1. Activate Incident Response Team (see Incident Response Plan)
2. Request detailed incident report from vendor
3. Assess impact to company data and operations
4. Determine if breach notification required (GDPR 72-hour rule)
5. Consider termination if vendor at fault or inadequate response
6. Document in Vendor Risk Register

### 9.2 Vendor Performance Issues

If vendor fails to meet SLA or security requirements:
1. Formal notice to vendor (email with remediation deadline)
2. Weekly status meetings until resolved
3. Escalation to vendor management if not resolved within 30 days
4. Consider alternative vendors
5. Invoke contract termination clause if material breach

## 10. Vendor Risk Register

### 10.1 Required Information

Maintain spreadsheet or database with:
- Vendor name and primary contact
- Service provided and business owner
- Risk classification (Critical/High/Medium/Low)
- Data classification level accessed
- Contract start and end dates
- Assessment date and next review date
- Risk score from questionnaire
- Certifications (ISO 27001, SOC 2) and expiration dates
- DPA status (signed, pending, N/A)
- Access method (Azure AD, VPN, API)
- Open issues or remediation items
- Annual spend

### 10.2 Reporting

**Monthly:** High-level summary to IT Director (new vendors, contract expirations)
**Quarterly:** Detailed report to executive management (risk trends, high-risk vendors, incidents)
**Annually:** Board of Directors presentation (top 10 vendors, aggregate risk, major changes)

## 11. Training and Awareness

**Annual Training for All Staff:**
- Risks of shadow IT and unapproved cloud services
- How to request approval for new vendors
- Never share company data with vendors without approval

**Role-Based Training:**
- **Procurement:** Vendor risk assessment process, contract security requirements
- **IT Staff:** Vendor onboarding, access provisioning, monitoring procedures
- **Business Owners:** Responsibilities for vendor management, access reviews

## 12. Policy Exceptions

- Exceptions require written business justification
- IT Director + Legal approval for High/Critical vendors
- Documented compensating controls
- Maximum 6-month exception period (then re-assess)

---

## Appendices

### Appendix A: Vendor Security Questionnaire Template

[30-40 question template covering access controls, data protection, compliance, incident response, business continuity, personnel security]

Sample questions:
1. Do you have a dedicated information security team or officer?
2. Are you certified to ISO 27001 or equivalent standard?
3. Do you conduct annual third-party security audits or penetration tests?
4. Is multi-factor authentication (MFA) enforced for administrative access?
5. How is data encrypted (at rest and in transit)?
6. Where is company data stored geographically?
7. How often are backups performed and tested?
8. What is your breach notification timeline commitment?
9. Have you experienced any security breaches in the last 24 months? If yes, describe.
10. Do you have SOC 2 Type II report available for review?

### Appendix B: Data Processing Agreement (DPA) Template

[Standard DPA template based on EU Standard Contractual Clauses]

### Appendix C: Vendor Access Request Form

| Field | Value |
|-------|-------|
| Vendor Name | |
| Business Owner | |
| Service Description | |
| Data Classification Level | Public / Internal / Confidential / Highly Confidential / Restricted |
| Access Type | Azure AD Guest / VPN / API / Physical Access |
| Access Duration | Start: ____ End: ____ |
| Business Justification | |
| Approvals | IT Director: ____ Legal (if Restricted data): ____ |

### Appendix D: Vendor Risk Register Template

| Vendor | Service | Risk Level | Data Access | Contract End | Last Assessment | Risk Score | DPA Signed | Issues |
|--------|---------|------------|-------------|--------------|-----------------|------------|------------|--------|
| Microsoft | M365, Azure | Critical | Restricted | N/A (ongoing) | 2025-01 | 9.2/10 | Yes | None |
| [Vendor B] | Payroll | Critical | Restricted | 2026-12 | 2025-03 | 8.5/10 | Yes | None |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

**Note:** This Third-Party Risk Management Policy template is derived from the Strategic Integration Framework for SMB Security. Customize risk levels, approval authorities, and assessment criteria to match your organization's risk tolerance and resources.
