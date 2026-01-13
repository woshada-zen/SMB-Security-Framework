# Remote Work Security Policy

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** IT Director / HR Manager
**Classification:** Internal

---

## 1. Purpose

This Remote Work Security Policy establishes security requirements for employees working from home, co-working spaces, or other remote locations to protect company data and systems from unauthorized access, disclosure, or loss.

## 2. Scope

This policy applies to:
- All employees working remotely (full-time remote, hybrid, or occasional)
- All contractors and temporary staff accessing company systems remotely
- Company-owned and personal (BYOD) devices used for remote work
- All locations outside company offices (home, coffee shops, hotels, client sites)

## 3. Remote Work Eligibility

### 3.1 Job Suitability

Remote work permitted for roles where:
- Job duties can be performed remotely without business impact
- Employee has demonstrated ability to work independently
- Role does not require physical presence (e.g., reception, facilities, lab work)
- Manager approves based on business needs

### 3.2 Security Requirements

**Mandatory for remote work approval:**
- Employee completes remote work security training
- Secure home internet connection available (minimum 10 Mbps)
- Private workspace where confidential calls can be conducted
- Agreement to comply with all security policies
- Company-managed device OR personal device enrolled in Intune

## 4. Device Requirements

### 4.1 Company-Owned Devices (Preferred)

**Laptop/Desktop:**
- Windows 10/11 Enterprise or macOS managed by Intune
- BitLocker (Windows) or FileVault (macOS) full disk encryption enabled
- Microsoft Defender for Endpoint installed and active
- Automatic updates enabled (security updates within 7 days)
- Standard user account (admin rights only when necessary)
- Screen lock: 10-minute inactivity timeout

**Mobile Devices:**
- Company-issued iPhone or Android enrolled in Intune
- Device passcode required (minimum 6 digits)
- Remote wipe capability enabled
- Corporate email and apps isolated in managed container
- Personal apps allowed but separated from work data

### 4.2 Personal Devices (BYOD)

**Eligibility:**
- Access to email and Microsoft 365 apps only (no VPN or full network access)
- Device must enroll in Intune Mobile Application Management (MAM)
- User consents to IT remote wipe of corporate data (not personal data)

**Security Requirements:**
- Operating system: Current version or previous version only
- Device encryption enabled
- Passcode/biometric lock (6-digit minimum)
- No jailbreak/root
- Work data segregated in managed apps (Outlook, Teams, OneDrive)

**Prohibited on BYOD:**
- VPN access to internal network
- Remote Desktop to company systems
- Access to Confidential or higher data (email only up to Internal classification)
- Installing company software outside managed app container

## 5. Network Security

### 5.1 Home Network Requirements

**Wireless Router Security:**
- Change default admin password to strong unique password
- Use WPA3 or WPA2 encryption (WEP prohibited)
- Disable WPS (Wi-Fi Protected Setup)
- Enable router firewall
- Keep router firmware updated
- Guest network for non-work devices (IoT, smart TVs, visitors)

**IT provides guide:** "Securing Your Home Wi-Fi Network" (see Appendix A)

### 5.2 Public Wi-Fi

**Allowed with Restrictions:**
- Coffee shops, hotels, airports, co-working spaces
- Use only for accessing Microsoft 365 (email, Teams, OneDrive)
- Always use VPN if available OR rely on HTTPS encryption

