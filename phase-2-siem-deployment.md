# Phase 2: SIEM Deployment & Host-Based Detection Pipeline

## Overview
- What was built
  - In this phase, I deployed a centralized SIEM using Splunk, forwarded logs from a domain controller, and built a lightweight detection pipeline using PowerShell.    
- What this phase accomplishes
  - The goal was to practice end-to-end detection engineering, from data collection to alerting, while simulating realistic host-based monitoring without commercial EDR tools.
- Tools used
  -  Ubuntu (Splunk server), Windows Server (Universal Forwarder), PowerShell, CSV, Splunk Web Interface
---

## Splunk Deployment (Summarized)
- OS used + installation method
- Bridged network config (generic)
- Confirming the web UI is working

---

## Log Forwarding (Summarized)
- Universal Forwarder setup on AD-DC1
- Logs collected (Security, System)
- Screenshot of event logs arriving in Splunk

---

## Detection Engineering: PowerShell + Splunk Pipeline

### Overview
- What the pipeline does
- Why was it built
- Summary of behavior-based detection vs. event log–based

### 1. Baseline Collection (`baseline.ps1`)
- When to run it (clean system state)
- What it collects: process name, path, hash, parent PID
- Output format (e.g., JSON or CSV)

Link to script: [`/scripts/baseline.ps1`](./scripts/baseline.ps1)

---

### 2. Comparison Logic (`compare.ps1`)
- When/how it runs (manual, scheduled, etc.)
- What it checks:
  - Process not in baseline
  - Executed from a strange path
  - Unsigned binary
  - Weird parent-child chain
- Scoring or filtering logic (basic or planned)
- Output format

Link to script: [`/scripts/compare.ps1`](./scripts/compare.ps1)

---

### 3. Sending to Splunk
- File-based forwarding or HTTP Event Collector (HEC)
- How the logs are indexed
- SPL example for visualizing anomalies

**Screenshot:** Splunk dashboard panel showing deviations

---

## Reflections & Next Steps
- Tuning for noise reduction
- Plan to add network or persistence detection
- Future correlation with Phase 3 adversary simulation


