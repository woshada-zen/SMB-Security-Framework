# Incident Response Plan

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** IT Director / Security Team Lead
**Classification:** Confidential

---

## 1. Purpose and Scope

This Incident Response Plan establishes procedures for detecting, responding to, and recovering from cybersecurity incidents. The plan ensures timely and effective response to minimize business impact and meet regulatory notification requirements (GDPR 72-hour breach notification).

**Scope:** All security incidents affecting [Company Name]'s information systems, data, networks, and endpoints.

## 2. Incident Classification

### 2.1 Severity Levels

| Severity | Impact | Response Time | Examples |
|----------|--------|---------------|----------|
| **Critical (P1)** | Business-critical systems down, active data breach, ransomware | Immediate (15 min) | Ransomware encryption, data exfiltration, complete system compromise |
| **High (P2)** | Significant impact, potential data exposure, widespread malware | 1 hour | Targeted phishing campaign, privilege escalation, failed backup |
| **Medium (P3)** | Limited impact, isolated incidents, policy violations | 4 hours | Single malware infection, suspicious login, minor data loss |
| **Low (P4)** | Minimal impact, informational, routine events | 24 hours | Phishing email reported, failed login attempts, policy inquiry |

### 2.2 Incident Categories

1. **Data Breach** - Unauthorized access to or exfiltration of confidential/personal data
2. **Ransomware** - Malicious encryption of files with ransom demand
3. **Malware Infection** - Virus, trojan, spyware, or other malicious software
4. **Phishing/Social Engineering** - Credential theft attempts or social manipulation
5. **Denial of Service** - Attacks rendering systems or networks unavailable
6. **Insider Threat** - Malicious or negligent actions by employees/contractors
7. **Lost/Stolen Device** - Mobile device or laptop containing company data
8. **Account Compromise** - Unauthorized access to user or admin accounts
9. **Physical Security Breach** - Unauthorized physical access to facilities
10. **Third-Party Breach** - Security incident at vendor affecting company data

## 3. Incident Response Team (IRT)

### 3.1 Core Team Members

| Role | Name | Primary Contact | Backup Contact | Responsibilities |
|------|------|-----------------|----------------|------------------|
| **Incident Commander** | [Name] | [Phone/Email] | [Phone/Email] | Overall coordination, executive reporting |
| **Technical Lead** | [Name] | [Phone/Email] | [Phone/Email] | Technical analysis, containment, eradication |
| **Communications Lead** | [Name] | [Phone/Email] | [Phone/Email] | Internal/external communications, user notifications |
| **Legal Counsel** | [Name] | [Phone/Email] | [Phone/Email] | Legal compliance, regulatory notifications |
| **HR Representative** | [Name] | [Phone/Email] | [Phone/Email] | Employee matters, insider threats |
| **Executive Sponsor** | [Name] | [Phone/Email] | [Phone/Email] | Executive decisions, resource allocation |

### 3.2 Extended Team (as needed)

- **Forensics Specialist** - [External provider or internal if available]
- **PR/Media Relations** - [Name/Agency]
- **Insurance Broker** - [Company] for cyber insurance claims
- **External Legal** - [Law firm] for complex legal matters
- **Microsoft Support** - Premier support contact

### 3.3 Escalation Path

Low (P4) → Medium (P3) → High (P2) → Critical (P1) → Executive Management → Board of Directors (if material impact)

## 4. Incident Response Process (6 Phases)

### Phase 1: Preparation (Ongoing)

**Activities:**
- Maintain incident response tools and playbooks
- Conduct quarterly tabletop exercises
- Update contact lists monthly
- Review and test backup/recovery procedures
- Train IRT members on roles and procedures
- Maintain forensics toolkit and evidence storage

**Tools:**
- Microsoft 365 Defender portal: https://security.microsoft.com
- Azure Sentinel workspace: [workspace name]
- Incident response documentation: [SharePoint location]
- Communication channels: Microsoft Teams IRT channel

### Phase 2: Detection and Identification (0-30 minutes)

**Detection Sources:**
- Microsoft Defender alerts (endpoints, cloud apps, email)
- Azure Sentinel analytics rules (20 pre-configured detections)
- User reports (phishing, suspicious activity)
- Third-party vendor notifications
- Audit log reviews
- Help desk tickets

