# Security Maturity Scorecard

**Purpose:** Visual dashboard for tracking security posture improvement over time
**Target Audience:** IT Director, CISO, Executive Management, Board of Directors
**Update Frequency:** Quarterly
**Format:** Export to Excel/PowerBI for visual dashboards

---

## Scorecard Overview

This scorecard provides a simplified, executive-friendly view of organizational security maturity across 5 key domains. Use this alongside the detailed Baseline Security Questionnaire for comprehensive assessment.

---

## Maturity Model (5 Levels)

| Level | Score | Description | Characteristics |
|-------|-------|-------------|-----------------|
| **Level 1: Initial** | 0-20% | Ad-hoc, reactive | No formal processes, reliance on individual heroes, frequent incidents |
| **Level 2: Developing** | 21-40% | Basic controls | Some policies exist, inconsistent enforcement, manual processes |
| **Level 3: Defined** | 41-60% | Documented processes | Policies documented and communicated, some automation, regular reviews |
| **Level 4: Managed** | 61-80% | Measured & controlled | Metrics-driven, proactive threat hunting, automation, continuous improvement |
| **Level 5: Optimized** | 81-100% | Industry-leading | Innovation, predictive analytics, security as competitive advantage |

**Target for SMBs:** Level 4 (Managed) within 12 months of implementing framework

---

## Domain 1: Identity & Access (25 points)

### Assessment Criteria

| # | Control | Maturity Indicators | Score (0-5) |
|---|---------|---------------------|-------------|
| 1.1 | **Multi-Factor Authentication** | 0=Not deployed<br>1=<25% users<br>2=25-50% users<br>3=51-75% users<br>4=76-99% users<br>5=100% enforced | ___ |
| 1.2 | **Conditional Access** | 0=None<br>1=Planning<br>2=1-2 policies (Report-Only)<br>3=3-5 policies (Enabled)<br>4=6+ policies, tuned<br>5=Full policy set, optimized | ___ |
| 1.3 | **Password Protection** | 0=No policy<br>1=Basic policy (8 char)<br>2=Strong policy (12+ char)<br>3=Banned password list<br>4=SSPR enabled<br>5=Passwordless options | ___ |
| 1.4 | **Privileged Access Management** | 0=Shared admin accounts<br>1=Separate admin accounts<br>2=Limited admin count<br>3=Just-in-time (JIT) access<br>4=PAM solution deployed<br>5=Full PIM with audit | ___ |
| 1.5 | **Access Reviews** | 0=Never<br>1=Annual, manual<br>2=Quarterly, manual<br>3=Quarterly, semi-automated<br>4=Monthly, automated alerts<br>5=Continuous, auto-revocation | ___ |

**Domain 1 Total:** ___/25 = ___%

**Maturity Level:** _______________

---

## Domain 2: Endpoint Protection (20 points)

### Assessment Criteria

| # | Control | Maturity Indicators | Score (0-5) |
|---|---------|---------------------|-------------|
| 2.1 | **Device Management (MDM)** | 0=No MDM<br>1=<25% enrolled<br>2=25-50% enrolled<br>3=51-75% enrolled<br>4=76-99% enrolled<br>5=100% enrolled, enforced | ___ |
| 2.2 | **Endpoint Security (EDR)** | 0=No antivirus<br>1=Basic AV only<br>2=Defender for Endpoint (audit)<br>3=Defender + ASR (audit)<br>4=Defender + ASR (block)<br>5=Full EDR + auto-remediation | ___ |
| 2.3 | **Device Compliance** | 0=No policies<br>1=Policies defined<br>2=Policies deployed (warn)<br>3=Policies enforced (block)<br>4=Compliance monitored weekly<br>5=Compliance >95%, auto-remediation | ___ |
| 2.4 | **Patch Management** | 0=Manual, reactive<br>1=Monthly patching<br>2=Auto-update enabled<br>3=Patching within 14 days<br>4=Patching within 7 days<br>5=Patching within 48 hours, monitored | ___ |

**Domain 2 Total:** ___/20 = ___%

**Maturity Level:** _______________

---

## Domain 3: Data Governance (20 points)

### Assessment Criteria

