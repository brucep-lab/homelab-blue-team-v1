# Phase 2: SIEM Deployment & Host-Based Detection Pipeline

## Overview

- **What was built?**  
  A centralized SIEM using Splunk Enterprise on Ubuntu, with Windows event log forwarding from a domain controller (AD-DC1), and a custom PowerShell-based detection pipeline to flag anomalous process activity.

- **What this phase accomplishes**  
  Simulates a realistic detection engineering workflow, from log ingestion to behavior-based alerting, without relying on commercial EDR tools. This phase bridges system visibility with custom-built detection logic.

- **Tools used**  
  Ubuntu (Splunk server), Windows Server (Universal Forwarder), PowerShell, CSV, Splunk Web Interface

---

## Splunk Deployment

Splunk Enterprise was deployed on a dedicated Ubuntu VM using the `.deb` package.

- The VM was configured with a static private IP on a bridged network: `<splunk_server_ip>` (ex: 192.168.126.75)
- Splunk's web UI was made accessible via `http://<splunk_server_ip>:8000` (ex: http://192.168.126.65:8000)
- Admin interface confirmed working from the Windows client machine

**Screenshot to come:** Splunk login screen accessed from WIN-CL1

---

## Log Forwarding

To start collecting logs from domain-joined systems:

- Installed Splunk Universal Forwarder on `AD-DC1` (Windows Server 2022)
- Forwarded Windows Security and System logs to Splunk using inputs.conf and outputs.conf
- Verified ingestion into `index=wineventlog`

**Screenshot:** Example logs from AD-DC1 showing up in Splunk

---

## Event Log Alerts (Windows-Sourced)

Before building custom detection logic, I configured six detection rules using forwarded Windows event logs:

### 1. Excessive Failed Logon Attempts
- **EventCode:** `4625`
- **Logic:** 5+ failed logons per user within a short window

### 2. User Added to Local Administrators Group
- **EventCodes:** `4728`, `4732`, `4756`
- **Logic:** Flags addition of users to privileged groups (Domain Admins, etc.)

### 3. Successful Logon by Rare Account
- **EventCode:** `4624`
- **Logic:** Alerts when a user not seen in prior logons authenticates successfully

### 4. Security Log Cleared
- **EventCode:** `1102`
- **Logic:** Detects audit tampering or cover-up attempts

### 5. Service Creation
- **EventCode:** `7045`
- **Logic:** Tracks installation of new services, often used for persistence

### 6. Scheduled Task Creation
- **EventCode:** `4698`
- **Logic:** Flags new scheduled tasks that may indicate lateral movement or persistence

These alerts laid the groundwork for behavior-based detection in the next section.

---

## Detection Engineering: PowerShell + Splunk Pipeline

### Overview

To go beyond static event code detection, I developed a PowerShell-based pipeline that monitors host process activity and flags deviations from a known-good baseline. This simulates basic endpoint detection functionality using native tools.

---

### 1. Baseline Collection (`baseline.ps1`)

This script captures a snapshot of expected process activity immediately after boot, before launching any user-facing services or tools.

**Collected fields:**
- Process name
- Executable path
- SHA256 hash
- Parent process ID (PPID)

**Output:** CSV (`baseline.csv`)

**Link:** [`/scripts/baseline.ps1`](./scripts/baseline.ps1)

---

### 2. Comparison Logic (`compare.ps1`)

This script checks currently running processes against the baseline. It flags deviations based on:

- Process not present in the baseline
- Executable running from suspicious paths (`%AppData%`, `%Temp%`, `C:\Users\Public`)
- Unsigned binaries (planned feature)
- Abnormal parent-child process relationships

**Output:** CSV (`deviations.csv`)

**Link:** [`/scripts/compare.ps1`](./scripts/compare.ps1)

---

### 3. Sending to Splunk

Logs from `compare.ps1` are sent to Splunk in two ways:
- Monitored via file-based input (watching the output directory)
- (Optional) Sent via HTTP Event Collector (HEC) for near-real-time ingestion

```spl
index=ps_anomalies sourcetype=deviation_log 
| stats count by process_name, path, score, host
| sort -count
```
This SPL query surfaces the most frequent anomalous processes detected by the comparison script and forwarded to Splunk.
