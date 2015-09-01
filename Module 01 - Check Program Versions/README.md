# Check Program Version README

## General Information
* Author: Michael Ham
* Date: 09/01/2015
* Script Name: CheckProgramVersion.ps1
* Description: This script is designed to parse a list of network hosts and return a list of specified software on the remote machines.  The script will return information as to whether or not the specified software exists, the software version if installed, and whether or not it is up-to-date.
* Tested On: Windows Server 2008 R2, Windows 7, Windows 8

## Sample Use Cases
The script was designed and adapted wiht the following use cases in mind:

**Network Administrator**
A network administrator is often busy and needs to keep track of software resources in the enironment.  While Windows and major operating systems typically have a patch managment solution, smaller peices of software are more difficult maintain.  Commercial utilities to monitor and manage applilcations may be quite expensive and exceed the need of the administrator.  This script allows a network adminsitraor the ability to quickly and easily identify "interesting" software and specify the desired patch level for the software.  A report is generated that will detail whether or not the software is installed and what the version is for the administrator.

**Offensive Network Recon**
In an offensive security setting, performing reconissance and fingerprinting target machines is a crucial task.  If an insider or an attacker were able to execute PowerShell commands on a system, this utilitiy may be used to further identify potential vulnerabile targets.  The attacke would need some level of access to a compromised machine or disclosed credentials in order to run this script.  However, if the script is successfully executed, information gathered may reveal pivot-points or opportunities to move throughout the network.

## Installation
The installation instructions assume the following:
* The machine running the script is configured and enabled for PowerShell code execution.
* The user account launching the script has appropriate permissions.
* Remote machines have WinRM and PowerShell remoting enabled.
* Caveats:
  * This script is designed to be run in a domain environment with an appropriate level of priviliges to execute PowerShell commands.
  * If running the script in a workgroup, you may run into issues with teh Invoke-Command block.  This is because of differing default security
settings between the environments.  
  * Furthermore, if the remot host's network adapter is set to "Public" mode, the Enable-PSRemoting command will
not be able to complete successfully; it must be in a Domain or Private network.  
  * The user account on the target machines should have a password
in order for the remote connection to work.

To set up and run the script, perform the following:
1. Copy the **CheckPorgramVersions.ps1** script to a location on your windows machine.
2. Create a text document that contains a list of hosts to be scanned. This can be composed of IP addresses, NetBIOS hostnames, or DNS names.  There should be one host per line.  
3. Save the file when finished.
3. Open the **CheckPorgramVersions.ps1** script with a PowerShell ISE.
4. Modify the **$workstations** parameter within the script to match the full path of the workstation file created in step 2.
5. Any program versions may be updated within the **Program Versions** region.
6. To add additional software definitions to be scanned, use the existing regions as a template.  Software details will be pulled from the **HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall** registry key.
7. Save the file when finished.
7. Once the script file has been updated, launch a PowerShell console with administrative permissions.
8. To run the script, type the following and hit **Enter**:
```PowerShell
> .\CheckProgramVersions.ps1
```

## Additional Resources
* [Layman's Guide to Powershell 2.0 Remoting](http://www.ravichaganti.com/blog/laymans-guide-to-powershell-2-0-remoting/)
* [Video Demonstration](https://www.youtube.com/playlist?list=PL2K88uFC2iwfKotodZLeW1rEDpbbQFfAe)
