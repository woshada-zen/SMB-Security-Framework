# Data Classification Quick Guide

**Which Label Should I Use? | 1-Page Reference**

---

## 📊 5 Classification Levels

| Level | Label | Use For | Can Share Externally? | Examples |
|-------|-------|---------|----------------------|----------|
| **0** | 🟢 **Public** | Information intended for public disclosure | ✓ Yes, freely | Marketing materials, press releases, job postings, public website content |
| **1** | 🔵 **Internal** | General business info for internal use | ⚠️ With approval only | Internal memos, project plans, meeting notes, policies, org charts |
| **2** | 🟡 **Confidential** | Sensitive business information | ⚠️ Encrypted + approval | Customer contracts, financial reports, vendor agreements, employee contact lists |
| **3** | 🟠 **Highly Confidential** | Critical information, severe impact if disclosed | ❌ Prohibited (rare exceptions) | M&A documents, board minutes, executive compensation, trade secrets, salary data |
| **4** | 🔴 **Restricted** | Legally/regulatory restricted data | ❌ Prohibited (legal approval only) | Personal data (GDPR), payment card data (PCI), health records, bank account numbers |

---

## 🏷️ How to Apply Labels in Microsoft 365

### In Outlook (Email):
1. Compose new email
2. Click **"Sensitivity"** button (top ribbon)
3. Select appropriate label
4. Label applies header/footer and encryption (if needed)

### In Word/Excel/PowerPoint:
1. Open document
2. Click **"Sensitivity"** button (top ribbon or File > Info)
3. Select appropriate label
4. Save document (label embedded)

### In OneDrive/SharePoint:
1. Right-click file
2. Select **"Classify and protect"**
3. Choose label
4. Label applies to file

---

## 🤔 Decision Tree: Which Label?

```
START: Does this document contain...

├─ Personal data (names, emails, IDs, financials)?
│  └─ YES → 🔴 RESTRICTED
│
├─ Payment card data (credit cards, bank accounts)?
│  └─ YES → 🔴 RESTRICTED
│
├─ Trade secrets, M&A info, executive compensation?
│  └─ YES → 🟠 HIGHLY CONFIDENTIAL
│
├─ Customer contracts, financial reports, strategic plans?
│  └─ YES → 🟡 CONFIDENTIAL
│
├─ Internal processes, project plans, meeting notes?
│  └─ YES → 🔵 INTERNAL
│
└─ Public marketing, press releases, public website content?
   └─ YES → 🟢 PUBLIC
```

---

## 📧 Email Sharing Rules

| Classification | To Internal | To External (Customer/Partner) | To Personal Email |
|----------------|-------------|-------------------------------|-------------------|
| 🟢 Public | ✓ Allowed | ✓ Allowed | ✓ Allowed |
| 🔵 Internal | ✓ Allowed | ⚠️ Manager approval + label applied | ❌ Prohibited |
| 🟡 Confidential | ✓ Allowed | ⚠️ Encrypted + NDA required | ❌ Prohibited |
| 🟠 Highly Confidential | ⚠️ Need-to-know only | ❌ Prohibited (executive approval) | ❌ Prohibited |
| 🔴 Restricted | ⚠️ Need-to-know + logged | ❌ Prohibited (legal/DPO approval) | ❌ Prohibited |

**Use OneDrive sharing links (not email attachments) for Confidential+ files**

---

## 💾 File Sharing Best Practices

### ✓ DO:
- Apply sensitivity label BEFORE sharing
- Use OneDrive/SharePoint sharing links (with expiration)
- Set "Specific people" (not "Anyone with link")
- Use password protection for Confidential+ files
- Check recipient email carefully before sending

### ❌ DON'T:
- Send Confidential+ files to personal email (Gmail, Yahoo)
- Use public file sharing (WeTransfer, Dropbox for work files)
- Share via USB drives (unless encrypted)
- Remove or downgrade labels without justification
- Screenshot/print Restricted data unnecessarily

---

## 🗂️ Examples by Department

### Finance Team:
- Budget spreadsheet: 🟡 Confidential
- Customer invoice: 🟡 Confidential
- Payroll data: 🔴 Restricted (personal data)
- Public financial statements: 🟢 Public

### HR Team:
- Job description: 🟢 Public
- Employee handbook: 🔵 Internal
- Employee contact list: 🟡 Confidential
- Performance reviews: 🔴 Restricted (personal data)
- Salary spreadsheet: 🟠 Highly Confidential

### Sales Team:
- Product brochure: 🟢 Public
- Sales presentation: 🔵 Internal
- Customer contract: 🟡 Confidential
- Pricing strategy: 🟡 Confidential
- Customer personal data (CRM): 🔴 Restricted

### IT Team:
- User guide: 🔵 Internal
- Network diagram: 🟡 Confidential
- Admin passwords: 🟠 Highly Confidential
- Security policies: 🔵 Internal

---

## ⚠️ What Happens If I Mislabel?

**Label Too High (over-classification):**
- Unnecessary restrictions on sharing
- Reduced productivity
- But better safe than sorry!

**Label Too Low (under-classification):**
- Risk of data breach
- GDPR violations (if personal data)
- Disciplinary action if intentional
- **When in doubt, classify higher**

---

## ❓ FAQs

**Q: Do I have to label EVERY document?**
A: Yes, all business documents and emails should be labeled. Default: Internal

**Q: Can I change a label after applying it?**
A: Yes, but downgrades (e.g., Confidential → Internal) require justification and are logged

**Q: What if I receive an unlabeled document from a colleague?**
A: Apply appropriate label before sharing further. Remind colleague to label.

**Q: Are labels required for personal files on company devices?**
A: No, labels only for work-related documents.

**Q: What if I'm not sure which label to use?**
A: Ask your manager, data owner, or IT Security. When in doubt, use higher classification.

---

## 📞 Need Help?

**Questions about classification:**
- Your manager or department head
- Data owner (varies by data type)
- IT Security: [email/phone]

**Technical issues with labeling:**
- IT Help Desk: [email/phone]

**Policy questions:**
- See Data Classification Policy: [intranet link]

---

**License:** CC BY-SA 4.0 | **Version:** 1.0 | **Last Updated:** [Date]
**Related Training:** Video 05 - Classifying and Labeling Documents
**Policy:** Data Classification Policy, Master Information Security Policy

---

*Print this guide. Laminate and keep at your desk.*
*Download color version: [intranet link]*
