# Master Information Security Policy

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** Chief Information Security Officer / IT Director
**Classification:** Internal

---

## 1. Purpose

This Master Information Security Policy establishes the framework for protecting [Company Name]'s information assets, including data, systems, networks, and infrastructure. This policy aligns with industry best practices and regulatory requirements to ensure confidentiality, integrity, and availability of organizational information.

## 2. Scope

This policy applies to:
- All employees, contractors, vendors, and third parties with access to company information systems
- All information assets owned, leased, or managed by [Company Name]
- All locations where company business is conducted (offices, remote work, client sites)
- All technology platforms including Microsoft 365, Azure, on-premises systems, and third-party applications

## 3. Policy Statements

### 3.1 Information Security Governance

[Company Name] commits to:
- Implementing risk-based security controls aligned with business objectives
- Maintaining compliance with applicable laws and regulations (GDPR, data protection laws)
- Establishing clear roles and responsibilities for information security
- Providing adequate resources for security program implementation
- Conducting regular security assessments and audits

### 3.2 Data Classification and Handling

All information must be classified according to the organization's 5-tier classification scheme:
1. **Public** - Information intended for public disclosure
2. **Internal** - General business information for internal use only
3. **Confidential** - Sensitive business information requiring protection
4. **Highly Confidential** - Critical information with severe impact if disclosed
5. **Restricted** - Information subject to regulatory/legal restrictions

Data handling requirements are defined in the Data Classification Policy.

### 3.3 Access Control

Access to information systems and data shall be:
- Granted based on principle of least privilege
- Approved by data owners and managers
- Reviewed quarterly for appropriateness
- Immediately revoked upon termination of employment or contract

Multi-factor authentication (MFA) is required for:
- All user accounts accessing company systems
- All administrative and privileged accounts
- All remote access to corporate resources

### 3.4 Identity and Authentication

- All users must have unique accounts (no shared credentials)
- Passwords must comply with Password Policy requirements
- Emergency access accounts must be secured and monitored
- Conditional Access policies shall be enforced per the Identity Foundation module

### 3.5 Endpoint Security

All devices accessing company data must:
- Be enrolled in Microsoft Intune device management
- Meet device compliance policy requirements
- Have Microsoft Defender for Endpoint enabled
- Receive security updates within 7 days of release
- Use full disk encryption (BitLocker for Windows, FileVault for macOS)

### 3.6 Data Protection

- All Confidential and higher data must be encrypted at rest and in transit
- Sensitivity labels must be applied to all documents and emails
- Data Loss Prevention (DLP) policies shall prevent unauthorized data disclosure
- Personal data must be handled in compliance with GDPR Article 32 requirements
- Backups must be encrypted and tested quarterly

### 3.7 Network Security

- Network segmentation shall separate corporate, guest, and IoT networks
- Firewalls and network security groups shall filter traffic by default-deny
- VPN or zero-trust network access required for remote access
- Intrusion detection/prevention systems shall monitor network traffic
- Public Wi-Fi usage requires VPN connection

### 3.8 Security Monitoring and Incident Response

- Security monitoring shall operate 24/7 using Microsoft 365 Defender and Azure Sentinel
- All security events shall be logged and retained for 365 days minimum
- Security incidents must be reported within 1 hour of detection
- Incident response procedures are defined in the Incident Response Plan
- Data breach notification shall comply with GDPR 72-hour requirement

### 3.9 Third-Party Risk Management

- All vendors with access to company data must undergo security assessment
- Data Processing Agreements (DPAs) required for all data processors
- Third-party access shall be time-limited and monitored
- Vendor security reviews conducted annually
- Requirements defined in Third-Party Risk Management Policy

### 3.10 Security Awareness and Training

- Annual security awareness training mandatory for all employees
- Role-based training for administrators and privileged users
- Phishing simulations conducted quarterly
- Security updates communicated via monthly newsletters
- Training completion tracked in Security Awareness Training Tracker

### 3.11 Physical Security

- Office access controlled by badge readers or keycard systems
- Visitor access logged and escorted
- Clean desk policy enforced for Confidential materials
- Secure disposal of confidential documents (shredding)
- Equipment disposal follows data sanitization procedures

### 3.12 Business Continuity and Disaster Recovery

- Business continuity plans tested annually
- Recovery Time Objective (RTO): 24 hours for critical systems
- Recovery Point Objective (RPO): 4 hours maximum data loss
- Backups stored in geographically separate Azure regions
- Requirements defined in Business Continuity Plan

## 4. Roles and Responsibilities

| Role | Responsibilities |
|------|-----------------|
| **Executive Management** | Approve policy, allocate resources, executive sponsorship |
| **IT Director/CISO** | Policy ownership, security program management, risk oversight |
| **IT Security Team** | Implement controls, monitor systems, incident response |
| **IT Operations** | Maintain systems, apply patches, backup/recovery |
| **Data Owners** | Classify data, approve access, define retention |
| **All Employees** | Follow policies, report incidents, protect credentials |

See RACI Matrix Template for detailed responsibility assignments.

## 5. Compliance and Enforcement

### 5.1 Policy Compliance

- Compliance monitored through automated tools (Microsoft Secure Score, Compliance Manager)
- Quarterly compliance reviews by IT Security Team
- Annual third-party security audit
- Non-compliance reported to executive management

### 5.2 Policy Violations

Violations of this policy may result in:
- Verbal or written warning
- Suspension of system access
- Termination of employment or contract
- Legal action for criminal violations
- Reporting to regulatory authorities as required by law

### 5.3 Exceptions

- Policy exceptions require written justification and risk assessment
- Exceptions approved by IT Director/CISO and executive sponsor
- Exceptions documented with compensating controls
- Exception validity reviewed every 6 months

## 6. Policy Review and Maintenance

- This policy reviewed annually or after significant security incidents
- Policy updates approved by executive management
- All employees notified of policy changes within 30 days
- Acknowledgment of policy required upon hire and after updates

## 7. Related Policies and Documents

1. Acceptable Use Policy
2. Data Classification Policy
3. Password Policy
4. Incident Response Plan
5. Business Continuity Plan
6. Third-Party Risk Management Policy
7. Remote Work Security Policy
8. Mobile Device Policy
9. Cloud Services Usage Policy
10. SMB Security Framework - Module 1-4 Playbooks

## 8. References

- ISO/IEC 27001:2022 Information Security Management
- NIST Cybersecurity Framework v1.1
- GDPR (EU) 2016/679 - General Data Protection Regulation
- NCSC Cyber Essentials (UK)
- Microsoft Security Best Practices

## 9. Policy Approval

| Name | Title | Signature | Date |
|------|-------|-----------|------|
| [Name] | Chief Executive Officer | _____________ | ______ |
| [Name] | IT Director/CISO | _____________ | ______ |
| [Name] | Legal Counsel | _____________ | ______ |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

**Note:** This policy template is derived from the Strategic Integration Framework for SMB Security (Master's dissertation research). Customize all bracketed fields [like this] with organization-specific information before deployment.
