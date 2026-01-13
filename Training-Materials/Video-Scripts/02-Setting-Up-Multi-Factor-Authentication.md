# Video Script: Setting Up Multi-Factor Authentication (MFA)

**Duration:** 4-5 minutes
**Target Audience:** All employees
**Learning Objectives:**
- Understand what MFA is and why it's required
- Successfully enroll in Microsoft Authenticator
- Know how to use MFA for daily logins

---

## Script Outline

### [INTRO - 0:00-0:30]
**What is MFA?**
- Second layer of security beyond password
- Something you know (password) + Something you have (phone)
- Blocks 99.9% of automated attacks (Microsoft statistic)
- Required for all company accounts within 7 days

**Visual:** Animation showing attacker blocked by MFA even with stolen password

---

### [SECTION 1: MFA Methods - 0:30-1:30]

**Approved MFA Methods (in order of preference):**

1. **Microsoft Authenticator App** (Recommended)
   - Push notification to your phone
   - Tap "Approve" to sign in
   - Number matching prevents MFA fatigue attacks

2. **FIDO2 Security Key** (For high-risk users: IT admins, executives, finance)
   - Physical USB key (YubiKey)
   - Phishing-resistant
   - IT will provide if required for your role

3. **Authenticator App TOTP Codes** (Backup method)
   - 6-digit code that changes every 30 seconds
   - Use if push notification fails

**Visual:** Side-by-side comparison showing each method

---

### [SECTION 2: Enrolling in Microsoft Authenticator - 1:30-3:30]

**Step-by-Step Demo (Screen Recording):**

**Prerequisites:**
- Smartphone (iPhone or Android)
- Company email credentials
- Internet connection

**Enrollment Process:**

1. **Download Microsoft Authenticator**
   - App Store (iOS) or Google Play Store (Android)
   - Free, no in-app purchases
   - Install and open app

2. **Navigate to MFA Setup Page**
   - Go to https://aka.ms/mfasetup
   - Sign in with company email and password
   - Click "Next" when prompted to set up MFA

3. **Add Work Account to Authenticator**
   - In app, tap "+" then "Work or school account"
   - Tap "Scan QR code"
   - Point phone camera at QR code on computer screen
   - Account automatically added

4. **Complete Registration**
   - Tap "Approve" on phone when prompted
   - Confirm number matches on screen (number matching feature)
   - Registration successful!

5. **Set Up Backup Method**
   - Add phone number for SMS backup (in case you lose phone)
   - Receive verification code via text
   - Enter code to confirm

6. **Test Your Setup**
   - Sign out of computer
   - Sign back in
   - Notification appears on phone: "Approve sign-in?"
   - Confirm number matches
   - Tap "Approve"
   - Success!

**Visual:** Split-screen showing computer and phone side-by-side for entire process

---

### [SECTION 3: Daily Usage - 3:30-4:15]

**How MFA Works Day-to-Day:**

**Typical Sign-In:**
1. Enter your email and password on computer
2. Notification arrives on your phone
3. Open notification, verify number matches
4. Tap "Approve"
5. Signed in! (Takes 3-5 seconds)

**Stay Signed In:**
- Check "Don't ask again for 30 days" on trusted devices (company laptop)
- Still prompted on new devices or suspicious sign-ins
- Automatic re-prompt every 30 days

**If Phone Not Available:**
- Use backup TOTP codes (6-digit rotating number)
- Or use backup phone number (SMS code)
- Contact IT if you can't access any method

**Visual:** Real-time screen recording of sign-in process

---

### [SECTION 4: Best Practices & Troubleshooting - 4:15-5:00]

**Best Practices:**
- ✓ Always have 2+ MFA methods registered (primary + backup)
- ✓ Enable biometric lock on your phone (Face ID, fingerprint)
- ✓ Verify number matches before approving (prevents MFA fatigue attacks)
- ✓ Report unexpected MFA prompts to IT Security immediately

