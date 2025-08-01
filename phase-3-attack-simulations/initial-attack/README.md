# Phase 3: Attack Simulations - Initial Attack

This section documents my first simulated attack within the homelab environment. 
The purpose of Phase 3 is to evaluate detection and response readiness by simulating realistic attacks, analyzing telemetry, and documenting outcomes—mirroring what a SOC analyst would face during early stages of compromise.

---

## Subphase: First Simulated Attack - Brute Force Login (T1110)

### Objective
To verify that:
1. An external attacker machine (Kali Linux) can reach and attempt login to the Windows 10 client (WIN-CL1)
2. The domain controller (AD-DC1) correctly logs these events and forwards them to the SIEM (Splunk)
3. View the triggered alert on Splunk via AD-DC1

---

### 🛠️ Setup Overview
- **Attacker Machine:** Kali Linux (192.168.x.xx)
- **Target Machine:** WIN-CL1 (local Windows 10 endpoint)
- **User Account Created:** `bruteuser`,
- **Password:** `BruteForce123!`
- **Tool Used:** CrackMapExec

Password list included 5 incorrect passwords and 1 correct entry to emulate a successful brute-force login pattern.

---

### Command Used (from Kali)
`
crackmapexec smb 192.168.1.20 -u bruteuser -p bruteuser-passwordlist.txt -d .
`
- \`-u\`: specifies the target username
- \`-p\`: points to a password list file containing guesses
- \`-d .\`: forces local (non-domain) authentication

> Note: A "+" sign in the CrackMapExec output indicated a valid credential, even if no session was established.

---

### Detection in Splunk
Splunk successfully ingested both failed and successful login attempts:

- **Event ID 4625:** Failed login attempts
- **Event ID 4624:** Successful login (when correct password was reached)

A preconfigured alert fired once the system detected multiple 4625s within a 15-minute window—validating the detection rule.

---

### Summary of Results
| Step | Goal | Outcome |
|------|------|---------|
| 1 | External machine attempts login to WIN-CL1 | ✅ Confirmed via network and log analysis |
| 2 | Detection triggered in Splunk (AD-DC1 logs forwarded) | ✅ Alert successfully fired |

---

### Lessons Learned
- Including one correct password in the brute-force attempt improves realism and shows detection workflows more clearly.
- Using \`-d .\` in CME is necessary for local account testing.
- Detection rules can be refined further to include sequences like "X failures followed by 1 success" for better signal clarity.
- More experience is needed to continue increasing the understanding of attacker methodology

---

