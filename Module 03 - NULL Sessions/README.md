# NULL Session Scanner README

## General Information
* Author: Michael Ham
* Date: 10/01/2015
* Script Name: nullscanner.sh
* Description: This shellscript is designed to reach out to Windows hosts identified as having a NULL Session open and accessible.  Upon finding a NULL Session available, the script enumerates relevant information such as IP address, OS ersion, domain name and SID, domain users and groups, and administrative accounts.

## Use Case and Background Info
Windows systems rely on an IPC$ adminsitrative share for Inter Process Communication (IPC).  As directly quoted from [Microsoft](https://msdn.microsoft.com/en-us/library/windows/desktop/aa365574(v=vs.85).aspx)  "The Windows operating system provides mechanisms for facilitating communications and data sharing between applications. Collectively, the activities enabled by these mechanisms are called interprocess communications (IPC). Some forms of IPC facilitate the division of labor among several specialized processes. Other forms of IPC facilitate the division of labor among computers on a network."

Attackers have found out that as these NULL shares do not require information, they can obtain useful information by connecting to them and querying pertinent information.  Examples of the disclosure or vulnerabiltiy descriptions can be found at:
* [Tenable/Nessus: Microsoft Windows SMB NULL Session Authentication](http://static.tenable.com/documentation/reports/html/PCI_Scan_Plugin_w_Remediations.html#idp3641072)
* [Rapid7: CIFS NULL Session Permitted](https://www.rapid7.com/db/vulnerabilities/CIFS-NT-0001) 

## Installation
The installation instructions assume the following dependencies are met:

* The **rpcclient** software package is installed an operational on the machine.  This is included by default on Kali 2.0.

To set up and run the script, perform the following:

1. A list of hosts needs to be generated first.  This is easily exported from a vulnerabitily scanner such as Nessus or work through SMB enumeration in Metasploit.  The host list should be a text file with one IP address per line.
2. Copy the **nullscanner.sh** script to a location on the Kali machine.
3. Mark the script as executable by running:
```sh
# chmod +x ninjamode.sh
```
4. To run the script, execute the following command to turn on Ninja Mode.  
```sh
# ./nullscanner.sh <host file> 
```
Where **<host file>** is the name of the host list generated in step 1.

## Additional Resources
* [Video Demonstration](https://youtu.be/-IV4t7z_nog)
* [Carnal0wnage: More of using rpcclient to find usernames](http://carnal0wnage.attackresearch.com/2007/08/more-of-using-rpcclient-to-find.html)
* [SANS: Plundering Windows Account Info via \*\*Authenticated** SMB Sessions ](https://pen-testing.sans.org/blog/2013/07/24/plundering-windows-account-info-via-authenticated-smb-sessions)
* [TrustedSec: New Tool Release – RPC_ENUM – RID Cycling Attack](https://www.trustedsec.com/march-2013/new-tool-release-rpc_enum-rid-cycling-attack/)