**Common Issues:**

**Problem:** Not receiving push notifications
- **Solution:** Check internet/cellular connection, restart Authenticator app

**Problem:** Phone lost or stolen
- **Solution:** Report to IT immediately (we'll remotely disable and help you re-enroll)

**Problem:** Authenticator app deleted accidentally
- **Solution:** Reinstall app, re-enroll using same process (your account remembers registration)

**Problem:** Getting MFA prompts you didn't initiate
- **Solution:** **DO NOT APPROVE.** Deny the prompt and contact IT Security immediately (possible account compromise attempt)

---

### [CLOSING - 5:00-5:30]

**Key Takeaways:**
- MFA blocks 99.9% of account takeovers—it's your strongest defense
- Microsoft Authenticator app is easiest method (push notifications)
- Enrollment takes 5 minutes, required within 7 days
- Set up backup method in case phone unavailable
- Report unexpected prompts—don't just approve

**Next Steps:**
- Enroll today: https://aka.ms/mfasetup
- Test your setup by signing out and back in
- Save IT Help Desk number in case of issues: [phone]

**Support Available:**
- IT Help Desk: [phone/email]
- Step-by-step guide with screenshots: [intranet link]
- In-person assistance available (book via IT ticket)

**Visual:** End screen with enrollment URL in large text

---

## Post-Video Actions

**Immediately After Watching:**
- [ ] Download Microsoft Authenticator app
- [ ] Enroll in MFA: https://aka.ms/mfasetup
- [ ] Test sign-in process
- [ ] Register backup method (phone number or TOTP codes)

**Within 7 Days:**
- [ ] Complete enrollment (enforcement deadline)
- [ ] Verify enrollment successful
- [ ] Check "Remember device" on company laptop

---

## Quiz (5 Questions)

1. **When does MFA kick in?**
   - a) Only when signing in from a new device
   - b) Every time you sign in ✓
   - c) Only for admin accounts
   - d) Only when accessing confidential data

2. **What is the recommended MFA method for most employees?**
   - a) SMS text codes
   - b) Email codes
   - c) Microsoft Authenticator app ✓
   - d) Security questions

3. **What should you do if you receive an unexpected MFA prompt?**
   - a) Approve it (probably just a system test)
   - b) Ignore it
   - c) Deny it and report to IT Security immediately ✓
   - d) Approve it but change your password later

4. **How many MFA methods should you register?**
   - a) 1 (primary only)
   - b) 2 or more (primary + backup) ✓
   - c) As many as possible
   - d) Only what IT sets up for you

5. **What is the enrollment deadline for MFA?**
   - a) Within 7 days ✓
   - b) Within 30 days
   - c) By end of quarter
   - d) Optional (recommended but not required)

**Passing Score:** 4/5 correct (80%)

---

## Production Assets Needed

**Screen Recordings:**
- Microsoft Authenticator app download process (iOS + Android)
- https://aka.ms/mfasetup enrollment flow (complete walkthrough)
- QR code scanning process
- First sign-in with MFA (computer + phone split-screen)
- Number matching feature demonstration

**Graphics:**
- MFA concept animation (password + phone = security)
- Attacker blocked by MFA (even with password)
- Comparison chart of MFA methods
- Troubleshooting flowchart

**Screenshots:**
- Microsoft Authenticator app interface (iOS + Android)
- MFA setup page in browser
- Push notification on phone
- Number matching screen

---

## Accessibility

- Closed captions with step-by-step instructions
- Audio description of visual steps
- Text transcript with screenshots (for employees without video access)
- In-person assistance available for employees with accessibility needs

---

**License:** CC BY-SA 4.0
**Version:** 1.0
**Last Updated:** [Date]
**Related Materials:**
- Quick Reference: MFA Enrollment Guide (1-page with screenshots)
- Policy: Password and Authentication Policy
- Video: 03-Creating-Strong-Passwords
