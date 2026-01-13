# Module 2: Endpoint Protection Playbook

**Strategic Integration Framework for SMB Security**

---

## Module Overview

**Objective:** Deploy comprehensive endpoint security protecting devices from malware, ransomware, and advanced threats.

**Duration:** Weeks 7-12 (Phase 2)
**Effort:** 6-10 hours
**Priority:** **HIGH** - Endpoints are primary attack vector; ransomware incidents increasing 150% year-over-year

**Key Deliverables:**
- ✅ Microsoft Defender for Endpoint deployed (95%+ device coverage target)
- ✅ Device compliance policies enforcing security baselines
- ✅ Attack Surface Reduction (ASR) rules enabled
- ✅ Microsoft Intune enrollment configured
- ✅ Patch management automation (Windows Update for Business)
- ✅ Mobile Application Management (MAM) for BYOD scenarios

**Expected Outcomes:**
- Malware detection and blocking (99%+ effectiveness)
- Ransomware protection (behavior-based detection)
- Device visibility and inventory
- Automated threat response
- Secure Score increase (+10-15 points typical)

---

## Prerequisites

### Licensing Requirements

| Feature | Business Premium | E3 | E5 | Required |
|---------|-----------------|----|----|----------|
| Defender for Endpoint (P1) | ✅ | ✅ | ✅ | **YES** |
| Defender for Endpoint (P2) | ❌ | ❌ | ✅ | Recommended |
| Microsoft Intune | ✅ | ✅ | ✅ | **YES** |
| Windows Autopilot | ✅ | ✅ | ✅ | Optional |
| Attack Surface Reduction | ✅ | ✅ | ✅ | **YES** |

### Technical Prerequisites
- Module 1 (Identity Foundation) completed
- Conditional Access policies enforcing device compliance
- Intune Administrator or Endpoint Security Administrator role
- PowerShell 7+ with Microsoft Graph PowerShell SDK

### Device Requirements
- **Windows:** Windows 10/11 (1903+), joined to Azure AD or Hybrid joined
- **macOS:** macOS 10.15+ (Catalina or newer)
- **iOS:** iOS 14+, iPadOS 14+
- **Android:** Android 8.0+ (Oreo or newer)

---

## Implementation Procedures

### Step 1: Deploy Microsoft Defender for Endpoint (4-5 hours with automation)

#### 1.1 Onboarding Strategy

**Decision Point:** Deployment method

**Option A - Cloud-based (Recommended for <100 devices):**
- Devices enroll in Intune directly
- Defender auto-installs via Intune policy
- **Pros:** Simple, no on-premises infrastructure
- **Cons:** Requires internet connectivity during enrollment

**Option B - On-premises + Hybrid (100-500 devices):**
- Use Configuration Manager + Intune co-management
- Gradual migration to cloud-based management
- **Pros:** Leverages existing SCCM infrastructure
- **Cons:** More complex, requires SCCM expertise

#### 1.2 Automated Bulk Onboarding

```powershell
# Deploy Defender for Endpoint to all devices
.\Deploy-DefenderForEndpoint.ps1 -DeviceGroup "All-Windows-Devices" -OnboardingMethod "Intune"

# Parameters:
# -DeviceGroup: "All-Windows-Devices", "Pilot-Group", or custom Azure AD group
# -OnboardingMethod: "Intune" (cloud), "SCCM" (on-prem), "GPO" (hybrid)
# -SenseData: Path to onboarding package from Microsoft 365 Defender portal
```

#### 1.3 Manual Onboarding (Small deployments <20 devices)

1. **Download onboarding package:**
   - Navigate to: Microsoft 365 Defender portal → Settings → Endpoints → Onboarding
   - Select OS: Windows 10/11
   - Deployment method: Local Script
   - Download package: `WindowsDefenderATPOnboardingPackage.zip`

2. **Deploy to devices:**
   - Extract `WindowsDefenderATPOnboardingScript.cmd`
   - Run as Administrator on each device
   - Wait 5 minutes, verify in Defender portal: Devices list

