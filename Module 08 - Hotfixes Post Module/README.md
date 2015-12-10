# Hotfixes Post Module README

## General Information
* Author: Michael Ham
* Date: 12/10/2015
* Script Name: powershell_unpatch.rb
* Description: This is a Metasploit post exploitation module that runs through a meterpreter shell.  The module will hunt down and uninstall Windows security updates based on a user-supplied date or remove all of them.  The module should work on both x32 and x64 systems that have PowerShell enabled.

## Use Case and Background Info
This one is purely offense.  Like the original, on the offensive and exploit development side of things, this script can be useful in "downgrading" system security.  In other contexts, when you gain access to a machine you may be limited in your context and unable to upgrade your permissions to something better like SYSTEM.  In that case, you can blow away the security updates installed on the machine and possibly go after some lower-hanging fruit.

## Installation
The installation instructions assume the following dependencies are met:
* The target machine is configured and enabled for PowerShell code execution.
* The user account launching the script has appropriate permissions.
* You are able to gain a meterpreter shell on the victim machine.
* The Metasploit framework is installed and the database is connected into msfconsole.

To set up and run the script, perform the following:

1. Copy the **powershell_unpatch.rb** script file into your Metasploit directory.  The following commands assume you are running as root and intend to use Metasploit as root.

    ```bash
    # mkdir /root/.msf4/modules/post/windows/manage/
    # cp powershell_unpatch.rb /root/.msf4/modules/post/windows/manage/
    ```

2. Launch the Metasploit framework.  Your postgresql database should be started before launching the framework.

	```bash
	# msfconsole
	```

3. Ensure that the module is loaded and no errors exist by typing:

	```bash
    msf > reload_all 
    ```

4. Get a meterpreter shell on the victim box.
5. Load up the module and set the appropriate options.

	```bash
    msf > use post/windows/manage/powershell_unpatch 
    msf post(powershell_unpatch) > show options
    
    Module options (post/windows/manage/powershell_unpatch):

       Name       Current Setting  Required  Description
       ----       ---------------  --------  -----------
       DATE       01/01/1970       no        Patches on or after date (MM/DD/YYY)
       SESSION                     yes       The session to run this module on.
       UNINSTALL  true             yes       Uninstall matching security updates
    ```

## Additional Resources
* [Video Demonstration](https://youtu.be/BLzLwTaKotQ)
* [Interactive PowerShell Sessions Within Meterpreter](https://www.trustedsec.com/june-2015/interactive-powershell-sessions-within-meterpreter/)
* [How to use PowerShell in an exploit](https://github.com/rapid7/metasploit-framework/wiki/How-to-use-Powershell-in-an-exploit)
* [powershell.rb](https://github.com/rapid7/metasploit-framework/blob/master/lib/msf/core/exploit/powershell.rb)
* [Windows Manage PowerShell Download and/or Execute](https://www.rapid7.com/db/modules/post/windows/manage/powershell/exec_powershell)