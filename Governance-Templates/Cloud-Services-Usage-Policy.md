# Cloud Services Usage Policy

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** IT Director / Cloud Architect
**Classification:** Internal

---

## 1. Purpose

This Cloud Services Usage Policy establishes requirements for the secure adoption, configuration, and use of cloud-based software and services (SaaS, PaaS, IaaS) to ensure data protection, compliance, and business continuity while preventing "shadow IT" risks.

## 2. Scope

This policy applies to:
- All cloud services used to store, process, or transmit company data
- Software-as-a-Service (SaaS) applications (Microsoft 365, CRM, project management)
- Platform-as-a-Service (PaaS) development platforms
- Infrastructure-as-a-Service (IaaS) virtual machines and cloud infrastructure
- All employees, contractors, and business units subscribing to cloud services
- Sanctioned and unsanctioned (shadow IT) cloud usage

## 3. Cloud Service Categories

### 3.1 Core Enterprise Services (IT-Managed)

**Fully sanctioned and managed by IT:**
- **Microsoft 365:** Exchange Online, SharePoint, OneDrive, Teams, Office Apps
- **Microsoft Azure:** Cloud infrastructure, virtual machines, databases, storage
- **Identity:** Azure Active Directory (AAD), MFA, Conditional Access
- **Security:** Microsoft Defender, Azure Sentinel, Cloud App Security

**Management:**
- Deployed and configured by IT Department
- Enterprise licensing and agreements
- Full integration with security controls (DLP, Conditional Access, monitoring)
- Mandatory for all users

### 3.2 Approved Business Applications (IT-Sanctioned)

**Pre-approved SaaS applications for specific business functions:**

| Category | Approved Applications | Purpose |
|----------|----------------------|---------|
| **CRM/Sales** | Salesforce, Microsoft Dynamics 365 | Customer relationship management |
| **Project Management** | Asana, Monday.com, Jira | Task and project tracking |
| **Accounting** | QuickBooks Online, Xero | Financial management |
| **HR/Payroll** | BambooHR, ADP Workforce | Employee management |
| **Marketing** | Mailchimp, HubSpot | Email marketing, campaigns |
| **Design** | Canva, Adobe Creative Cloud | Graphics and design |
| **Video Conferencing** | Zoom (Enterprise), Webex | Meetings and webinars |

**Usage Requirements:**
- Single Sign-On (SSO) via Azure AD required
- Data classification: Maximum Internal (no Confidential+ data without IT approval)
- Annual security review by IT
- Business owner responsible for license management and costs

### 3.3 Shadow IT (Unsanctioned)

**Prohibited without IT approval:**
- Unapproved file sharing: Dropbox (personal), Google Drive (personal), WeTransfer
- Unapproved messaging: WhatsApp (for work), Telegram, Signal (for work)
- Unapproved collaboration: Personal Slack, Trello, Notion accounts
- Unapproved video conferencing: Free Zoom, Google Meet (personal)
- Personal cloud storage for work files

**Consequences:**
- Data stored in unsanctioned services is not backed up or recoverable
- No IT support for shadow IT tools
- Violates data classification and GDPR requirements
- Policy violations: Warning (first offense), access blocked (repeat)

**How to Request Approval:**
- Submit IT ticket with business justification
- IT evaluates security, integration, cost, and redundancy
- Approval process: 5-10 business days (see Section 5)

## 4. Cloud Security Requirements

### 4.1 Minimum Security Standards (All Cloud Services)

Before approval, cloud service must meet:

**1. Authentication and Access:**
- [ ] Single Sign-On (SSO) via Azure AD (SAML 2.0 or OpenID Connect)
- [ ] Multi-Factor Authentication (MFA) support required
- [ ] Role-based access control (RBAC) available
- [ ] User provisioning and deprovisioning via SCIM (preferred)

**2. Data Protection:**
- [ ] Data encryption at rest (AES-256 or equivalent)
- [ ] Data encryption in transit (TLS 1.2 or higher)
- [ ] Geographic data residency options (prefer EU for GDPR compliance)
- [ ] Data export capability (avoid vendor lock-in)
- [ ] Data retention and deletion controls

**3. Compliance and Auditing:**
- [ ] SOC 2 Type II report (within last 12 months)
- [ ] ISO 27001 certification (preferred)
- [ ] GDPR compliance (Data Processing Agreement available)
- [ ] Audit logging (minimum 90 days retention)
- [ ] Security incident notification commitment (within 24 hours)

