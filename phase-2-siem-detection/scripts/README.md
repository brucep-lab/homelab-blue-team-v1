# PowerShell Anomaly Detection Scripts

This folder contains two scripts used to simulate lightweight host-based anomaly detection in a Windows environment. The goal is to detect suspicious process activity by comparing the current state against a known-good baseline.

---

## Files Included

### `baseline_script.ps1`
Captures a snapshot of currently running processes and stores them in a CSV baseline file.

### `detect_deviations.ps1`
Compares current running processes against the baseline. Outputs a list of deviations for review or Splunk ingestion.

---

## ⚙️ How to Use

### Step 1: Establish a Baseline

Run `baseline.ps1` on a clean or freshly booted system.

```powershell
.\baseline.ps1 -OutputPath "baseline.csv"
This will save a file like:
```
```
Name,Path,Hash,ParentProcess
explorer.exe,C:\Windows\explorer.exe,D6F43A...,winlogon.exe
...
```

---

### Step 2: Run a Comparison

Later, run `compare.ps1` to detect deviations:

```
.\compare.ps1 -BaselinePath "baseline.csv" -OutputPath "deviations.csv"
```

This outputs a list of processes that:
- Were not in the original baseline
- Are running from unusual locations (e.g., `%AppData%`, `%Temp%`)
- (Planned) Are unsigned or have suspicious parents

---

## 📝 Output Format

Example `deviations.csv`:

```
Name,Path,ParentProcess,DeviationType
weird.exe,C:\Users\Bruce\AppData\weird.exe,explorer.exe,NotInBaseline+AppDataPath
```

---

## 🧠 Tips

- Run the baseline script after system boot and before launching apps or services.
- You can schedule the comparison script using Task Scheduler to run every X minutes.
- Use Splunk’s file monitor or HEC to forward the `deviations.csv` into your SIEM.

---

## 🔒 Disclaimer

These scripts are for homelab and educational use only. They do not replace a real EDR and may generate false positives. Tuning and context-aware logic are encouraged.
