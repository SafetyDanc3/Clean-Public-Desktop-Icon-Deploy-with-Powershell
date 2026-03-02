# PowerShell OU Shortcut Deployment Tool

A PowerShell automation script that remotely manages and deploys desktop shortcuts to devices within a specified Active Directory Organizational Unit (OU) — without using WinRM.

This script is designed to supplement base system images that may be missing required shortcuts or desktop components.

---

## Overview

This tool:

1. Runs **without requiring WinRM**
2. Pulls shortcut files from a defined file path
3. Enumerates all devices within a specified Active Directory OU
4. For each device:
   - Removes existing shortcuts with matching names
   - Deploys updated shortcuts from the source path
   - Provides status feedback on:
     - Device online status
     - Network reachability
     - Shortcut removal success
     - Shortcut deployment success

---

## Use Case

In enterprise environments, base OS images are often missing required desktop shortcuts or standardized icons.

This script allows administrators to:
- Standardize desktop environments
- Repair incomplete image deployments
- Remediate missing components without reimaging
- Automate shortcut consistency across an OU

---

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Active Directory module
- Domain permissions to:
  - Query OU computer objects
  - Access remote devices
  - Modify file system paths remotely
- Network connectivity to target devices
- SMB access enabled on target systems

---

## How It Works

1. Queries Active Directory for all computer objects in a specified OU.
2. Tests device connectivity (ping / network reachability).
3. Connects using file share access (not WinRM).
4. Removes existing shortcut files that match the deployment list.
5. Copies new shortcut files from the source directory.
6. Outputs structured feedback per device.