3. **Configure Intune auto-deployment:**
   - Endpoint Manager admin center → Devices → Configuration profiles → Create profile
   - Platform: Windows 10 and later
   - Profile type: Templates → Microsoft Defender for Endpoint
   - Configure: Auto-onboard devices

#### 1.4 Verification

**Success Criteria:**
- ✅ 95%+ devices appear in Microsoft 365 Defender portal → Devices
- ✅ All devices show "Active" status (not "Inactive" or "Misconfigured")
- ✅ Real-time protection enabled on all devices
- ✅ Cloud-delivered protection enabled
- ✅ No devices with "Sensor health issues"

**Verification Commands:**

```powershell
# Check onboarding status
Get-MgDeviceManagementManagedDevice -Filter "operatingSystem eq 'Windows'" |
  Select-Object deviceName, complianceState, managementAgent

# Test detection (EICAR test file - harmless)
# Download from: https://www.eicar.org/download-anti-malware-testfile/
# Should be immediately quarantined by Defender
```

---

### Step 2: Create Device Compliance Policies (2 hours)

#### 2.1 Windows Compliance Policy (Recommended Settings)

**Policy Name:** "Windows 10/11 - Baseline Compliance"

**Security Requirements:**
- ✅ BitLocker encryption required
- ✅ Firewall enabled
- ✅ Antivirus enabled (Defender or equivalent)
- ✅ Anti-spyware enabled
- ✅ Real-time protection ON
- ✅ Minimum OS version: Windows 10 1903
- ✅ Password required (8+ characters)
- ✅ Password expiration: 90 days (optional, modern guidance recommends removing)
- ✅ Require secure boot
- ✅ Require code integrity

**Automated Deployment:**

```powershell
# Deploy 4 platform compliance policies (Windows, macOS, iOS, Android)
.\Create-CompliancePolicies.ps1 -PolicySet "SMB-Baseline"

# Parameters:
# -PolicySet: "SMB-Baseline" (recommended settings), "Strict" (enhanced security), "Minimal" (basic only)
# -Platforms: "Windows,macOS,iOS,Android" (default: all platforms)
```

#### 2.2 Non-Compliance Actions

**Grace Period Recommendations:**

| Days Non-Compliant | Action | Rationale |
|--------------------|--------|-----------|
| 0 days | Mark as non-compliant | Immediate visibility |
| 3 days | Send email to end user | Give time to remediate |
| 7 days | Send email to IT admin | Escalation |
| 14 days | Remotely lock device | Force remediation |
| 30 days | Retire/wipe device | Last resort for abandoned devices |

**Configure:** Intune admin center → Devices → Compliance policies → [Policy] → Actions for noncompliance

---

### Step 3: Enable Attack Surface Reduction (ASR) Rules (1-2 hours)

#### 3.1 ASR Rules Overview

**Attack Surface Reduction (ASR)** blocks behaviors commonly used by malware:

**16 ASR Rules Available - Recommended Subset for SMBs:**

1. **Block executable content from email client and webmail** (High priority)
2. **Block Office applications from creating executable content** (Blocks macro malware)
3. **Block Office applications from injecting code into other processes**
4. **Block JavaScript or VBScript from launching downloaded executable content**
5. **Block execution of potentially obfuscated scripts** (PowerShell/JS obfuscation)
6. **Block credential stealing from Windows LSASS** (Mimikatz, credential dumping)
7. **Block ransomware** (Advanced ransomware protection)
8. **Block untrusted and unsigned processes from USB** (Removable media threats)

#### 3.2 Phased Rollout (CRITICAL - Avoid Disruption)

**Phase 2A - Audit Mode (Weeks 7-9):**
- Enable all ASR rules in **Audit** mode
- Rules log events but don't block
- Review logs for false positives (legitimate apps blocked)

**Phase 2B - Enforcement (Weeks 10-12):**
- Switch to **Block** mode for rules with zero/low false positives
- Keep problematic rules in Audit mode
- Add exclusions for legitimate applications if needed