**Prohibited:**
- Processing Confidential or higher data on public Wi-Fi
- Accessing financial systems or customer databases
- Unencrypted connections (http:// sites)

**Best Practices:**
- Forget Wi-Fi network after use (prevent auto-reconnect)
- Disable file sharing and device discovery
- Use VPN for all internet traffic
- Use privacy screen on laptop (prevent visual eavesdropping)

### 5.3 VPN Usage

**VPN Required for:**
- Accessing on-premises systems (file servers, ERP, databases)
- Remote Desktop to company workstations
- Accessing Internal or Confidential data repositories

**VPN Not Required for:**
- Microsoft 365 apps (Exchange Online, SharePoint, Teams) - use direct internet
- Approved SaaS applications with SSO (CRM, project management)

**VPN Configuration:**
- Company-provided VPN client: [AnyConnect, FortiClient, Azure VPN, etc.]
- Split tunneling: Only company traffic through VPN (personal traffic direct)
- MFA required for VPN connection
- Automatic disconnect after 8 hours (re-authentication required)

## 6. Data Protection

### 6.1 Data Handling at Home

**Confidential and Higher Data:**
- Store only on OneDrive for Business or SharePoint (not local hard drive)
- Apply sensitivity labels to all documents
- Never save to personal cloud storage (Dropbox, Google Drive, personal OneDrive)
- Delete local copies when work session complete
- Encrypted USB drives only if absolutely necessary (approved by IT)

**Printing:**
- Minimize printing of confidential documents
- Use personal printer only (no shared printers at print shops)
- Shred confidential printouts when no longer needed (cross-cut shredder)
- Never leave printouts unattended

**Verbal Discussions:**
- Ensure privacy during confidential calls (no family members or roommates overhearing)
- Use headphones for video calls containing sensitive information
- Close doors/windows during confidential discussions
- Mute when not speaking to avoid accidental disclosure

### 6.2 Screen Privacy

**Visual Security:**
- Position workstation so screen not visible through windows
- Use privacy screen filter on laptop when in public spaces
- Lock screen (Windows+L or Ctrl+Cmd+Q) when stepping away
- Close blinds/curtains during video calls if home office visible

**Video Conferencing:**
- Use virtual background to hide home environment
- Ensure no confidential information visible in background (whiteboards, documents)
- Disable screen sharing when not actively presenting

## 7. Physical Security

### 7.1 Home Office Security

**Device Storage:**
- Store laptop in locked drawer or cabinet when not in use
- Keep devices out of sight from windows (prevent theft targeting)
- Use cable lock to secure laptop to desk (optional but recommended)

**Visitor Control:**
- Do not allow visitors (repair technicians, cleaners) access to unlocked devices
- Lock screen and put away confidential documents before visitors enter workspace
- Keep work devices separate from family members' devices

**Disposal:**
- Return company-owned devices to IT for secure data wiping (do not donate or sell)
- Contact IT before discarding any equipment (USB drives, hard drives, phones)

### 7.2 Lost or Stolen Devices

**Immediate Actions:**
- Report to IT Security within 1 hour: [phone/email]
- IT will remotely lock device via Intune
- If device not recovered within 4 hours, IT will remotely wipe
- Change password immediately
- Review account activity for unauthorized access

**Prevention:**
- Never leave laptop unattended in car (especially visible in backseat)
- Use laptop bag that doesn't obviously indicate laptop inside
- Enable "Find My Device" (Windows) or "Find My Mac" (macOS)

## 8. Communication and Collaboration

### 8.1 Approved Tools

**Company-Approved Only:**
- Email: Microsoft Outlook (Exchange Online)
- Chat/Meetings: Microsoft Teams
- File Sharing: OneDrive for Business, SharePoint
- Video Conferencing: Microsoft Teams OR [Zoom/Webex if approved]
- Project Management: [Approved tools only - e.g., Asana, Monday.com]

**Prohibited (Shadow IT):**
- Personal email for work communication (Gmail, Yahoo, personal Outlook.com)
- Unapproved file sharing (Dropbox, WeTransfer, Google Drive)
- Unapproved messaging apps (WhatsApp, Telegram for work)
- Personal video conferencing accounts (free Zoom, Google Meet)

### 8.2 Email Security

**Best Practices:**
- Apply sensitivity labels to emails containing confidential information
- Use "Do Not Forward" for sensitive emails
- Verify recipient email addresses before sending (beware typos, autocomplete)
- Encrypt emails to external recipients containing confidential data (automatic with sensitivity labels)
- Report phishing emails using "Report Phishing" button in Outlook

**Prohibited:**
- Sending company data to personal email accounts
- Using personal email for work-related communication
- Clicking links in unexpected emails (verify with sender first)
- Downloading attachments from unknown senders

### 8.3 Video Conferencing Security

**Meeting Best Practices:**
- Use waiting room for external participants (host admits individually)
- Disable "join before host" for confidential meetings
- Use meeting passwords for sensitive discussions
- Record meetings only with participant consent and business need
- Mute participants by default (host unmutes as needed)

**Screen Sharing:**
- Share specific application window (not entire desktop)
- Close email, chat, and confidential documents before sharing screen
- Disable notifications during screen sharing (Focus Assist on Windows)

## 9. Family and Household Members

**Separation of Work and Personal:**
- Do not allow family members to use company devices
- Do not share work passwords or VPN access
- Do not discuss confidential company information with household members
- Keep work devices password-protected (family members should not have access)

**Children and Dependents:**
- Supervise children around workspace to prevent accidental access to devices
- Lock screen when leaving desk (even briefly)
- Keep confidential documents out of children's reach

## 10. Travel Security

### 10.1 Domestic Travel

**Device Transport:**
- Carry laptop in carry-on luggage (never checked baggage)
- Keep devices with you at all times (do not leave in hotel room)
- Use hotel room safe for devices when leaving room

**Hotel Wi-Fi:**
- Use VPN for all work activities on hotel Wi-Fi
- Avoid open/unencrypted hotel networks
- Forget hotel Wi-Fi network when checking out

### 10.2 International Travel

**Restricted Locations:**
- High-risk countries (e.g., China, Russia): Special approval required from IT Director
- Consider travel-only device with minimal data (provided by IT)
- Assume all communications monitored in high-risk countries

**Border Crossings:**
- Backup data before travel (stored in OneDrive/SharePoint, not on device)
- If forced to unlock device at border, report to IT Security immediately upon arrival
- Consider using temporary device for high-risk destinations

**Encryption:**
- Ensure BitLocker/FileVault enabled before international travel
- Store recovery keys securely (in password manager or printed and secured)

## 11. Monitoring and Compliance

### 11.1 Monitoring

**Company reserves the right to monitor:**
- Email and chat communications (subject to local laws)
- Internet browsing on company devices
- Microsoft 365 activity logs
- VPN connections and network access
- Device compliance status (encryption, updates, antivirus)

**Privacy Expectations:**
- No expectation of privacy when using company devices or networks
- Personal devices (BYOD): Only work-related data and apps monitored
- Monitoring conducted for security, compliance, and productivity purposes

### 11.2 Device Compliance Checks

**Automated (Daily):**
- Intune checks device compliance status
- Non-compliant devices blocked from accessing email and company data
- Common compliance failures: Outdated OS, missing encryption, no antivirus

**Manual (Quarterly):**
- IT reviews remote access logs for unusual patterns
- Review devices not checking in with Intune (lost/stolen detection)

## 12. Incident Reporting

**Immediate Reporting Required (within 1 hour) for:**
- Lost or stolen device
- Suspected malware infection
- Phishing email where credentials entered
- Unauthorized access to account
- Data spill (accidental disclosure of confidential data)
- Family member accessed work device

**Reporting Channels:**
- IT Help Desk: [phone/email]
- Security Incidents: [security@company.com]
- After Hours: [on-call phone number]

**Protection from Retaliation:**
- Prompt reporting may mitigate consequences
- No disciplinary action for good-faith reporting of incidents

## 13. Remote Work Equipment

### 13.1 Company-Provided Equipment

**Standard Remote Work Setup:**
- Laptop (Windows or macOS)
- Docking station (if requested)
- External monitor (if requested and role requires)
- Keyboard and mouse (if requested)
- Headset for video calls

**Request Process:**
- Submit IT ticket with equipment needs and business justification
- Manager approval required for equipment >$500
- Equipment delivered to home address or picked up at office

**Maintenance:**
- IT provides remote support for troubleshooting
- Defective equipment: Return to office for replacement OR IT ships replacement
- User responsible for care and reasonable protection from damage

### 13.2 Return of Equipment

**Upon Termination or Return to Office:**
- Return all company equipment within 7 days
- IT provides prepaid shipping label OR schedule pick-up
- Equipment must be in reasonable condition (normal wear acceptable)
- Failure to return: Deducted from final paycheck (if legal in jurisdiction)

## 14. Manager Responsibilities

**Managers of remote workers must:**
- Ensure employees complete remote work security training
- Verify employee has suitable workspace and internet connection
- Approve remote work arrangement based on business needs
- Conduct regular check-ins for performance and wellbeing
- Report security concerns to IT Security
- Review and approve equipment requests

## 15. IT Department Responsibilities

- Provision and configure company devices for remote work
- Provide VPN access and technical support
- Monitor device compliance and enforce policies
- Respond to security incidents and lost/stolen devices
- Conduct quarterly security audits of remote access
- Provide user training and documentation

## 16. Policy Violations

- Failure to enroll device in Intune: Access blocked
- Using unapproved software/services: Written warning
- Sharing credentials or allowing family to use device: Disciplinary action
- Intentional policy violations: Termination and potential legal action

---

## Appendices

### Appendix A: Securing Your Home Wi-Fi Network

**Step-by-Step Guide:**
1. Change router admin password (default passwords easily guessed)
2. Set Wi-Fi password (minimum 12 characters, unique)
3. Enable WPA3 or WPA2-AES encryption
4. Disable WPS (Wi-Fi Protected Setup)
5. Update router firmware (check manufacturer website)
6. Enable router firewall
7. Create guest network for visitors and IoT devices

### Appendix B: Device Setup Checklist

**For Company-Owned Laptops:**
- [ ] BitLocker/FileVault encryption verified
- [ ] Microsoft Defender for Endpoint installed
- [ ] Automatic updates enabled
- [ ] Screen lock set to 10-minute timeout
- [ ] VPN client installed (if applicable)
- [ ] Password manager installed
- [ ] User completed security training

**For BYOD Devices:**
- [ ] Device enrolled in Intune MAM
- [ ] Device encryption enabled
- [ ] Passcode/biometric lock configured
- [ ] Microsoft Outlook, Teams, OneDrive apps installed (managed versions)
- [ ] User acknowledged consent for remote wipe of work data

### Appendix C: Remote Work Security Tips

**Quick Reference Card:**

**Devices:**
- ✓ Lock screen when away (Windows+L)
- ✓ Keep software updated
- ✓ Use company devices for work (not personal devices)

**Network:**
- ✓ Secure home Wi-Fi (WPA2/WPA3)
- ✓ Use VPN on public Wi-Fi
- ✓ Avoid public computers (internet cafes, hotel business centers)

**Data:**
- ✓ Save files to OneDrive/SharePoint (not local drive)
- ✓ Apply sensitivity labels
- ✓ Never email confidential data to personal email

**Physical:**
- ✓ Position screen away from windows
- ✓ Shred confidential printouts
- ✓ Lock screen during video calls if needed

**Communication:**
- ✓ Use Microsoft Teams for meetings
- ✓ Verify email recipients before sending
- ✓ Report phishing emails

### Appendix D: Home Office Setup Recommendations

**Ergonomics and Security:**
- Dedicated workspace separate from family areas
- Position desk so screen not visible from windows or by visitors
- Adequate lighting (reduces eye strain)
- External monitor at eye level (reduces neck strain)
- Ergonomic keyboard and mouse
- Cable lock to secure laptop to desk

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

**Note:** This Remote Work Security Policy template is derived from the Strategic Integration Framework for SMB Security. Customize based on your organization's remote work model, industry, and risk tolerance.
