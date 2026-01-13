# Password and Authentication Policy

**Organization:** [Company Name]
**Document Version:** 1.0
**Effective Date:** [Date]
**Review Date:** [Date + 12 months]
**Owner:** IT Security Team / IT Director
**Classification:** Internal

---

## 1. Purpose

This Password and Authentication Policy establishes requirements for creating, protecting, and managing authentication credentials to prevent unauthorized access to [Company Name]'s information systems and data.

## 2. Scope

This policy applies to all users (employees, contractors, vendors, partners) accessing company systems, and covers all authentication methods including passwords, multi-factor authentication (MFA), biometrics, and API keys.

## 3. Password Requirements

### 3.1 Password Complexity

**Azure AD Passwords (enforced by Microsoft 365):**
- Minimum length: **12 characters** (industry best practice)
- Complexity: Must contain three of four character types:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Numbers (0-9)
  - Special characters (!@#$%^&*)
- **Banned passwords:** Microsoft's banned password list (common passwords, company name, variations of "Password123")
- **Smart lockout:** Account locked after 10 failed attempts (1-minute lockout, escalating)

**Application/System Passwords:**
- Same requirements as Azure AD
- Unique password per application (no password reuse across systems)
- Service accounts: 16+ character randomly generated passwords

### 3.2 Password Creation Guidelines

**Do:**
- ✓ Use passphrases: "Coffee-Morning-Sunshine-2025"
- ✓ Use password manager to generate random passwords
- ✓ Create unique passwords for each account
- ✓ Make passwords at least 14 characters (recommended)

**Don't:**
- ✗ Use personal information (name, birthday, pet names)
- ✗ Use dictionary words or common patterns
- ✗ Use keyboard patterns (qwerty, 123456, asdfgh)
- ✗ Reuse passwords across work and personal accounts
- ✗ Share passwords with anyone (including IT support)

### 3.3 Password Expiration

**User Passwords:**
- **No mandatory expiration** (per latest NIST SP 800-63B and Microsoft guidance)
- Passwords only expire if compromised or user requests reset
- Rationale: Forced expiration leads to weak, predictable passwords

**Service Account Passwords:**
- Rotate every **90 days** (automated where possible)
- Documented in password vault with rotation schedule

**Emergency/Break-Glass Account Passwords:**
- Changed after each use
- Reviewed every **30 days** to ensure not compromised

### 3.4 Password History

- Remember last **24 passwords** (prevent reuse of recently used passwords)
- Users cannot revert to previously used password within 2 years

## 4. Multi-Factor Authentication (MFA)

### 4.1 MFA Requirement

**Mandatory MFA for:**
- ✓ **All user accounts** (no exceptions except emergency accounts)
- ✓ **All administrative accounts** (Azure AD, Microsoft 365 admin, Azure portal)
- ✓ **Remote access** (VPN, remote desktop)
- ✓ **External access** (access from non-corporate networks)
- ✓ **Privileged operations** (password resets, admin role assignments)
- ✓ **Financial systems** (accounting software, payment processing)

**MFA Enrollment Deadline:**
- New employees: Within 7 days of hire
- Existing employees: Enforced as of [rollout date per Phase 1]
- Non-compliance: Access blocked until enrolled

### 4.2 Approved MFA Methods

**Preferred (Phishing-Resistant):**
1. **Microsoft Authenticator App** (push notification)
   - Passwordless sign-in option available
   - Number matching required (anti-MFA fatigue)
2. **FIDO2 Security Keys** (YubiKey, Feitian)
   - For high-risk users (executives, IT admins, finance)
3. **Windows Hello for Business** (biometric or PIN on corporate devices)

**Acceptable (Less Secure, Use as Backup):**
4. **Authenticator App TOTP Codes** (time-based one-time passwords)
5. **SMS Text Codes** (acceptable as backup only, not primary)

**Prohibited:**
- ✗ Voice calls (vulnerable to social engineering)
- ✗ Email codes (if email account compromised, MFA bypassed)

### 4.3 MFA Device Management

- Users must register **minimum 2 MFA methods** (primary + backup)
- Lost/stolen device: Report to IT immediately for MFA reset
- MFA registration reviewed every 90 days (remove old devices)
- Company-issued phones: Enrolled in Intune for remote wipe capability

### 4.4 MFA Bypass Requests

- No MFA bypass except for emergency access accounts
- Temporary exceptions require executive approval + compensating controls
- Maximum exception duration: 7 days
- All bypass usage logged and reviewed

## 5. Account Types and Authentication

### 5.1 User Accounts

**Standard User Accounts:**
- Format: firstname.lastname@company.com
- MFA required
- Conditional Access policies applied
- Auto-disabled after 90 days of inactivity

**Privileged User Accounts:**
- Separate admin account: admin-firstname.lastname@company.com
- Used ONLY for administrative tasks (not daily work)
- MFA required with phishing-resistant method (FIDO2 or Authenticator)
- Session timeout: 8 hours (re-authentication required)
- All actions logged and audited

**Emergency Access Accounts (Break-Glass):**
- 2 accounts: emergency1@ and emergency2@
- Cloud-only accounts (not synced from on-premises)
- Stored in physical safe: Password + recovery codes
- Excluded from MFA and Conditional Access (for emergency recovery)
- Usage triggers immediate alert to security team
- Monitored daily for unauthorized use

### 5.2 Service Accounts

**For Automated Processes:**
- Named descriptively: svc-backups@, svc-crm-integration@
- Random 16+ character passwords stored in Azure Key Vault
- No interactive sign-in allowed
- MFA not applicable (use API keys or certificates for authentication)
- Activity logged and reviewed monthly
- Owner assigned for accountability

### 5.3 Guest/External Accounts

**For Partners, Vendors, Contractors:**
- Azure AD B2B guest accounts (firstname@vendor.com)
- MFA required (enforced via Conditional Access)
- Access granted for specific resources only (no broad permissions)
- Time-limited access (30-90 days, then re-review)
- Quarterly access reviews by business owner

## 6. Password Management

### 6.1 Password Storage

**Users:**
- Use company-approved password manager: [LastPass, 1Password, Dashlane, or Microsoft Authenticator]
- Generate random passwords for all applications
- Do NOT store passwords in:
  - Unencrypted files (Word, Excel, text files)
  - Browsers (unless using company-managed device with BitLocker)
  - Sticky notes, notebooks, or desk drawers

**IT Department:**
- Privileged passwords stored in password vault: [Azure Key Vault, LastPass Enterprise, CyberArk]
- Emergency account credentials in physical safe
- Service account passwords in Azure Key Vault with access logging

### 6.2 Password Sharing Prohibition

- **Never share passwords** - even with managers, IT support, or colleagues
- IT support will never ask for your password
- If access needed by multiple people, request shared account or resource delegation

**Legitimate Alternatives to Sharing:**
- Delegate mailbox access in Outlook (no password needed)
- Share files via SharePoint/OneDrive (access control)
- Service accounts for automated processes

### 6.3 Password Reset Process

**Self-Service Password Reset (SSPR):**
- Enabled for all users via Azure AD SSPR
- Registration required: Alternate email + mobile phone
- Reset methods: Email code + SMS code (both required)
- Password reset does not bypass MFA enrollment

**Help Desk Password Reset:**
- Available if SSPR fails
- Identity verification required (employee ID + manager confirmation OR security questions)
- Temporary password provided (forced change on next login)
- MFA reset requires manager approval

**Emergency Account Password Reset:**
- Requires two authorized personnel (dual control)
- Logged and audited
- Executive management notified

## 7. Conditional Access Policies

### 7.1 Enforced Policies

1. **Require MFA for All Users**
   - Applies to: All users
   - Conditions: All cloud apps
   - Grant: Require MFA
   - Exceptions: Emergency access accounts

2. **Block Legacy Authentication**
   - Applies to: All users
   - Conditions: Legacy authentication protocols (POP3, IMAP, SMTP)
   - Grant: Block access
   - Rationale: Legacy protocols don't support MFA

3. **Require Compliant or Hybrid Joined Devices**
   - Applies to: All users
   - Conditions: All cloud apps
   - Grant: Require device compliance OR Hybrid Azure AD joined
   - Impact: Personal devices must enroll in Intune to access email

4. **Require MFA for Administrators**
   - Applies to: Admin roles (Global Admin, SharePoint Admin, etc.)
   - Conditions: All cloud apps
   - Grant: Require MFA + Compliant device
   - Additional: Phishing-resistant MFA method required

5. **Block Access from Unknown Locations** (if using office network)
   - Applies to: All users
   - Conditions: Cloud apps when outside trusted IP ranges
   - Grant: Require MFA or Block (based on risk)

6. **Block High-Risk Sign-Ins** (requires Azure AD P2)
   - Applies to: All users
   - Conditions: Sign-in risk = High
   - Grant: Block access OR Require MFA + password change

## 8. Password Security Monitoring

### 8.1 Automated Detection

**Azure AD Identity Protection:**
- Leaked credential detection (passwords found in breaches)
- Impossible travel detection (sign-ins from distant locations)
- Anonymous IP detection (VPN/Tor usage flagged)
- Atypical travel patterns

**Actions:**
- High-risk users: Automatically block OR require password change + MFA
- Medium-risk: Require MFA
- Alerts sent to security team for investigation

### 8.2 Manual Reviews

**Weekly:**
- Review failed sign-in attempts (brute force detection)
- Review MFA enrollment status (track completion)
- Review emergency account usage (should be zero)

**Monthly:**
- Review privileged account activity
- Review service account password rotation status
- Review MFA bypass requests and approvals

**Quarterly:**
- Audit password strength (identify weak passwords using penetration testing)
- Review MFA methods registered (remove old/lost devices)

## 9. Incident Response for Credential Compromise

### 9.1 Signs of Compromise

- Multiple failed login attempts from unknown location
- Impossible travel alerts
- User reports unexpected MFA prompts (MFA fatigue attack)
- User reports password doesn't work
- Unusual activity in account (emails sent, files accessed)

### 9.2 Response Procedure

**Immediate Actions (within 1 hour):**
1. Disable affected account
2. Revoke all active sessions
3. Reset password (admin-initiated, cannot self-reset)
4. Review sign-in logs for suspicious activity (IP addresses, locations)
5. Check for inbox rules, forwarding rules, email delegation

**Investigation:**
6. Review recent emails sent from account (potential BEC - Business Email Compromise)
7. Review files accessed in OneDrive/SharePoint
8. Check for data exfiltration (large downloads)
9. Identify root cause (phishing, password reuse, malware)

**Recovery:**
10. Re-enable account after user verification (phone call to known number)
11. Force MFA re-enrollment (delete all previous MFA methods)
12. User training on phishing awareness
13. Monitor account for 30 days

See **Incident Response Plan** for detailed playbook.

## 10. User Responsibilities

All users must:
- ✓ Create strong, unique passwords for each account
- ✓ Enroll in MFA within 7 days of account creation
- ✓ Protect credentials (never share, never write down)
- ✓ Use company-approved password manager
- ✓ Report suspected compromise immediately
- ✓ Complete annual security awareness training
- ✓ Lock workstation when away from desk (Windows+L)
- ✓ Log out of shared computers
- ✓ Report phishing emails to security team

## 11. IT Department Responsibilities

- Deploy and maintain MFA infrastructure
- Configure Conditional Access policies
- Monitor sign-in logs for suspicious activity
- Provide user support for password resets and MFA enrollment
- Conduct quarterly password security audits
- Provide annual training on password best practices
- Maintain emergency access account procedures

## 12. Compliance and Enforcement

### 12.1 Policy Violations

- Failure to enroll in MFA within 7 days: Account disabled
- Sharing passwords: Written warning (first offense), termination (repeat)
- Bypassing security controls: Disciplinary action up to termination
- Credential compromise due to negligence: Coaching and re-training

### 12.2 Monitoring

- Automated monitoring via Azure AD Identity Protection
- Monthly password security metrics reported to IT Director
- Quarterly executive summary (MFA adoption, compromises, trends)

## 13. Password Policy Exceptions

- Limited exceptions for application compatibility issues (legacy systems)
- Require compensating controls (network segmentation, restricted access)
- IT Director approval required
- Maximum 6-month exception, then re-review
- Exception log maintained and audited annually

---

## Appendices

### Appendix A: Password Best Practices Quick Reference

**Creating Passwords:**
- Use passphrases: "BlueElephant$DancesMoon2025"
- Use password manager to generate random passwords
- Minimum 12 characters (14+ recommended)
- Unique per account (no reuse)

**Protecting Passwords:**
- Never share with anyone
- Store in password manager (not browser, files, or paper)
- Never send via email or text
- Change immediately if suspected compromise

**Using MFA:**
- Enroll in Microsoft Authenticator app
- Register backup method (TOTP codes or FIDO2 key)
- Approve only MFA prompts you initiated
- Report unexpected prompts to IT Security immediately

### Appendix B: MFA Enrollment Guide

[Step-by-step screenshots for enrolling in Microsoft Authenticator, registering FIDO2 key, setting up Windows Hello]

### Appendix C: Password Manager Setup

[Instructions for deploying company-approved password manager, creating vault, generating passwords]

### Appendix D: Common Password Attacks

1. **Brute Force:** Automated guessing of passwords (mitigated by account lockout + MFA)
2. **Credential Stuffing:** Using leaked passwords from other breaches (mitigated by unique passwords + MFA)
3. **Phishing:** Fake login pages stealing credentials (mitigated by MFA + user training)
4. **MFA Fatigue:** Spamming user with MFA prompts until approved (mitigated by number matching in Authenticator)
5. **Password Spraying:** Trying common passwords against many accounts (mitigated by banned password list)

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial version based on SMB Security Framework and NIST SP 800-63B |

---

**Note:** This Password Policy template is derived from the Strategic Integration Framework for SMB Security and aligns with NIST SP 800-63B Digital Identity Guidelines and Microsoft's password guidance (no expiration, focus on length and uniqueness).
