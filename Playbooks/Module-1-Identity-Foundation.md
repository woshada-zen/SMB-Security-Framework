# Module 1: Identity Foundation Playbook

**Strategic Integration Framework for SMB Security**

---

## Module Overview

**Objective:** Establish comprehensive identity security foundation protecting user credentials and access controls.

**Duration:** Weeks 3-6 (Phase 1)
**Effort:** 8-12 hours
**Priority:** **HIGH** - Identity is the foundation; MFA prevents 99.9% of automated attacks (NCSC, 2022)

**Key Deliverables:**
- ✅ Universal MFA enforcement (100% user coverage target)
- ✅ 6 recommended Conditional Access policies deployed
- ✅ Password protection configured (custom banned lists, smart lockout)
- ✅ Self-Service Password Reset (SSPR) enabled
- ✅ Guest user governance established
- ✅ Privileged account management implemented

**Expected Outcomes:**
- Immediate Secure Score increase (+15-25 points typical)
- Credential-based attack prevention
- Reduced password-related help desk tickets (30-40% reduction)
- Compliance demonstration (GDPR Article 32, ISO 27001 A.9.4.2)

---

## Prerequisites

### Licensing Requirements

| Feature | Business Premium | E3 | E5 | Required |
|---------|-----------------|----|----|----------|
| Multi-Factor Authentication (MFA) | ✅ | ✅ | ✅ | **YES** |
| Conditional Access (Basic) | ✅ | ✅ | ✅ | **YES** |
| Conditional Access (Risk-based) | ❌ | ✅ (with P2) | ✅ | Recommended |
| Password Protection | ✅ | ✅ | ✅ | **YES** |
| SSPR | ✅ | ✅ | ✅ | **YES** |
| Privileged Identity Management | ❌ | ❌ | ✅ | Optional (E5) |

### Technical Prerequisites
- Global Administrator or Security Administrator role
- Azure AD Premium P1 (included in E3/E5/Business Premium)
- PowerShell 5.1+ with Microsoft Graph PowerShell SDK installed
- Test user accounts for verification

### Organizational Prerequisites
- Executive sponsorship secured (see executive briefing templates)
- Communication plan prepared (see `/Training-Materials/`)
- Help desk briefed on MFA support procedures

---

## Implementation Procedures

### Step 1: Enable Multi-Factor Authentication (3-4 hours)

#### 1.1 Define MFA Scope

**Decision Point:** Enforcement approach

**Option A - Recommended:** Universal enforcement (all users)
- **Pros:** Maximum security, simplest policy, consistent experience
- **Cons:** Requires comprehensive user communication
- **Use when:** Organization <150 users, strong executive sponsorship

**Option B:** Phased rollout (IT → Executives → Managers → All users)
- **Pros:** Allows pilot group testing, gradual change management
- **Cons:** Delayed full protection, complexity managing multiple groups
- **Use when:** Organization >150 users, change resistance concerns

#### 1.2 Communication (Pre-Implementation)

**Timeline:** 1 week before MFA enforcement

**Actions:**
1. **Executive announcement** - Use template: `/Training-Materials/Executive-MFA-Announcement-Template.docx`
2. **User training** - Deliver video: `/Training-Materials/Videos/02-Setting-Up-MFA-in-3-Steps.mp4`
3. **Quick-reference distribution** - Print and distribute: `/Training-Materials/Quick-References/MFA-Setup-Guide.pdf`
4. **Help desk preparation** - Common issues FAQ, Microsoft Authenticator app support

#### 1.3 Technical Implementation

**Manual Method (Small organizations <50 users):**
1. Navigate to: Azure AD Admin Center → Users → Per-user MFA
2. Select users → Enable → Require MFA at next sign-in
3. Notify users to complete registration at https://aka.ms/mfasetup

**Automated Method (Recommended for 50+ users):**

```powershell
# Use automation script
.\Enable-BulkMFA.ps1 -UserGroup "All Users" -MFAMethod "MicrosoftAuthenticator"

# Script parameters:
# -UserGroup: "All Users", "Executives", "IT-Staff", or custom Azure AD group name
# -MFAMethod: "MicrosoftAuthenticator" (recommended), "SMS", "PhoneCall"
# -ExcludeGroup: Optional - emergency access accounts
```