**Initial Actions:**
1. **Log incident** in incident tracking system (Azure Sentinel or ticketing system)
2. **Assign severity** based on classification table (Section 2.1)
3. **Notify Incident Commander** immediately for P1/P2, per SLA for P3/P4
4. **Preserve evidence** - capture logs, screenshots, memory dumps
5. **Document** all actions with timestamps in incident log

**Initial Assessment Questions:**
- What happened? (description of incident)
- When was it discovered? What is the timeline?
- What systems/data are affected?
- Is the threat still active?
- What is the business impact?
- Are backups available and uncompromised?

### Phase 3: Containment (30 min - 4 hours)

**Short-term Containment (immediately):**
- **Isolate affected devices** - Disconnect from network OR use Defender "Isolate device" action
- **Disable compromised accounts** - Revoke sessions, reset passwords, disable sign-in
- **Block malicious IPs/domains** - Update firewall rules, Conditional Access policies
- **Quarantine malicious emails** - Delete from all mailboxes (Threat Explorer)
- **Preserve evidence** - Create forensic images before remediation

**Long-term Containment (1-4 hours):**
- **Apply temporary fixes** - Patch vulnerable systems, update signatures
- **Implement monitoring** - Increase logging, add detection rules
- **Segment network** - Isolate affected segments to prevent lateral movement
- **Enhance authentication** - Force MFA re-enrollment, implement stronger Conditional Access
- **Communicate status** - Update stakeholders, users (if appropriate)

**Decision Point:** Can business operations continue with containment measures in place?
- **Yes** → Proceed to eradication while maintaining operations
- **No** → Escalate to executive team for business continuity activation

### Phase 4: Eradication (4-24 hours)

**Objectives:**
- Remove malware, unauthorized access, and attacker persistence mechanisms
- Eliminate root cause of incident
- Verify threat actor has been expelled from environment

**Actions:**
1. **Remove malware** - Use Defender automated investigation & remediation OR manual removal
2. **Delete unauthorized accounts** - Remove backdoor accounts, reset all credentials
3. **Patch vulnerabilities** - Apply security updates that were exploited
4. **Rebuild compromised systems** - Reimage from known-good backups OR clean OS install
5. **Reset credentials** - Force password reset for all potentially affected accounts
6. **Review configurations** - Remove unauthorized firewall rules, scheduled tasks, registry keys
7. **Scan for persistence** - Check startup items, services, WMI subscriptions, GPOs

**Validation:**
- Run full antivirus scans on all systems
- Review logs for 48 hours for signs of re-infection
- Verify all IOCs (Indicators of Compromise) are absent
- Conduct vulnerability scan to confirm patches applied

### Phase 5: Recovery (1-5 days)

**Objectives:**
- Restore systems to normal operations
- Verify business functionality
- Monitor for recurrence

**Actions:**
1. **Restore from backups** (if needed) - Verify backup integrity, restore to isolated environment, scan before production
2. **Reconnect systems** - Gradually restore network connectivity with monitoring
3. **Enable accounts** - Restore user access with new credentials
4. **Validate functionality** - Test critical business processes
5. **Enhanced monitoring** - 30-day heightened monitoring period
6. **User communication** - Inform users of restoration and any required actions

**Recovery Validation Checklist:**
- [ ] All affected systems operational
- [ ] Critical business processes tested and functional
- [ ] Enhanced monitoring in place (30-day period)
- [ ] All credentials reset and MFA verified
- [ ] Vulnerability patches confirmed installed
- [ ] Backup integrity verified
- [ ] No suspicious activity for 48 hours

### Phase 6: Post-Incident Review (5-10 days after resolution)

**Lessons Learned Meeting (within 7 days of closure):**
- **Attendees:** Full IRT, affected business units, executive sponsor
- **Duration:** 90 minutes
- **Facilitator:** Incident Commander (or neutral party for complex incidents)

**Discussion Topics:**
1. What happened? (incident timeline and root cause)
2. What went well? (effective response actions)
3. What could be improved? (gaps and deficiencies)
4. What did we learn? (new threats, attack vectors, business impacts)
5. What actions will we take? (remediation items with owners and deadlines)

