# Phase 1: Active Directory and Group Policy Setup

In this phase, I built out the foundational structure of a simulated enterprise network by creating and configuring Organizational Units (OUs), Group Policy Objects (GPOs), user accounts, and role-based access control (RBAC). This setup mimics the kind of environment a security analyst or sysadmin would encounter in a real-world domain.

---

## Phase 1 Goals

- Set up a Windows Server 2022 Domain Controller
- Set up a Windows Client connected to the Domain Controller
- Create Organizational Units (OUs) to represent departments (such as HR, IT, Finance, SOC, Guests)
- Create user accounts and security groups based on role
- Configure Group Policy Objects (GPOs) to enforce:
  - Folder redirection to network shares
  - Windows Firewall settings
  - OpenSSH installation (for specific teams)
- Set up NTFS and share permissions on each department’s network share
- Test policy propagation and access control using test users

---

## Sample OU and User Structure

| OU Name    | Sample Users     | Group Assigned     |
|-----------|------------------|--------------------|
| HR        | hjones           | HR-Users           |
| IT        | jsmith           | IT-SysAdmin        |
| SOC       | jwick            | SOC-Lead           |
| Finance   | jbelfort         | Finance-Users      |
| Guests    | Guest1           | Guests-Limited     |

Each user was created in the appropriate OU and added to one or more groups for GPO targeting and share access.

---

## Testing and Validation

Here's how I confirmed the setup was working:

- I ran `gpresult /r` to verify that GPOs were applying as intended.
- Folder redirection was confirmed by logging in as users like `hjones` and checking that `Documents` was redirected to the appropriate network share (file path: `\\AD-DC1\HR-Share\hjones`).
- Share and NTFS permissions were validated by logging in as users from different OUs and attempting access.

---

## Tools Used

- Active Directory Users and Computers (ADUC)
- Group Policy Management Console (GPMC)
- PowerShell (`New-ADUser`, `Get-ADUser`)
- gpresult
- File Explorer (for share validation)

---

## Lessons Learned

- Folder redirection can fail with no clear resolution if share permissions or NTFS permissions are misconfigured... Testing with a clean user profile is key.
- GPOs applied at the OU level do not apply to users moved after logon unless `gpupdate /force` is run or a logout/login occurs.
- Understanding the order of policy processing and user/group permissions is essential for managing access and detecting misconfigurations.

---

## Screenshots for Proof of Concept

- [OU structure in ADUC] <img width="954" height="1080" alt="Screenshot (11)" src="https://github.com/user-attachments/assets/4e2bbd56-1c31-40e0-945c-41b6a1bae251" />
*This screenshot shows the Active Directory Users and Computers (ADUC) console with the full OU structure in place. Each department (HR, IT, Finance, SOC, Guests) has its own container. Inside the SOC OU, user accounts and role-based security groups (`SOC-Lead`, `SOC-Analysts`) are visible.*

- [gpresult output] <img width="956" height="1080" alt="Screenshot (12)" src="https://github.com/user-attachments/assets/8a92da50-8b56-484c-9b73-e3fcab7dee85" />
*This is the output of `gpresult /r` for the user `jwick` under the SOC OU. It confirms that the `Folder Redirection - SOC` GPO was successfully applied and that the policy originated from `AD-DC1.bruce.lab.local`. This validates group policy enforcement.*

- [Folder redirection paths] <img width="956" height="1080" alt="Screenshot (13)" src="https://github.com/user-attachments/assets/be669ba3-20f7-48d1-b2ea-8f3a818cfdfb" />
*This shows the `Documents` folder properties for the `hjones` user on WIN-CL1. The folder is correctly redirected to the network path `\\AD-DC1\HR-Share\hjones`, confirming successful application of the redirection GPO.*

- GPO settings preview <img width="956" height="1080" alt="Screenshot (14)" src="https://github.com/user-attachments/assets/381c7668-506b-47fa-9a7f-f53cd68e63e5" />
*This screenshot captures the Group Policy Management Console, displaying the `Folder Redirection - HR` policy. It shows the GPO linked to the `HR` OU and filtered to apply only to `Authenticated Users`. This enforces redirection of the Documents folder to the shared HR path.*

---

This foundational work ensures a realistic and manageable domain environment for the next phases, especially SIEM integration and attack simulation. This foundational setup enables later phases where I will simulate common attacks, like brute force, and will then log the attack, and build detections aligned to the MITRE ATT&CK framework.