**Emergency Access Account Exception:**
- Create 2 "break-glass" admin accounts (e.g., admin-emergency01@, admin-emergency02@)
- Store passwords in secure physical location (fireproof safe)
- Exclude from MFA policies
- Monitor monthly (alert if used)

#### 1.4 Verification

**Success Criteria:**
- ✅ 95%+ users completed MFA registration within 7 days
- ✅ Zero users accessing without MFA (check sign-in logs)
- ✅ <5 help desk tickets per 100 users
- ✅ Secure Score shows "Enable MFA for all users" completed (+10 points)

**Verification Commands:**

```powershell
# Check MFA registration status
Get-MgReportAuthenticationMethodUserRegistrationDetail |
  Where-Object {$_.IsMfaRegistered -eq $false} |
  Select-Object UserPrincipalName, IsMfaRegistered

# Check MFA enforcement coverage
Get-MgUser -All | Select-Object DisplayName, UserPrincipalName,
  @{N='MFAStatus';E={(Get-MgUserAuthenticationMethod -UserId $_.Id).Count -gt 1}}
```

---

### Step 2: Deploy Conditional Access Policies (2-3 hours)

#### 2.1 Recommended Policy Set (6 Policies)

**Policy 1: Require MFA for All Users**
- **Condition:** All users, all cloud apps
- **Control:** Require MFA
- **Exclusion:** Emergency access accounts
- **Purpose:** Baseline protection

**Policy 2: Block Legacy Authentication**
- **Condition:** All users, legacy authentication clients
- **Control:** Block access
- **Purpose:** Prevent bypass via SMTP, POP3, IMAP (no MFA support)

**Policy 3: Require Compliant or Hybrid Joined Devices**
- **Condition:** All users, Office 365 apps
- **Control:** Require device to be compliant OR hybrid Azure AD joined
- **Purpose:** Prevent access from unmanaged devices

**Policy 4: Require MFA for Administrators**
- **Condition:** Directory role = Global Admin, Security Admin, etc.
- **Control:** Require MFA (always, every sign-in)
- **Purpose:** Enhanced protection for privileged accounts

**Policy 5: Block Access from Unknown Locations**
- **Condition:** All users, locations NOT in "Trusted IPs" named location
- **Control:** Require MFA + compliant device
- **Purpose:** Geographic restriction (optional, configure trusted office IPs)

**Policy 6: Block High-Risk Sign-Ins** (E5 only - requires Azure AD Identity Protection)
- **Condition:** Sign-in risk = High
- **Control:** Block OR require MFA + password change
- **Purpose:** AI-driven anomaly detection

#### 2.2 Automated Deployment

```powershell
# Deploy all 6 recommended policies
.\Deploy-ConditionalAccessPolicies.ps1 -PolicySet "SMB-Recommended" -Mode "ReportOnly"

# Parameters:
# -PolicySet: "SMB-Recommended" (all 6 policies), "Essential" (policies 1-4 only)
# -Mode: "ReportOnly" (test mode, no enforcement), "Enabled" (enforce immediately)
# -TrustedIPs: "203.0.113.0/24,198.51.100.0/24" (office IP ranges for Policy 5)

# IMPORTANT: Start in ReportOnly mode, review for 7 days, then enable enforcement
```

#### 2.3 Testing Protocol

**Week 1: Report-Only Mode**
1. Deploy policies in report-only mode
2. Monitor Azure AD Sign-in logs → Conditional Access tab
3. Identify "would have been blocked" scenarios
4. Adjust exclusions if needed (e.g., legacy app dependencies)

**Week 2: Enforcement**
1. Switch policies from "Report-only" to "Enabled"
2. Monitor help desk tickets
3. Review sign-in logs daily for blocked users
4. Communicate policy enforcement to users

---

### Step 3: Configure Password Protection (1 hour)

#### 3.1 Custom Banned Password List

**Azure AD Password Protection** prevents users from setting weak passwords.

**Default Protection:** Microsoft global banned list (common passwords, variations)

**Custom Banned List - Recommended Additions:**
- Company name and variations (e.g., "Contoso", "Cont0so", "C0ntoso")
- Product names
- Office location names
- Common industry terms
- Previously breached passwords from your organization

**Implementation:**

