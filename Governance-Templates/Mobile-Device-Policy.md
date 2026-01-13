# Mobile Device Policy

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** IT Director
**Classification:** Internal

---

## 1. Purpose

This Mobile Device Policy establishes requirements for secure use of smartphones, tablets, and wearables to access [Company Name]'s email, applications, and data. The policy aims to protect company information while respecting employee privacy.

## 2. Scope

This policy applies to:
- **Company-Owned Devices:** Smartphones and tablets issued by the company
- **BYOD (Bring Your Own Device):** Personal devices used to access company email or applications
- **All Users:** Employees, contractors, and temporary staff
- **All Platforms:** iOS (iPhone/iPad), Android, Windows Phone (if applicable)

## 3. Device Types and Management Approaches

### 3.1 Company-Owned Devices (Fully Managed)

**Provisioning:**
- Issued by IT Department upon request and manager approval
- Enrolled in Microsoft Intune Mobile Device Management (MDM)
- Pre-configured with company apps and security policies
- Cellular plan paid by company (with usage guidelines)

**Management:**
- Full device management (IT can view inventory, apps, enforce policies)
- Remote wipe capability (entire device, including personal data if present)
- App deployment via Intune Company Portal
- Device compliance policies enforced

**Acceptable Use:**
- Primary purpose: Business communication and productivity
- Limited personal use permitted (calls, texts, personal apps during breaks)
- Personal data storage discouraged (use personal device for photos, personal apps)
- Company retains ownership; device must be returned upon termination

### 3.2 BYOD - Personal Devices (App Management Only)

**Enrollment:**
- Voluntary enrollment to access company email on personal device
- Microsoft Intune Mobile Application Management (MAM) only
- Company manages only work apps and data (Outlook, Teams, OneDrive)
- Personal apps and data remain private (IT cannot see or control)

**Management:**
- Work apps isolated in "managed container"
- Selective wipe: Only work data removed (personal data untouched)
- Limited device compliance requirements (OS version, encryption, passcode)
- No access to personal photos, location, browser history, or personal apps

**User Consent:**
- User explicitly consents to:
  - Device compliance checks (encryption, OS version)
  - Selective wipe of work data if device lost or employee leaves
  - Work app usage monitoring (but not personal app usage)
- User can unenroll at any time (loses access to company email)

**BYOD Reimbursement:**
- Company may provide monthly stipend for BYOD users: $[amount] (if applicable)
- Stipend covers partial cost of cellular plan and device

## 4. Security Requirements

### 4.1 Device Passcode/Biometric Lock

**Required for All Devices (Company and BYOD):**
- Passcode: Minimum 6 digits OR alphanumeric password
- Biometric: Face ID, Touch ID, fingerprint (acceptable alternative to passcode)
- Lock timeout: Maximum 5 minutes of inactivity
- Failed passcode attempts: Device wipes after 10 failed attempts (configurable)
- Passcode complexity: Simple passcodes (1234, 0000) prohibited by policy

**Enforcement:**
- Non-compliant devices blocked from accessing email within 24 hours
- User notified via email to fix compliance issue

### 4.2 Device Encryption

**Required:**
- iOS: Encryption enabled by default when passcode set (iPhone 3GS and later)
- Android: Enable "Encrypt Device" in Security settings (Android 6.0+ encrypted by default)
- Enforced via Intune compliance policy

**Purpose:**
- Protects data at rest if device is lost or stolen
- Required for GDPR personal data protection

### 4.3 Operating System Requirements

**Supported OS Versions:**
- iOS: Current version or previous major version (e.g., if iOS 17 is current, iOS 16 acceptable)
- Android: Android 11 or newer (maximum 3 years old)

**Rationale:**
- Older OS versions have unpatched security vulnerabilities
- Ensures compatibility with Intune and company apps

**Automatic Updates:**
- Company devices: Automatic updates enforced
- BYOD: Strongly recommended (user choice, but non-compliant if outdated)

### 4.4 Jailbreak/Root Detection

**Prohibited:**
- Jailbroken iOS devices (modified to bypass Apple restrictions)
- Rooted Android devices (modified to gain superuser access)

**Consequence:**
- Detected jailbreak/root: Immediate block from email access
- User must factory reset device to remove jailbreak before re-enrolling

