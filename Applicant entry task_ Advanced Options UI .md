## Applicant entry task: Advanced Options UI (Flutter overflow menu \+ dialog)

## **Goal**

In **Paintroid-Flutter**, add an **“Advanced Options”** entry to the editor’s **overflow menu** that opens a dialog letting the user **enable/disable**:

* **Antialiasing**  
* **Smoothing**

Both options must be **disabled by default**.

This is an **entry task (UI \+ state only)**: implement the menu item, dialog, and persistent storage of the toggle states. **Do not implement the actual drawing/rendering changes** yet.

**Where to start**

* Repository: [https://github.com/Catrobat/Paintroid-Flutter](https://github.com/Catrobat/Paintroid-Flutter) (work on `develop`). ([GitHub](https://github.com/Catrobat/Paintroid-Flutter?utm_source=chatgpt.com))  
* UI should match the **old Android native Paintroid** behavior/layout as closely as reasonable: [https://github.com/Catrobat/Paintroid](https://github.com/Catrobat/Paintroid) ([GitHub](https://github.com/Catrobat/Paintroid?utm_source=chatgpt.com))  
* Do not ask “where should I implement this?” — finding the best integration point is part of the task.

---

## **Requirements**

### **1\) Add a new overflow menu entry: “Advanced Options”**

In the editor screen overflow menu (⋮), add a new entry:

* **Label:** `Advanced Options`  
* **Placement:** alongside other settings/configuration actions (typically lower section)

**Behavior:** opens the dialog described below.

### **2\) Dialog: two toggles \+ OK**

When `Advanced Options` is tapped, show a dialog with:

* Title: `Advanced Options`  
* Two toggles  
  * `Antialiasing`  
  * `Smoothing`  
* Buttons:  
  * `OK`  
  * `CANCEL`

Constraints:

* Keep it simple and clean.  
* Must be accessible (labels readable; tappable rows).  
* On first launch (no prior stored values), both toggles are **OFF**.

---

## **Tests (mandatory)**

### **A) Widget test (Flutter) for the UI flow**

Write **one** widget test (keep it light) that:

* Opens the overflow menu  
* Taps `Advanced Options`  
* Asserts the dialog is shown and contains both toggle labels  
* Asserts defaults OFF   
* Toggles at least one switch  
* Taps `OK`

Notes:

* Don’t over-test Flutter framework behavior; test what you added.

---

## **Engineering style / process**

* **TDD commit history is mandatory:** tests first (red) → minimal implementation (green) → refactor  
* Multiple small commits with meaningful messages; no squashing  
* Clean code: clear naming, small functions, minimal duplication

---

## **Build & CI**

* Branch compiles, tests pass  
* Provide a green GitHub Actions run link from your fork

---

## **Submission format (no PR to main repo)**

Fork → branch from `develop` → push → provide:

* branch link  
* compare link (`develop…your-branch`)  
* CI run link(s)  
* coverage artifact \+ “how generated”

---

## **Required demo artifacts**

Screen recording showing:

* Open overflow menu (⋮)  
* Tap **Advanced Options**  
* Show dialog with **Antialiasing** \+ **Smoothing** toggles and **OK**  
* Toggle settings → OK dismisses  
* Show tests green

---