| # | Control | Maturity Indicators | Score (0-5) |
|---|---------|---------------------|-------------|
| 3.1 | **Data Classification** | 0=No classification<br>1=Policy exists<br>2=Labels deployed<br>3=Users trained, 25% labeled<br>4=50% labeled, auto-label rules<br>5=80%+ labeled, enforced | ___ |
| 3.2 | **Data Loss Prevention (DLP)** | 0=No DLP<br>1=DLP policies defined<br>2=DLP deployed (test mode)<br>3=DLP enforced (1-2 policies)<br>4=DLP enforced (3-5 policies)<br>5=Comprehensive DLP, tuned | ___ |
| 3.3 | **External Sharing Controls** | 0=Unrestricted<br>1=Manual approval process<br>2=Default: disabled<br>3=Restricted with expiration<br>4=DLP blocks sensitive sharing<br>5=Zero external sharing, alternatives | ___ |
| 3.4 | **GDPR Compliance** | 0=Not addressed<br>1=Awareness only<br>2=Data inventory started<br>3=DPAs with vendors<br>4=Data subject rights process<br>5=Full compliance, audited | ___ |

**Domain 3 Total:** ___/20 = ___%

**Maturity Level:** _______________

---

## Domain 4: Security Monitoring (20 points)

### Assessment Criteria

| # | Control | Maturity Indicators | Score (0-5) |
|---|---------|---------------------|-------------|
| 4.1 | **Logging & Retention** | 0=No centralized logs<br>1=30-day retention<br>2=90-day retention<br>3=365-day retention<br>4=SIEM with correlation<br>5=SIEM + SOAR, >365 days | ___ |
| 4.2 | **Threat Detection** | 0=No monitoring<br>1=Manual log reviews<br>2=Basic alerts (email)<br>3=Analytics rules (10+)<br>4=Advanced analytics (ML)<br>5=Threat hunting, proactive | ___ |
| 4.3 | **Incident Response** | 0=No plan<br>1=Plan documented<br>2=IRT identified<br>3=Plan tested (tabletop)<br>4=Playbooks automated<br>5=MTTR <2 hours, tested quarterly | ___ |
| 4.4 | **Vulnerability Management** | 0=No scanning<br>1=Annual scans<br>2=Quarterly scans<br>3=Monthly scans + remediation<br>4=Continuous scanning<br>5=Auto-remediation, <7 days | ___ |

**Domain 4 Total:** ___/20 = ___%

**Maturity Level:** _______________

---

## Domain 5: Governance & Culture (15 points)

### Assessment Criteria

| # | Control | Maturity Indicators | Score (0-5) |
|---|---------|---------------------|-------------|
| 5.1 | **Security Policies** | 0=None<br>1=1-2 policies exist<br>2=5+ policies, outdated<br>3=Comprehensive, annual review<br>4=Comprehensive, acknowledged<br>5=Living policies, continuous improvement | ___ |
| 5.2 | **Security Awareness Training** | 0=None<br>1=Ad-hoc<br>2=Annual training<br>3=Annual + phishing sims<br>4=Quarterly sims, <15% click<br>5=Continuous training, <10% click | ___ |
| 5.3 | **Executive Engagement** | 0=None<br>1=Annual briefing<br>2=Quarterly updates<br>3=Monthly metrics<br>4=Board-level reporting<br>5=CISO on exec team, strategic partner | ___ |

**Domain 5 Total:** ___/15 = ___%

**Maturity Level:** _______________

---

## Overall Maturity Score

### Summary Table

| Domain | Score | Max | Percentage | Maturity Level |
|--------|-------|-----|------------|----------------|
| 1. Identity & Access | ___ | 25 | ___% | _______________ |
| 2. Endpoint Protection | ___ | 20 | ___% | _______________ |
| 3. Data Governance | ___ | 20 | ___% | _______________ |
| 4. Security Monitoring | ___ | 20 | ___% | _______________ |
| 5. Governance & Culture | ___ | 15 | ___% | _______________ |
| **TOTAL** | **___** | **100** | **___%** | **_______________** |

### Visual Representation (Radar Chart)

