# homelab-blue-team-v1
Simulating a corporate network to build and test blue team defenses in a personal homelab.
---

## Architecture Summary

The lab is hosted on VMware Workstation Pro 17. The environment consists of:

- **Windows Server 2022** (Active Directory Domain Controller)
- **Windows 10** (client workstation)
- **Ubuntu Server** (runs Splunk for SIEM)

Key technologies and tools used:
- **SIEM**: Splunk Enterprise
- **Logging**: Windows Event Logs
- **Administration**: Server Manager, Group Policy, PowerShell

---

## Use Cases / Objectives

- Build a real-world Active Directory domain
- Forward Windows logs to a centralized SIEM
- Tune detections for real signals—not noise
- Simulate internal attacks using Kali
- Practice basic incident response workflows
- Document findings like a SOC analyst or detection engineer

---

## Progress by Phase

- **Phase 1**: Set up Organizational Units (OUs), Group Policy Objects (GPOs), folder redirection, and role-based access controls.
- **Phase 2**: Installed Splunk, configured log forwarding from Windows Server and Client, and began tuning alerts.
- **Phase 3 (coming soon)**: Simulate attacks, analyze telemetry, respond as if in a live SOC scenario, and document outcomes.

---

## Tools & Skills Used

- **Operating Systems**: Windows Server, Windows 10, Ubuntu
- **Core Skills**: Group Policy Management, Windows Event Log analysis, PowerShell scripting, SIEM configuration
- **Tools**: Splunk, gpresult, Event Viewer, Server Manager

---

## Why This Matters: The Motivation

I recently graduated with a degree in Cybersecurity, and I know that classroom experience only scratches the surface. This lab is a self-driven initiative to refine and deepen my technical skills, so that I’m fully prepared to hit the ground running in a blue team role. I’m learning how enterprise systems behave, how attackers leave traces, and how to respond with purpose and clarity.
