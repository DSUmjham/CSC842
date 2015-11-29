# Hotfixes README

## General Information
* Author: Michael Ham
* Date: 11/29/2015
* Script Name: Hotfixes.ps1
* Description: This PowerShell script lists the installed hotfixes on a Windows system.  The script is able to filter hotfixes by security updates in addition to displaying updates installed on or after a certain date.  Finally, the script is able to uninstall multiple hotfixes from a system depending on the filters chosen.

## Use Case and Background Info
System administrators may find use in this script for the purposes of inventorying what updates are installed on a system.  Also, Microsoft occasionally releases updates that adversely affect software and systems.  In these scenarios, the ability to quickly uninstall multiple updates can be important.  Through the GUI, Windows does not provide a way to batch uninstall updates; this script provides such functionality.

On the offensive and exploit development side of things, this script can be useful in "downgrading" system security.  Sometimes we are given exploit code that is designed to work on specific versions of DLLs and drivers that have since been patched.  In order to understand and upgrade these exploits, they need to be run successfully.  The script provides exploit developers a means to easily uninstall patches to get a system back to a state where the sample exploit code may run.

## Installation
The installation instructions assume the following dependencies are met:
* The machine running the script is configured and enabled for PowerShell code execution.
* The user account launching the script has appropriate permissions.

To set up and run the script, perform the following:

1. Copy the **Hotfixes.ps1** file to your Windows machine and make sure PowerShell execution privileges are set to allow script execution.
2. Launch the **Hotfixes.ps1** script with the following PowerShell command to list all hotfixes installed on a machine:
```PowerShell
> .\Hotfixes.ps1 
```
3. To view the help of **Hotfixes.ps1** and se additional examples of how the script can be run:
```PowerShell
> Get-Help .\Hotfixes.ps1 
```

## Additional Resources
* [Video Demonstration](https://youtu.be/bzOb9BfJMiQ)