**Automated Deployment:**

```powershell
# Week 7-9: Deploy in Audit mode
.\Enable-ASRRules.ps1 -RuleSet "SMB-Recommended" -Mode "Audit"

# Week 10-12: Switch to Block mode
.\Enable-ASRRules.ps1 -RuleSet "SMB-Recommended" -Mode "Block" -ReviewPeriodDays 14
```

#### 3.3 Monitoring ASR Events

**Check Impact Before Enforcement:**

1. Navigate to: Microsoft 365 Defender portal → Reports → Attack surface reduction rules
2. Review "Detections" tab (events that would have been blocked)
3. Identify false positives:
   - Legitimate applications flagged
   - Business-critical processes blocked
4. Add exclusions:
   - File paths: `C:\Program Files\LegitimateApp\app.exe`
   - Processes: `legitapp.exe`

---

### Step 4: Configure Microsoft Intune Enrollment (1-2 hours)

#### 4.1 Enrollment Methods

**Method 1 - Windows Autopilot (Recommended for new devices):**
- Pre-configure devices before user receives them
- Zero-touch deployment
- Setup: Collect hardware hashes, upload to Intune

**Method 2 - User-driven enrollment (Existing devices):**
- Users navigate to Settings → Accounts → Access work or school → Connect
- Enter work credentials, device auto-enrolls
- Simplest for existing device fleets

**Method 3 - Bulk enrollment (50+ devices simultaneously):**
- Create provisioning package
- Deploy via USB or network

#### 4.2 Enrollment Restrictions (BYOD Control)

**Policy:** Control which devices can enroll

**Settings:**
- **Platform restrictions:**
  - Allow: Windows, iOS/iPadOS, macOS, Android
  - Block: Personally owned devices (optional - enforce corporate-owned only)
- **Device limit:** Maximum 15 devices per user (prevent abuse)

**Configure:** Intune admin center → Devices → Enrollment restrictions

---

### Step 5: Patch Management Automation (1 hour)

#### 5.1 Windows Update for Business

**Objective:** Automate OS and software updates without manual intervention.

**Update Rings (Recommended Configuration):**

**Ring 1 - IT Pilot Group (10% of devices):**
- Quality updates (security): **0 days deferral** (immediate)
- Feature updates (new Windows versions): **30 days deferral**
- Assigned to: IT staff, early adopters

**Ring 2 - Production (90% of devices):**
- Quality updates: **7 days deferral** (wait for IT pilot validation)
- Feature updates: **90 days deferral** (wait for broad compatibility)
- Assigned to: All other users

**Maintenance Windows:**
- Active hours: 8:00 AM - 6:00 PM (no automatic restarts)
- Deadline: Force restart after 7 days if pending reboot

**Configure:**
```powershell
# Automated setup
.\Configure-WindowsUpdateRings.ps1 -PilotGroupPercent 10 -QualityUpdateDeferralDays 7
```

#### 5.2 Third-Party Application Updates

**Microsoft Intune - Win32 App Management:**
- Deploy applications via Intune (Chrome, Adobe Reader, etc.)
- Configure auto-update where available
- Monthly review for outdated apps

---

### Step 6: Mobile Application Management (MAM) - BYOD (1-2 hours)

#### 6.1 App Protection Policies

**Scenario:** Employees use personal devices (BYOD) to access company data.

**MAM vs. MDM:**
- **MAM (App Protection):** Control company data within apps (email, OneDrive) without managing entire device
- **MDM (Device Management):** Full device control (compliance, encryption, wipe)

**Recommendation:** MAM for BYOD, MDM for corporate-owned

**Policy Settings - iOS/Android:**
- **Data protection:**
  - Prevent "Save As" to personal cloud storage
  - Prevent backup of company data
  - Encrypt app data
- **Access requirements:**
  - Require PIN or biometric to open app
  - Require corporate credentials (re-auth every 30 minutes)
- **Conditional launch:**
  - Block if device is jailbroken/rooted
  - Block if minimum OS version not met
  - Wipe company data if app unused for 90 days