```powershell
# Manual: Azure AD Admin Center → Security → Authentication methods → Password protection
# Add custom banned terms (max 1000 terms)

# PowerShell:
.\Configure-PasswordProtection.ps1 -CustomBannedWords @("CompanyName", "Product1", "Product2")
```

#### 3.2 Smart Lockout Configuration

**Settings:**
- Lockout threshold: **10 failed attempts** (default)
- Lockout duration: **60 seconds** (default)

**Advanced:** Lower threshold for privileged accounts (5 attempts)

---

### Step 4: Enable Self-Service Password Reset (1 hour)

**Benefits:**
- 30-40% reduction in password-related help desk tickets
- User empowerment
- Faster account recovery

**Configuration:**

1. Navigate to: Azure AD Admin Center → Password reset
2. Enable for: **All users** (recommended) OR **Selected group** (pilot first)
3. Authentication methods required: **2 methods**
   - Recommended: Mobile phone + Email
4. Registration: **Require users to register when signing in** (yes)
5. Notifications: **Notify users on password resets** (yes)

**User Communication:**
- Guide users to register at: https://aka.ms/ssprsetup
- Quick-reference: `/Training-Materials/Quick-References/SSPR-Setup-Guide.pdf`

---

### Step 5: Guest User Governance (1 hour)

**Challenge:** External collaborators require access; unrestricted guest access creates security risks.

**Policy Recommendations:**

1. **Guest Invitation Restrictions**
   - Who can invite: **Admins and users in guest inviter role only** (restrict from all users)
   - Configure: Azure AD → External Identities → External collaboration settings

2. **Guest Access Permissions**
   - Guest user access: **Limited access** (cannot browse directory)

3. **Access Reviews** (E5 feature)
   - Quarterly reviews of guest user access
   - Auto-remove guests without activity for 90 days

4. **Guest User Expiration**
   - Lifecycle workflow: Auto-disable guest accounts after 180 days (E5)
   - Manual alternative: Quarterly audit and cleanup

---

### Step 6: Privileged Account Management (2-3 hours)

**Principle:** Separate privileged and daily-use accounts to limit blast radius.

**Implementation:**

1. **Identify privileged roles:**
   - Global Administrator
   - Security Administrator
   - Exchange Administrator
   - SharePoint Administrator
   - User Administrator

2. **Create dedicated admin accounts:**
   - Naming convention: `admin-{firstname}.{lastname}@domain.com`
   - Example: `admin-john.smith@contoso.com` (separate from `john.smith@contoso.com`)

3. **Configure admin accounts:**
   - ❌ No mailbox, OneDrive, Teams (admin-only access)
   - ✅ Strong password (20+ characters)
   - ✅ MFA required (Policy 4)
   - ✅ Sign-in only from secure admin workstations (optional)

4. **Privileged Identity Management (E5 only):**
   - Just-in-time admin access (elevate on-demand, 4-8 hour time limit)
   - Approval workflows for Global Admin elevation
   - Configure: Azure AD → Privileged Identity Management

**Non-E5 Alternative:**
- Use Azure AD roles with least privilege
- Regularly audit role assignments (monthly)

---

## Verification and Validation

### Post-Implementation Checklist

- [ ] **MFA Coverage:** 95%+ users registered and enforcing MFA
- [ ] **Conditional Access:** 6 policies deployed and enforcing (or 4 if non-E5)
- [ ] **Legacy Auth:** Zero legacy authentication sign-ins (check logs for 7 days)
- [ ] **Password Protection:** Custom banned list configured, smart lockout enabled
- [ ] **SSPR:** 80%+ users registered for SSPR within 14 days
- [ ] **Guest Governance:** Guest invitation restrictions enabled, access reviews scheduled
- [ ] **Privileged Accounts:** Admin accounts separated, enhanced MFA enforced
- [ ] **Secure Score:** +15-25 point increase documented
- [ ] **User Satisfaction:** <5 help desk tickets per 100 users per week
- [ ] **Documentation:** RACI matrix updated, policies documented

### Metrics Dashboard

**Track Monthly:**
- Microsoft Secure Score (target: +15-25 points after Phase 1)
- MFA coverage percentage
- Conditional Access policy violations (sign-ins blocked)
- SSPR utilization rate
- Help desk ticket volume (password-related)

---

## Troubleshooting Guide

### Issue 1: Users Cannot Complete MFA Registration