**4. Business Continuity:**
- [ ] SLA of 99.5% uptime minimum (99.9% for business-critical)
- [ ] Backup and disaster recovery capabilities
- [ ] Multi-region redundancy (for business-critical services)
- [ ] Documented incident response and business continuity plan

**5. Vendor Stability:**
- [ ] Company financially stable (not at risk of shutdown)
- [ ] Transparent pricing (no surprise fees)
- [ ] Clear contract termination and data return policy
- [ ] API for integrations and data access

### 4.2 Data Classification Restrictions

| Cloud Service Type | Max Data Classification | Examples |
|-------------------|------------------------|----------|
| **Core Enterprise (Microsoft 365, Azure)** | Restricted | All data types permitted |
| **Approved Business Apps (with DPA)** | Confidential | CRM, HR systems, accounting |
| **Approved Collaboration Tools** | Internal | Project management, wikis |
| **Unapproved / Shadow IT** | Public only | Prohibited for Internal+ data |

**GDPR Personal Data:**
- Only store in services with Data Processing Agreement (DPA)
- Data must remain in EU/EEA (or covered by Standard Contractual Clauses)
- Data subject rights (access, deletion) must be technically supported

### 4.3 Secure Configuration Baseline

**Upon deployment, IT configures:**
- Default external sharing: Disabled (enable selectively)
- Admin roles: Minimum necessary (principle of least privilege)
- Audit logging: Enabled and integrated with SIEM (Azure Sentinel)
- Data loss prevention (DLP): Configured if service supports
- Session timeouts: Maximum 8 hours (re-authentication required)
- Conditional Access: Apply company policies (trusted devices, locations)

## 5. Cloud Service Approval Process

### 5.1 Request Submission

**User submits request via IT ticketing system:**
- Service name and URL
- Business purpose and justification
- Data types to be stored (classification level)
- Number of users and annual cost
- Alternative options considered
- Department head approval

### 5.2 IT Security Assessment (5-10 business days)

**Step 1: Shadow IT Check**
- Verify service not already in use via Cloud App Security (MCAS)
- Check for existing corporate account or contract

**Step 2: Vendor Risk Assessment**
- Security questionnaire (see Third-Party Risk Management Policy)
- Review SOC 2, ISO 27001, certifications
- Evaluate data residency and GDPR compliance
- Check for data breaches or security incidents (public record)

**Step 3: Integration Review**
- SSO via Azure AD possible?
- API for user provisioning and data sync?
- Compatibility with DLP, Conditional Access, logging?

**Step 4: Cost-Benefit Analysis**
- Annual licensing cost
- IT implementation and support effort
- Comparison with existing tools (redundancy check)

### 5.3 Approval Decision

**Approval Levels:**
| Service Cost/Risk | Approval Required |
|-------------------|-------------------|
| Low (<$500/year, Internal data) | IT Director |
| Medium ($500-$5k/year, Confidential data) | IT Director + CFO |
| High (>$5k/year OR Restricted data) | IT Director + CFO + Legal |

**Outcomes:**
- **Approved:** Service added to sanctioned list, SSO configured, users notified
- **Conditional Approval:** Approved with requirements (e.g., DPA must be signed first)
- **Denied:** Business justification insufficient, security risk too high, or redundant with existing tool
- **Alternative Suggested:** IT proposes existing tool that meets need

### 5.4 Deployment and Onboarding

**IT Actions:**
1. Negotiate contract and Data Processing Agreement (DPA)
2. Configure SSO and user provisioning via Azure AD
3. Apply security baseline configuration (Section 4.3)
4. Integrate audit logs with Azure Sentinel (if applicable)
5. Configure DLP policies (if applicable)
6. Document in Cloud Service Registry

**User Actions:**
1. Complete service-specific training (if required)
2. Sign in via SSO (Azure AD)
3. Apply sensitivity labels to uploaded documents
4. Follow data classification policy

## 6. Cloud Service Registry

### 6.1 Required Information

IT maintains spreadsheet/database with:
- Service name and category (SaaS, PaaS, IaaS)
- Business owner and IT contact
- Data classification level
- User count and annual cost
- Contract start and renewal dates
- SSO configuration status
- DPA signed (Yes/No)
- SOC 2 / ISO 27001 expiration dates
- Last security review date
- Integration status (SIEM, DLP, SCIM)

### 6.2 Quarterly Reviews

- Review service usage (underutilized licenses)
- Verify SOC 2 / ISO 27001 still valid
- Check for vendor security incidents
- Update costs and contract renewal dates

### 6.3 Annual Renewal Decision