**Post-Incident Report Contents:**
- Executive summary (1 page)
- Incident timeline (detailed sequence of events)
- Root cause analysis (5 Whys or fishbone diagram)
- Impact assessment (systems affected, data exposure, downtime, costs)
- Response effectiveness (what worked, what didn't)
- Remediation actions (closed-loop corrective actions)
- Recommendations (preventive measures, policy updates, training needs)

**Improvement Actions:**
- Update incident response procedures based on lessons learned
- Implement preventive controls to avoid recurrence
- Conduct targeted training for users or IT staff
- Update detection rules and playbooks
- Present findings to executive management
- Archive all incident documentation

## 5. Communication Procedures

### 5.1 Internal Communications

| Audience | Timing | Method | Message Content |
|----------|--------|--------|-----------------|
| **Incident Response Team** | Immediately | Microsoft Teams, SMS | Incident alert, severity, initial instructions |
| **Executive Management** | P1: Immediate<br>P2: 1 hour<br>P3: 4 hours | Phone + Email | Impact, status, actions taken, ETA for resolution |
| **Affected Users** | As needed | Email, Teams | Service disruption, required actions (password reset), timeline |
| **All Staff** | If widespread impact | Email, intranet | General awareness, protective measures, status updates |
| **IT Department** | As needed | Email, Teams | Technical details, assistance requests |

### 5.2 External Communications

| Audience | Timing | Requirement | Responsible Party |
|----------|--------|-------------|-------------------|
| **Regulatory Authorities** (GDPR) | Within 72 hours of breach discovery | Data Protection Authority notification | Legal Counsel |
| **Affected Customers/Partners** | Without undue delay (GDPR) | Data breach notification | Communications Lead + Legal |
| **Cyber Insurance Provider** | Within policy notification period (typically 24-48 hours) | Claim notification | Executive Sponsor |
| **Law Enforcement** | As appropriate for criminal activity | Incident report | Legal Counsel + Incident Commander |
| **Media** (if required) | As needed | Press release, statement | PR/Communications (pre-approved messaging) |
| **Third-Party Vendors** | If vendor systems affected | Incident details, required actions | Technical Lead |

**GDPR Breach Notification Template:** [Link to template in /Templates folder]

**Communication Principles:**
- **Accuracy** - Provide factual information only, no speculation
- **Transparency** - Be honest about impact and timeline
- **Consistency** - Ensure all spokespersons use same messaging
- **Timeliness** - Meet regulatory deadlines, communicate proactively
- **Confidentiality** - Limit technical details that could aid attackers

### 5.3 Communication Approval

- **Internal (employees):** Incident Commander approval
- **External (customers, partners):** Legal Counsel + Executive Sponsor approval
- **Media/Public:** Legal Counsel + PR + CEO approval
- **Regulatory:** Legal Counsel approval (mandatory notifications)

## 6. Evidence Collection and Forensics

### 6.1 Evidence Handling Procedures

**Chain of Custody Requirements:**
- Document who collected evidence, when, and from where
- Maintain evidence log with timestamps
- Store in secure location with restricted access
- Use write-blockers for disk imaging
- Calculate and record hash values (SHA-256)

**Types of Evidence:**
- **Disk images** - Full forensic copies of affected systems
- **Memory dumps** - Volatile memory capture
- **Log files** - Security logs, event logs, network logs, application logs
- **Network captures** - Packet captures (pcap files)
- **Screenshots** - Visual evidence of alerts, malicious activity
- **Email messages** - Phishing emails, suspicious communications
- **Malware samples** - Quarantined files, suspicious executables

**Storage:**
- Location: [Secure file share or evidence locker]
- Retention: 2 years minimum (longer if legal proceedings)
- Access: IRT members only, logged access

### 6.2 Forensics Tools

- **Microsoft 365 Defender:** Automated investigation, threat hunting
- **Azure Sentinel:** Log aggregation, query (KQL), workbooks
- **Sysinternals Suite:** Process Explorer, Autoruns, TCPView
- **FTK Imager:** Disk imaging and evidence collection
- **Wireshark:** Network traffic analysis
- **External Forensics Provider:** [Company name] for complex incidents

## 7. Incident-Specific Playbooks

### 7.1 Ransomware Response

1. **Immediate Actions (0-15 min):**
   - Isolate all affected devices immediately (disconnect network)
   - Identify patient zero (initial infection source)
   - Identify ransomware variant (ransom note, file extensions)
   - Notify executive management immediately (P1 incident)

2. **Containment (15-60 min):**
   - Disable all admin accounts temporarily
   - Block file shares and mapped drives
   - Shut down backup systems to prevent encryption
   - Identify all affected systems (domain controllers, servers, workstations)

3. **Eradication & Recovery (1-5 days):**
   - DO NOT pay ransom without legal/executive approval
   - Consult external ransomware specialists
   - Restore from offline/immutable backups (verify backup integrity first)
   - Rebuild domain controllers if compromised
   - Scan all systems before reconnecting

4. **Post-Incident:**
   - Review backup procedures (offline, immutable backups)
   - Implement application allowlisting (consider AppLocker)
   - Enhanced email filtering and ASR rules

### 7.2 Phishing Campaign Response

1. **Detection:** User reports phishing email OR Microsoft Defender detects campaign
2. **Containment:**
   - Use Threat Explorer to identify all recipients
   - Delete email from all mailboxes (soft delete with recovery option)
   - Block sender domain/IP in Exchange Online Protection
3. **Credential Harvesting:**
   - If credentials entered: Force password reset, revoke sessions, review sign-in logs
4. **Communication:** Send phishing awareness email to all users

### 7.3 Account Compromise Response

1. **Detection:** Impossible travel, suspicious sign-ins, user report
2. **Containment:**
   - Disable account immediately
   - Revoke all active sessions
   - Reset password (admin-initiated, do not allow self-service)
3. **Investigation:**
   - Review sign-in logs (IP addresses, locations, devices)
   - Check mail forwarding rules, inbox rules, delegates
   - Review email sent from compromised account (potential BEC)
   - Check for MFA fatigue or social engineering
4. **Recovery:**
   - Re-enable account after verification with user
   - Force MFA re-enrollment (delete old MFA methods)
   - Monitor account for 30 days

### 7.4 Data Breach Response

1. **Assess Scope:**
   - What data was accessed/exfiltrated? (sensitivity classification)
   - How many records? Personal data (GDPR), financial, health?
   - Who accessed it? (insider vs external threat actor)
2. **Legal Notification (GDPR):**
   - Within 72 hours: Notify Data Protection Authority
   - Without undue delay: Notify affected individuals (if high risk)
3. **Containment:**
   - Revoke access to affected data repositories
   - Enhanced monitoring on affected systems
4. **Post-Incident:**
   - Review DLP policies and access controls
   - Consider credit monitoring for affected individuals (if PII)

### 7.5 Lost/Stolen Device Response

1. **User Reports Loss (immediate):**
   - Attempt device location (Find My Device)
   - Remotely lock device via Intune
2. **If Cannot Be Recovered (4 hours):**
   - Initiate remote wipe via Intune
   - Change user's password
   - Review recent activity from device
3. **Assess Data Exposure:**
   - Was device encrypted? (BitLocker, FileVault)
   - What data was on device? (cached emails, files)
   - Was device PIN/password protected?
4. **Notification:**
   - If unencrypted Confidential data: escalate to data breach response

## 8. Regulatory and Legal Requirements

### 8.1 GDPR Data Breach Notification

**72-Hour Notification Requirement:**
- Start clock: When organization becomes "aware" of breach (not discovery time)
- Data Protection Authority: [Country-specific DPA]
- Notification Portal: [URL or email]
- Required Information:
  - Nature of breach (categories and approximate number of data subjects)
  - Contact point for more information (DPO or representative)
  - Likely consequences of breach
  - Measures taken or proposed to address breach

**Individual Notification (if high risk):**
- Timing: Without undue delay
- Method: Email, letter, or public communication
- Content: Describe breach in clear language, provide protective measures

**Documentation:**
- Maintain register of all breaches (even if not notified)
- Document reasoning if breach not notified
- Keep records for audit/review

### 8.2 Other Regulatory Requirements

- **ePrivacy Directive:** Cookie consent breaches
- **PCI DSS:** Payment card data breaches (notify acquirer, card brands within 24 hours)
- **NIS Directive (UK):** Essential service providers (telecoms, finance, healthcare)
- **Sector-Specific:** Healthcare (HIPAA if applicable), Financial Services

### 8.3 Cyber Insurance Claims

- Notify insurer within policy period (typically 24-48 hours)
- Preserve evidence for claims investigation
- Document all costs (forensics, legal, notification, credit monitoring)
- Coordinate with insurer before engaging external vendors

## 9. Testing and Training

### 9.1 Tabletop Exercises (Quarterly)

- **Participants:** Full IRT + business unit representatives
- **Duration:** 2 hours
- **Scenarios:** Rotate through incident types (ransomware, breach, phishing)
- **Objectives:** Test procedures, identify gaps, build muscle memory
- **Documentation:** After-action report with improvement items

**Sample Scenarios:**
- Scenario 1: Ransomware encryption of file server during business hours
- Scenario 2: Credential phishing targeting finance team (wire fraud attempt)
- Scenario 3: Data breach - unauthorized access to customer database
- Scenario 4: Insider threat - employee downloading large volumes of data before resignation

### 9.2 Annual Full-Scale Exercise

- **Scope:** Full incident simulation including communication, legal, PR
- **Duration:** Half-day
- **External Participants:** Legal, PR, insurance, forensics provider
- **Objectives:** End-to-end process validation, stakeholder coordination
- **Deliverable:** Comprehensive after-action report to executive management

### 9.3 IRT Training

- **New Member Onboarding:** Within 30 days of joining IRT
- **Annual Refresher:** Review procedures, tools, contact lists
- **Role-Specific Training:**
  - Technical leads: Microsoft 365 Defender, Azure Sentinel, forensics tools
  - Communications: Crisis communication, media training
  - Legal: GDPR, breach notification, evidence handling

## 10. Metrics and Reporting

### 10.1 Key Incident Metrics

- **Mean Time to Detect (MTTD):** Time from incident occurrence to detection
- **Mean Time to Respond (MTTR):** Time from detection to containment
- **Mean Time to Resolve (MTTR):** Time from detection to full resolution
- **Number of Incidents:** By severity, by category, trends over time
- **False Positive Rate:** Alerts investigated vs. confirmed incidents

**Target SLAs:**
- P1 Detection: 15 minutes
- P1 Response: 30 minutes
- P2 Response: 1 hour
- P3 Response: 4 hours

### 10.2 Monthly Reporting

- **Audience:** IT Director, Executive Management
- **Content:**
  - Incident summary (count by severity and category)
  - Response time metrics vs. SLAs
  - Trends and patterns
  - Top attack vectors
  - Improvement actions completed

### 10.3 Annual Review

- **Audience:** Board of Directors
- **Content:**
  - Year-over-year incident trends
  - Major incidents and lessons learned
  - IR program maturity improvements
  - Industry benchmarking
  - Investment recommendations

## 11. Plan Maintenance

- **Review Frequency:** Annually or after major incidents
- **Update Triggers:** Organizational changes, technology changes, regulatory updates
- **Approval:** IT Director + Legal Counsel + Executive Sponsor
- **Distribution:** All IRT members, executive management, legal, HR
- **Testing:** Quarterly tabletop exercises validate plan effectiveness

---

## Appendices

### Appendix A: Contact Lists
- IRT Contact Card (wallet card with all IRT member contacts)
- Vendor Contact List (Microsoft support, forensics, insurance, legal)

### Appendix B: Incident Log Template
- Incident tracking form with required fields

### Appendix C: Communication Templates
- GDPR breach notification template
- User notification email templates
- Executive status update template
- Press release template

### Appendix D: Compliance Checklists
- GDPR breach assessment checklist
- Evidence collection checklist
- Recovery validation checklist

### Appendix E: Tools and Access
- Microsoft 365 Defender portal access
- Azure Sentinel workspace details
- Forensics toolkit location
- Evidence storage location

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

**Note:** This Incident Response Plan template is derived from the Strategic Integration Framework for SMB Security. Test this plan through tabletop exercises before relying on it in a real incident. Customize contact lists, legal requirements, and procedures to match your organization's structure and regulatory environment.