```
Create radar chart with 5 axes (one per domain)
Plot current score vs. target score (Level 4 = 80%)

Example:
        Identity (80%)
            /\
           /  \
 Culture /    \ Endpoint
   (60%)|      | (70%)
         \    /
          \  /
      Monitoring --- Data
        (50%)      (65%)
```

### Maturity Progression Roadmap

**Current State:** Level ___ (__%)

**Target State:** Level 4 (Managed, 80%)

**Gap:** ___ points (__%)

**Estimated Timeline:**
- Level 1 → Level 2: 1-2 months
- Level 2 → Level 3: 2-4 months (SMB Framework Phases 1-2)
- Level 3 → Level 4: 3-6 months (SMB Framework Phases 3-4)
- Level 4 → Level 5: 6-12 months (optimization)

---

## Quarterly Progress Tracking

### Q1 [Year] Baseline

| Domain | Score | % |
|--------|-------|---|
| Identity | ___ | ___% |
| Endpoint | ___ | ___% |
| Data | ___ | ___% |
| Monitoring | ___ | ___% |
| Governance | ___ | ___% |
| **Total** | **___** | **___%** |

### Q2 [Year] Progress

| Domain | Score | % | Change |
|--------|-------|---|--------|
| Identity | ___ | ___% | +/- __% |
| Endpoint | ___ | ___% | +/- __% |
| Data | ___ | ___% | +/- __% |
| Monitoring | ___ | ___% | +/- __% |
| Governance | ___ | ___% | +/- __% |
| **Total** | **___** | **___%** | **+/- __% ** |

### Q3 [Year] Progress

| Domain | Score | % | Change |
|--------|-------|---|--------|
| Identity | ___ | ___% | +/- __% |
| Endpoint | ___ | ___% | +/- __% |
| Data | ___ | ___% | +/- __% |
| Monitoring | ___ | ___% | +/- __% |
| Governance | ___ | ___% | +/- __% |
| **Total** | **___** | **___%** | **+/- __%** |

### Q4 [Year] Final

| Domain | Score | % | Change | Annual Improvement |
|--------|-------|---|--------|-------------------|
| Identity | ___ | ___% | +/- __% | +/- __% (vs. Q1) |
| Endpoint | ___ | ___% | +/- __% | +/- __% (vs. Q1) |
| Data | ___ | ___% | +/- __% | +/- __% (vs. Q1) |
| Monitoring | ___ | ___% | +/- __% | +/- __% (vs. Q1) |
| Governance | ___ | ___% | +/- __% | +/- __% (vs. Q1) |
| **Total** | **___** | **___%** | **+/- __%** | **+/- __% (vs. Q1)** |

---

## Benchmarking

### Industry Comparison (SMBs in [Industry/Region])

| Domain | Your Score | Industry Average | Top Quartile | Gap to Top Quartile |
|--------|------------|------------------|--------------|---------------------|
| Identity | ___% | 55% | 75% | ___ points |
| Endpoint | ___% | 50% | 70% | ___ points |
| Data | ___% | 45% | 65% | ___ points |
| Monitoring | ___% | 40% | 60% | ___ points |
| Governance | ___% | 50% | 70% | ___ points |
| **Overall** | **___%** | **48%** | **68%** | **___ points** |

**Sources:** Verizon DBIR 2024, Ponemon Institute SMB Cybersecurity Report, NCSC SMB Survey

**Goal:** Reach top quartile within 12 months

---

## Key Performance Indicators (KPIs)

### Leading Indicators (Proactive)

| KPI | Baseline | Current | Target | Status |
|-----|----------|---------|--------|--------|
| **MFA Adoption %** | ___% | ___% | 100% | 🔴/🟡/🟢 |
| **Devices in Compliance %** | ___% | ___% | 95% | 🔴/🟡/🟢 |
| **Documents Labeled %** | ___% | ___% | 80% | 🔴/🟡/🟢 |
| **Security Training Completion %** | ___% | ___% | 95% | 🔴/🟡/🟢 |
| **Phishing Click Rate %** | ___% | ___% | <10% | 🔴/🟡/🟢 |
| **Patch Compliance % (7 days)** | ___% | ___% | 95% | 🔴/🟡/🟢 |

### Lagging Indicators (Reactive)