**For each service, evaluate:**
- Still meeting business need?
- Usage justifies cost?
- Security posture still acceptable?
- Alternatives available with better features/cost?

**Renewal or Termination:**
- Renew: Negotiate pricing, review contract terms
- Terminate: Migrate data, export critical information, delete accounts

## 7. Microsoft 365 and Azure Governance

### 7.1 Microsoft 365 Workload Policies

**Exchange Online (Email):**
- External email forwarding: Blocked by default
- Large attachments (>10MB): Use OneDrive sharing links instead
- Retention: 3 years for business email, 30 days for transient
- Litigation hold: Enabled for legal/compliance requirements

**SharePoint Online / OneDrive:**
- External sharing: Disabled by default (enable per site with justification)
- Sharing links: Specific people (not "anyone with link")
- Link expiration: 90 days maximum
- Sensitivity labels: Required for Confidential+ documents
- Versioning: Enabled (500 versions retained)

**Microsoft Teams:**
- External access: Enabled for specific domains only (no open federation)
- Guest access: Enabled with approval (guests must accept terms)
- Private channels: Allowed (audited)
- Meeting recording: Enabled with consent
- Data retention: Chat messages retained 3 years

**OneDrive Sync:**
- Sync only to company-managed devices (Intune enrolled)
- Known Folder Move (KFM): Redirect Desktop, Documents, Pictures to OneDrive
- Block sync on BYOD (web access only)

### 7.2 Azure Subscription Governance

**Subscription Structure:**
- Production subscription: Business-critical workloads
- Development/Test subscription: Non-production environments
- Sandbox subscription: Experimentation and training (separate billing)

**Resource Tagging (Mandatory):**
- Owner: Department or project owner
- Environment: Production / Test / Development
- CostCenter: Charge-back accounting
- DataClassification: Public / Internal / Confidential

**Cost Controls:**
- Monthly budget alerts: Notify owner at 80% and 100% of budget
- Auto-shutdown: Dev/Test VMs shut down outside business hours
- Right-sizing recommendations: Quarterly review of underutilized resources

**Security Baseline:**
- Azure Security Center: Standard tier enabled
- Network Security Groups (NSGs): Default-deny, allow specific ports only
- Just-In-Time (JIT) VM access: Enabled for management ports (RDP, SSH)
- Azure Key Vault: For secrets, certificates, encryption keys
- Azure Backup: Enabled for all production VMs and databases

## 8. Shadow IT Detection and Response

### 8.1 Microsoft Cloud App Security (MCAS)

**Monitoring:**
- Discover unsanctioned cloud apps via network traffic analysis
- Risk scoring of discovered apps (low/medium/high risk)
- User activity monitoring in sanctioned apps (anomaly detection)

**Weekly Reports:**
- Top unsanctioned apps by user count and data volume
- High-risk apps requiring attention
- Users accessing unsanctioned apps

### 8.2 Response to Shadow IT Discovery

**Low Risk (e.g., personal Spotify, Netflix):**
- No action required (non-work usage tolerated)

**Medium Risk (e.g., personal Dropbox for work files):**
- Email user with policy reminder and approved alternative
- Offer migration assistance to OneDrive
- Warning if continued after 30 days

**High Risk (e.g., PII in unsanctioned service, credential-harvesting app):**
- Immediate block via firewall or proxy (if applicable)
- Contact user to migrate data to approved service
- Manager notification
- Disciplinary action if intentional policy violation

## 9. Data Residency and GDPR Compliance

### 9.1 Geographic Restrictions

**EU Personal Data:**
- Must be stored in EU/EEA data centers
- If non-EU service used: Standard Contractual Clauses (SCCs) required
- Microsoft 365 tenant: Data residency set to UK/EU

**Verification:**
- Review vendor's data center locations
- Confirm in Data Processing Agreement (DPA)
- Check for US Cloud Act implications (EU data access by US authorities)

### 9.2 Data Processing Agreements (DPAs)

**Required for all cloud services processing:**
- Employee personal data
- Customer personal data
- Any GDPR-regulated data

**DPA Must Include:**
- Scope of processing (purpose, data types, retention)
- Security measures (encryption, access controls)
- Sub-processor list and approval process
- Data breach notification (within 24 hours)
- Data subject rights support (access, deletion, portability)
- Audit rights (annual review of security controls)

**Template:** Use company-approved DPA or vendor's DPA if meets requirements (legal review required)

## 10. Incident Response for Cloud Services

### 10.1 Cloud Service Outage