**Configure:**
```powershell
.\Create-AppProtectionPolicies.ps1 -Platform "iOS,Android" -DataProtectionLevel "Standard"
```

---

## Verification and Validation

### Post-Implementation Checklist

- [ ] **Defender Coverage:** 95%+ devices onboarded and active
- [ ] **Compliance Policies:** Windows, macOS, iOS, Android policies deployed
- [ ] **Compliance Rate:** 90%+ devices compliant within 14 days
- [ ] **ASR Rules:** Enabled in Audit mode (weeks 7-9), Block mode (weeks 10-12)
- [ ] **ASR False Positives:** <5 false positives per 100 devices
- [ ] **Intune Enrollment:** Auto-enrollment configured for new devices
- [ ] **Patch Management:** Update rings configured, 95%+ devices patched within 30 days
- [ ] **MAM Policies:** App protection policies deployed for iOS/Android
- [ ] **Secure Score:** +10-15 point increase documented
- [ ] **User Impact:** <3 help desk tickets per 100 devices per week

---

## Troubleshooting Guide

### Issue 1: Devices Not Appearing in Defender Portal

**Symptom:** Device onboarded but not visible in Microsoft 365 Defender portal → Devices

**Diagnosis:**
- Check device internet connectivity
- Verify Windows Defender Antivirus service running: `Get-Service WinDefend`
- Check sensor health: `C:\Program Files\Windows Defender\MpCmdRun.exe -validatemapsconnection`

**Resolution:**
- Restart Windows Defender Advanced Threat Protection service
- Re-run onboarding script
- Check firewall allows `*.securitycenter.windows.com`

### Issue 2: ASR Rule Blocking Legitimate Application

**Symptom:** User reports "Application won't run" or "Access denied" after ASR enabled

**Diagnosis:**
- Check Defender event logs: Event Viewer → Applications and Services Logs → Microsoft → Windows → Windows Defender → Operational
- Look for Event ID 1121 (ASR block) or 1122 (ASR audit)

**Resolution:**
- **Short-term:** Add file/process exclusion to ASR rule
- **Long-term:** Contact application vendor for modern authentication support
- Document as technical debt if exclusion permanent

### Issue 3: Device Non-Compliant - BitLocker Not Enabled

**Symptom:** Device marked non-compliant, reason: "BitLocker not enabled"

**Resolution (Admin-initiated):**
1. Intune admin center → Devices → Configuration profiles → Create profile
2. Platform: Windows 10 and later, Profile: Endpoint protection
3. Windows Encryption → Encrypt devices: Require
4. Assign to devices, BitLocker auto-enables on next check-in (requires TPM 1.2+)

**Resolution (User-initiated):**
- Settings → Update & Security → Device encryption → Turn on

---

## Compliance Mapping

### NIST Cybersecurity Framework

| NIST Function | Implementation |
|---------------|----------------|
| **Protect (PR.AC-3)** | Device compliance enforces access controls |
| **Protect (PR.DS-1)** | BitLocker encryption protects data at rest |
| **Protect (PR.PT-3)** | Patch management ensures least vulnerability exposure |
| **Detect (DE.CM-4)** | Defender for Endpoint detects malicious code |
| **Respond (RS.MI-3)** | Automated containment and response |

### GDPR Article 32

| Requirement | Implementation |
|-------------|----------------|
| Encryption | BitLocker (data at rest), TLS (data in transit) |
| Ability to restore availability | Device backup, remote wipe/restore |
| Regular testing | ASR audit mode testing, compliance monitoring |

---

## Next Steps

**Upon Completion of Module 2:**

1. **Verify Coverage:** 95%+ devices onboarded, compliant, protected
2. **Communicate Success:** Executive summary with Secure Score improvement
3. **Schedule Phase 3:** Module 3 - Data Governance (Weeks 13-20)

---

**Module 2 Complete - Endpoint Protection Deployed ✅**

**Proceed to Module 3: Data Governance** (Weeks 13-20)