| KPI | Baseline | Current | Target | Status |
|-----|----------|---------|--------|--------|
| **Security Incidents (monthly)** | ___ | ___ | <5 | 🔴/🟡/🟢 |
| **Mean Time to Detect (MTTD)** | ___ hrs | ___ hrs | <1 hr | 🔴/🟡/🟢 |
| **Mean Time to Respond (MTTR)** | ___ hrs | ___ hrs | <4 hrs | 🔴/🟡/🟢 |
| **Data Breaches (annual)** | ___ | ___ | 0 | 🔴/🟡/🟢 |
| **Microsoft Secure Score** | ___/1000 | ___/1000 | 700+ | 🔴/🟡/🟢 |

**Status:**
- 🔴 Red: >20% from target
- 🟡 Yellow: 10-20% from target
- 🟢 Green: Within 10% of target or achieved

---

## Risk Heat Map

### Current Risks by Domain

| Domain | Likelihood | Impact | Risk Score | Priority |
|--------|------------|--------|------------|----------|
| Identity (if no MFA) | High | Critical | 🔴 High | P1 |
| Endpoint (if no EDR) | High | High | 🔴 High | P1 |
| Data (if no DLP) | Medium | High | 🟡 Medium | P2 |
| Monitoring (if no SIEM) | Medium | Medium | 🟡 Medium | P2 |
| Governance (if no policies) | Low | Medium | 🟢 Low | P3 |

**Risk Calculation:**
- Critical + High Likelihood = P1 (Address immediately)
- High + Medium Likelihood = P2 (Address within 30 days)
- Medium + Low Likelihood = P3 (Address within 90 days)

---

## Maturity Acceleration Plan

### To Reach Level 4 (Managed) in 6 Months

**Month 1-2: Foundation (Phases 0-1)**
- Complete baseline assessment
- Secure executive sponsorship
- Implement MFA (100%)
- Deploy Conditional Access policies
- **Target:** Identity 60% (+20%), Overall 45% (+15%)

**Month 3-4: Protection (Phase 2)**
- Deploy Defender for Endpoint
- Enable ASR rules (audit → block)
- Enforce device compliance
- **Target:** Endpoint 70% (+25%), Overall 55% (+10%)

**Month 5-6: Governance & Monitoring (Phases 3-4)**
- Deploy sensitivity labels and DLP
- Implement Azure Sentinel
- Activate automated response
- **Target:** Data 65% (+25%), Monitoring 60% (+30%), Overall 70% (+15%)

**Target After 6 Months:**
- Overall Maturity: Level 4 (Managed, 70-75%)
- All domains: Minimum Level 3 (Defined, 60%+)
- Critical domains (Identity, Endpoint): Level 4 (80%+)

---

## Executive Summary Template

**For Board/Executive Presentations:**

> **Current Security Maturity:** Level ___ (__%)
>
> **Industry Average:** Level 2-3 (48%)
>
> **Target:** Level 4 (Managed, 80%) within 6-12 months
>
> **Investment Required:** £[X] over 6 months
>
> **Expected Outcomes:**
> - Reduce breach probability by 60%
> - Meet customer/partner security requirements
> - Achieve GDPR compliance
> - Reduce security incidents by 50%
>
> **Risks if No Action:**
> - 43% probability of successful cyber attack
> - Average breach cost: £200,000
> - 60% of SMBs don't survive major incident
> - Regulatory fines (GDPR: up to 4% revenue)
>
> **Recommendation:** Approve SMB Security Framework implementation to progress from Level ___ to Level 4.

---

## Next Steps

1. **Complete Scorecard:** Assess all 5 domains (19 criteria)
2. **Calculate Overall Maturity:** Determine current level
3. **Identify Gaps:** Highlight low-scoring criteria (<3)
4. **Set Targets:** Define 6-month and 12-month goals
5. **Present to Leadership:** Use executive summary and radar chart
6. **Implement Framework:** Follow SMB Security Framework phases
7. **Track Progress:** Re-assess quarterly, report to stakeholders

---

**License:** CC BY-SA 4.0
**Version:** 1.0
**Last Updated:** [Date]
**Framework:** Strategic Integration Framework for SMB Security