**Response:**
1. Verify outage via vendor status page
2. Notify affected users (email, Teams announcement)
3. Activate workarounds if available (mobile app, alternative service)
4. Monitor vendor updates and estimated restoration time
5. Escalate to vendor support if SLA breach

**Post-Incident:**
- Request vendor post-incident report (root cause analysis)
- Assess if SLA credits apply
- Evaluate if service still acceptable or alternative needed

### 10.2 Cloud Service Data Breach

**If vendor notifies of data breach:**
1. Activate Incident Response Plan (see Incident Response Plan policy)
2. Request detailed incident report from vendor (scope, root cause, remediation)
3. Assess if company data affected (which users, what data types)
4. Determine GDPR notification requirement (72-hour rule)
5. Consider contract termination if vendor at fault

**Notification:**
- Data Protection Authority: Within 72 hours if personal data affected
- Affected individuals: Without undue delay if high risk
- Executive management and board: Immediately for material breaches

## 11. Training and Awareness

### 11.1 Annual Training (All Users)

- Approved cloud services and how to request new ones
- Shadow IT risks (data loss, compliance violations, security)
- Data classification requirements in cloud apps
- Sensitivity labeling in Microsoft 365
- Secure sharing practices (avoid public links)

### 11.2 Role-Based Training

**Department Heads:**
- Cloud service procurement and approval process
- Cost management and budget accountability

**IT Staff:**
- Cloud security configuration baselines
- SSO and SCIM integration
- MCAS administration and shadow IT detection

## 12. Policy Exceptions

- Exceptions require written business justification
- IT Director + CFO approval for high-cost or high-risk services
- Compensating controls documented
- Maximum 6-month exception period, then re-review

---

## Appendices

### Appendix A: Approved Cloud Services List

| Service | Category | SSO Enabled | DPA Signed | Max Data Class | Business Owner |
|---------|----------|-------------|------------|----------------|----------------|
| Microsoft 365 | Core Enterprise | Yes | Yes | Restricted | IT Director |
| Microsoft Azure | Cloud Infrastructure | Yes | Yes | Restricted | IT Director |
| Salesforce | CRM | Yes | Yes | Confidential | Sales Director |
| QuickBooks Online | Accounting | Yes | Yes | Confidential | CFO |
| BambooHR | HR/Payroll | Yes | Yes | Restricted | HR Director |
| [Add org-specific services] | | | | | |

### Appendix B: Cloud Service Request Form

**To request approval for a new cloud service, submit IT ticket with:**

| Field | Information Required |
|-------|---------------------|
| Service Name | Full name and URL |
| Business Purpose | What problem does this solve? |
| Data Classification | What data will be stored? (Public/Internal/Confidential/Restricted) |
| Users | How many users need access? |
| Cost | Annual subscription cost |
| Alternatives Considered | What other options were evaluated? |
| SSO Available | Does service support SAML/OAuth SSO? |
| Security Certifications | SOC 2, ISO 27001, or other? |
| Department Head Approval | Manager signature |

### Appendix C: Cloud Security Checklist

**Before deploying cloud service:**
- [ ] Vendor security questionnaire completed (see Third-Party Risk Management Policy)
- [ ] SOC 2 Type II report reviewed (less than 12 months old)
- [ ] Data Processing Agreement (DPA) signed
- [ ] SSO via Azure AD configured
- [ ] MFA enabled for admin accounts
- [ ] Default security settings reviewed and hardened
- [ ] External sharing disabled or restricted
- [ ] Audit logging enabled
- [ ] SIEM integration configured (if applicable)
- [ ] DLP policies applied (if applicable)
- [ ] User training materials created
- [ ] Cloud Service Registry updated
- [ ] Users notified of new service availability

### Appendix D: Common Shadow IT Risks

| Unsanctioned Service | Risk | Approved Alternative |
|---------------------|------|---------------------|
| Personal Dropbox | Data loss, no backup, GDPR violation | OneDrive for Business |
| Personal Google Drive | No DLP, no monitoring, data leakage | SharePoint, OneDrive |
| WhatsApp (for work) | No retention, encrypted (eDiscovery impossible) | Microsoft Teams |
| Free Zoom account | No SSO, meeting hijacking, limited security | Teams or Zoom Enterprise |
| WeTransfer | No access control, data persistence unknown | OneDrive sharing links |
| Trello (personal) | No backup, no SSO, shadow project data | Approved PM tool (Asana, Monday.com) |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

**Note:** This Cloud Services Usage Policy template is derived from the Strategic Integration Framework for SMB Security. Customize approved services list, approval thresholds, and data residency requirements based on your organization's industry, risk tolerance, and regulatory environment.