**Symptom:** Users report "Cannot set up MFA" or stuck at registration screen

**Common Causes:**
1. Mobile device not receiving push notifications (firewall blocking)
2. SMS delivery delays
3. User timezone mismatch

**Resolution:**
- **Push notifications:** Check firewall allows `https://login.microsoftonline.com`
- **SMS delays:** Wait 5 minutes, request new code
- **Alternative method:** Use Microsoft Authenticator time-based code (TOTP) instead of push

### Issue 2: Conditional Access Policy Blocking Legitimate Users

**Symptom:** Users report "Access denied" or "Cannot access email"

**Diagnosis:**
1. Check sign-in logs: Azure AD → Sign-in logs → Filter by user
2. Look for "Failure" status with "Conditional Access" failure reason
3. Identify blocking policy

**Resolution:**
- **Short-term:** Add user to policy exclusion group (temporary, 24-48 hours)
- **Long-term:** Identify root cause (non-compliant device, unknown location, legacy app)
- **Process:** Remediate root cause, remove exclusion

### Issue 3: Legacy Application Cannot Authenticate

**Symptom:** Application error "Authentication failed" after enabling Policy 2 (Block Legacy Auth)

**Diagnosis:**
- Check application authentication method (SMTP, POP3, IMAP, older API)
- Review sign-in logs for "Legacy authentication" attempts

**Resolution:**
1. **Preferred:** Upgrade application to modern authentication (OAuth 2.0)
2. **Temporary:** Create Conditional Access exclusion for specific user/app
   - Set expiration date (90 days)
   - Document as technical debt
   - Plan migration to modern auth

---

## Compliance Mapping

### NIST Cybersecurity Framework

| NIST Function | NIST Category | Implementation |
|---------------|---------------|----------------|
| **Identify** | Asset Management (ID.AM) | User and admin account inventory |
| **Protect** | Access Control (PR.AC-1) | MFA, Conditional Access policies |
| **Protect** | Access Control (PR.AC-7) | Least privilege (admin account separation) |
| **Detect** | Security Monitoring (DE.CM) | Sign-in logs, Conditional Access reports |

### GDPR Article 32 - Security of Processing

| Requirement | Implementation |
|-------------|----------------|
| Ability to ensure confidentiality | MFA prevents unauthorized access |
| Ability to ensure integrity | Conditional Access enforces device compliance |
| Ability to ensure availability | SSPR reduces account lockout impact |
| Regular testing and evaluation | Monthly Secure Score review, quarterly access reviews |

### ISO 27001 Annex A

- **A.9.2.1 User registration and de-registration:** SSPR, guest governance
- **A.9.2.4 Management of secret authentication information:** Password protection, custom banned lists
- **A.9.4.2 Secure log-on procedures:** MFA enforcement
- **A.9.4.3 Password management system:** SSPR, password protection

---

## Next Steps

**Upon Completion of Module 1:**

1. **Communicate Success:**
   - Send executive summary: "Phase 1 Complete - Identity Security Foundation Established"
   - Metrics: Secure Score increase, MFA coverage, help desk ticket reduction
   - User testimonial: "MFA is easier than expected"

2. **Schedule Phase 2:**
   - Target start: Week 7 (after 1-week stabilization)
   - Next module: Module 2 - Endpoint Protection
   - Effort: 6-10 hours over weeks 7-12

3. **Maintain Phase 1:**
   - Monthly Secure Score review
   - Quarterly Conditional Access policy review
   - Guest user access review (quarterly)
   - Monitor help desk ticket trends

**Estimated time to Phase 2:** 1 week stabilization period (Week 6)

---

## Additional Resources

- **Microsoft Documentation:** https://docs.microsoft.com/azure/active-directory/authentication/
- **MFA Best Practices:** https://aka.ms/MFABestPractices
- **Conditional Access Templates:** https://aka.ms/CATemplates
- **User Training Videos:** `/Training-Materials/Videos/`
- **Quick-Reference Guides:** `/Training-Materials/Quick-References/`
- **Automation Scripts:** `/Automation-Scripts/Enable-BulkMFA.ps1`, `Deploy-ConditionalAccessPolicies.ps1`

---

**Module 1 Complete - Identity Foundation Established ✅**

**Proceed to Module 2: Endpoint Protection** (Weeks 7-12)