**Rationale:**
- Jailbreaking bypasses security controls
- Enables malware and unauthorized apps
- Violates device warranty and security posture

### 4.5 Antivirus/Antimalware

**iOS:**
- Not required (iOS sandboxing prevents malware spread)
- No antivirus apps needed (Apple's walled garden approach)

**Android:**
- Google Play Protect enabled by default (acceptable)
- Optional: Approved antivirus app (Microsoft Defender, Lookout Mobile Security)
- Company-owned Android: Microsoft Defender for Endpoint installed

### 4.6 App Installation Restrictions

**Company-Owned Devices:**
- Apps must be installed from Company Portal or approved by IT
- App Store/Google Play access restricted to approved apps list (configurable)
- High-risk apps blocked (gambling, adult content, hacking tools)

**BYOD:**
- No restrictions on personal apps (IT cannot control)
- Work apps must be downloaded from Intune Company Portal
- Work apps cannot share data with unapproved personal apps

## 5. Approved Applications

### 5.1 Mandatory Work Apps (Company-Owned Devices)

- **Email:** Microsoft Outlook (Exchange Online)
- **Chat/Meetings:** Microsoft Teams
- **File Access:** OneDrive for Business
- **Authenticator:** Microsoft Authenticator (for MFA)
- **Productivity:** Microsoft Office apps (Word, Excel, PowerPoint)

### 5.2 Optional Work Apps (Deployed via Company Portal)

- CRM Mobile App: [Salesforce, Dynamics]
- Project Management: [Approved apps]
- Expense Reporting: [Approved apps]
- Company Intranet App

### 5.3 Prohibited Apps (Company-Owned Devices)

- Unapproved file-sharing apps (Dropbox, WeTransfer)
- Unapproved messaging apps for work (WhatsApp, Telegram - unless business-approved)
- Torrenting or file-sharing apps
- Apps from untrusted sources (sideloading on Android)

## 6. Data Protection

### 6.1 Email and Calendar

**Configuration:**
- Email sync: Last 30 days (reduces data stored on device)
- Attachments: Open in managed apps only (Outlook, Word, Excel)
- Email forwarding: Blocked to personal email accounts
- Copy/paste: Restricted from work apps to personal apps

**Sensitivity Labels:**
- Applied automatically based on email content (DLP policies)
- Encrypted emails: Can only be read in Outlook app (not native Mail app)
- "Do Not Forward" emails: Cannot be forwarded, copied, or printed

### 6.2 File Storage

**OneDrive for Business:**
- Work files must be saved to OneDrive (not device local storage)
- Offline access: Available for marked files (encrypted on device)
- Sharing: Same controls as desktop (sensitivity labels, DLP enforced)

**Prohibited:**
- Saving company files to personal cloud storage (Google Drive, personal OneDrive, iCloud Drive)
- Storing Confidential or higher data in device photo gallery
- Emailing company files to personal email for offline access

### 6.3 Screenshots and Screen Recording

**Restrictions:**
- Screenshots blocked in work apps containing Confidential+ data
- Screen recording blocked in Microsoft Outlook, OneDrive (configurable)
- Applies to company-owned and BYOD enrolled devices

## 7. Lost or Stolen Devices

### 7.1 User Responsibilities

**Immediate Reporting (within 1 hour):**
- Report to IT Security: [phone/email]
- Provide: Device type, phone number, last known location
- If device contains Confidential or higher data: Escalate to P1 incident

### 7.2 IT Response

**Step 1: Locate (0-30 minutes):**
- Attempt device location via Intune or Find My Device (iOS/Android)
- Send lock message to device: "This device is lost. Please contact [phone]"
- Remotely lock device (prevent unauthorized access)

**Step 2: Wipe (if not recovered within 4 hours):**
- **Company-Owned:** Full device wipe (all data erased)
- **BYOD:** Selective wipe (only work apps and data removed, personal data preserved)
- User notified of wipe action via email

**Step 3: Account Protection:**
- Force password reset for user account
- Review recent email activity for unauthorized access
- Revoke device from "trusted devices" list

**Device Recovery:**
- If device recovered after wipe: Re-enroll and reconfigure
- If device found by third party: Do not accept device back (security risk), replace

## 8. Personal Use Guidelines

### 8.1 Company-Owned Devices

**Allowed Personal Use:**
- Personal phone calls and text messages (reasonable volume)
- Personal apps (social media, banking, games) during non-work hours
- Personal photos (limited, use personal device preferred)

**Prohibited Personal Use:**
- Excessive personal calls interfering with work
- Illegal activities (piracy, gambling, adult content)
- Sharing device with family members
- Using for personal business or side gigs

**Monitoring Disclaimer:**
- Company reserves right to monitor all device usage (calls, texts, apps, location)
- No expectation of privacy on company-owned devices

### 8.2 BYOD

**Personal Use:**
- Unlimited personal use (company does not monitor personal apps or usage)
- Work apps and data isolated from personal apps

**Privacy Assurance:**
- Company cannot see personal photos, messages, browser history, or personal app usage
- Location services only used for work app features (e.g., map directions in Teams)

## 9. International Travel

### 9.1 Pre-Travel

- Notify IT if traveling to high-risk countries (e.g., China, Russia)
- Consider using travel-only device (provided by IT for high-risk destinations)
- Backup work data to OneDrive/SharePoint before travel (not on device)

### 9.2 During Travel

- Avoid public Wi-Fi for accessing company email (use cellular data)
- If forced to unlock device at border, report to IT immediately upon arrival
- Assume all communications monitored in high-risk countries

### 9.3 Data Roaming

**Company-Owned Devices:**
- International roaming enabled (company pays charges)
- Excessive data usage (>5GB/month) requires explanation

**BYOD:**
- User responsible for international roaming charges
- Use Wi-Fi calling or download data offline before travel

## 10. Compliance and Enforcement

### 10.1 Device Compliance Checks

**Automated (Daily):**
- Intune checks device compliance status
- Non-compliant devices: 24-hour grace period to remediate, then blocked

**Common Compliance Failures:**
- OS version outdated (more than 60 days behind)
- Passcode not set or too weak
- Device encryption not enabled
- Jailbreak/root detected

**Remediation:**
- User receives notification email with instructions
- Access to email blocked until compliance restored
- If not fixed within 7 days: Device unenrolled, data wiped

### 10.2 Access Reviews

**Quarterly:**
- IT reviews all enrolled devices
- Remove devices not active in 60 days (likely lost, stolen, or replaced)
- Verify terminated employees' devices wiped

### 10.3 Policy Violations

- Jailbreaking/rooting device: Access revoked, written warning
- Sharing device with family: Disciplinary action
- Failure to report lost/stolen device: Coaching and re-training
- Intentional data exfiltration: Termination and potential legal action

## 11. Device Replacement and Refresh

### 11.1 Company-Owned Devices

**Replacement Cycle:**
- Standard refresh: Every 3 years
- Early replacement: Device defective or significantly damaged
- Request process: Submit IT ticket with justification

**Device Return:**
- Upon termination or device refresh: Return to IT within 7 days
- IT wipes device and refurbishes or disposes securely
- User data backed up to OneDrive (user responsible for backup before return)

### 11.2 BYOD

**Personal Device Upgrade:**
- User replaces device: Unenroll old device, enroll new device via Company Portal
- IT provides enrollment instructions for new device
- Selective wipe on old device before selling or trading in

## 12. Support and Training

### 12.1 IT Support

**Available Support:**
- Device enrollment and configuration assistance
- Troubleshooting email, Teams, OneDrive sync issues
- Password resets and MFA issues
- Lost/stolen device response

**Not Supported:**
- Personal app troubleshooting (BYOD)
- Physical device repair (refer to manufacturer or carrier)
- Personal email or cloud storage issues

**Support Channels:**
- IT Help Desk: [phone/email]
- Self-Service: Knowledge base articles in Company Portal
- Emergency (after hours): [on-call number for lost/stolen devices]

### 12.2 User Training

**Mandatory Training:**
- Annual mobile security awareness (15-minute online module)
- Topics: Passcode security, public Wi-Fi risks, phishing on mobile, physical security

**Enrollment Guides:**
- "How to Enroll Your iPhone in Intune" (step-by-step with screenshots)
- "How to Enroll Your Android Device"
- "Installing Work Apps from Company Portal"

## 13. Privacy and Monitoring

### 13.1 Company-Owned Devices

**Company Can Monitor:**
- Phone calls (call logs, duration, numbers)
- Text messages (SMS/MMS content)
- Email and Teams messages
- App usage and websites visited
- GPS location (if location services enabled)
- Photos and files stored on device

**Employee Privacy:**
- No expectation of privacy on company-owned devices
- Personal use permitted but monitored
- Company complies with local employment privacy laws

### 13.2 BYOD

**Company Can Monitor (Limited to Work Apps):**
- Email sent/received in Outlook
- Files accessed in OneDrive
- Teams chat and meetings
- Work app usage and data access

**Company Cannot Monitor:**
- Personal phone calls, texts, or emails
- Personal apps (social media, banking, games)
- Browser history outside work apps
- Photos or personal files
- GPS location outside work app features

**User Privacy:**
- Work data isolated in managed container
- Selective wipe removes only work data
- IT cannot access personal apps or data

## 14. Cost and Reimbursement

### 14.1 Company-Owned Devices

- **Device Cost:** Fully paid by company
- **Cellular Plan:** Company pays monthly charges
- **Acceptable Usage:** Reasonable personal use included
- **Excessive Usage:** >5GB data or >500 minutes voice per month requires explanation

### 14.2 BYOD

- **Device Cost:** Employee's responsibility
- **Cellular Plan:** Employee's responsibility
- **BYOD Stipend:** $[amount/month] to offset costs (if applicable)
- **Work-Related Charges:** International roaming for business travel reimbursable (submit expense report)

---

## Appendices

### Appendix A: Supported Devices and OS Versions

| Platform | Minimum OS Version | Maximum Age | Recommended Devices |
|----------|-------------------|-------------|---------------------|
| **iOS** | iOS 15 | 3 years | iPhone 12 or newer |
| **Android** | Android 11 | 3 years | Samsung Galaxy S21+, Google Pixel 6+ |

### Appendix B: Enrollment Instructions

**Enrolling iPhone in Intune (BYOD):**
1. Download "Company Portal" app from App Store
2. Sign in with work email and password
3. Tap "Begin" to start enrollment
4. Follow prompts to install management profile
5. Set device passcode if not already set (6 digits minimum)
6. Download work apps: Outlook, Teams, OneDrive

**Enrolling Android in Intune (BYOD):**
1. Download "Intune Company Portal" app from Google Play Store
2. Sign in with work email and password
3. Tap "Begin" to start enrollment
4. Accept work profile setup (isolates work apps from personal)
5. Set work profile passcode
6. Download work apps from Company Portal (not Google Play)

### Appendix C: Device Compliance Policy Details

| Requirement | Company-Owned | BYOD | Enforcement |
|-------------|---------------|------|-------------|
| Passcode | 6-digit minimum | 6-digit minimum | Block access after 24h grace |
| Encryption | Required | Required | Block access immediately |
| OS Version | iOS 15+, Android 11+ | iOS 15+, Android 11+ | Block after 60 days outdated |
| Jailbreak/Root | Prohibited | Prohibited | Block immediately if detected |
| Antivirus (Android) | Microsoft Defender | Optional (Play Protect OK) | Warning only |
| Inactivity Lock | 5 minutes | 5 minutes | Warning only |

### Appendix D: Mobile Security Best Practices

**Quick Tips:**
- ✓ Enable passcode/biometric lock (6 digits minimum)
- ✓ Keep OS and apps updated
- ✓ Use strong Wi-Fi passwords (WPA2/WPA3)
- ✓ Avoid public Wi-Fi for work email (use cellular data)
- ✓ Lock screen when setting down device
- ✓ Be cautious of phishing texts (smishing)
- ✓ Review app permissions (deny unnecessary camera, location access)
- ✓ Enable "Find My Device" (iPhone) or "Find My Device" (Android)
- ✓ Report lost/stolen devices immediately
- ✓ Back up work data to OneDrive (not device storage)

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework |

---

**Note:** This Mobile Device Policy template is derived from the Strategic Integration Framework for SMB Security. Adjust BYOD reimbursement, acceptable use guidelines, and monitoring provisions based on local employment and privacy laws.
