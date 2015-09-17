# Ninja Mode README

## General Information
* Author: Michael Ham
* Date: 09/16/2015
* Script Name: ninjamode.sh
* Description: This shellscript is designed to quickly spoof the hostname and MAC address of a Kali 2.0 machine.  In addition to spoofing the hostname and MAC address, ninjamode.sh, will also find a random, unused IP address on the same subnet of the Kali machine.  This is to assist offensive network security entities in being slightly more covert on a target network.
* Tested On: Kali 2.0 (Linux kali 4.0.0-kali1-amd64 #1 SMP Debian 4.0.4-1+kali2 (2015-06-03) x86_64 GNU/Linux)

## Sample Use Cases
The script was designed and adapted with the following use cases in mind:

**Covert Offensive Network Recon**
When performing a blackbox penetration test or other offensiive activities, it is important to masquerade the machine in some cases.  When looking through log files, network administrators should be keen to spying "kali" as the hostname of a network host and investigating further.  Other typical identifiers of a UNIX host from a network perspective other than hostname are IP address and MAC address.  Ninja Mode allows for the MAC address and hostname to quickly be spoofed on demand.  This will make tracing the events of the attacker much more difficult.  In addition, the utility provides an unused IP address if the attacker wishes to change that as well.

## Installation
The installation instructions assume the following dependencies are met:

* The **sipcalc** software package is installed an operational on the machine.  
* Kali is connected to a valid network received IP configuration manually or through DHCP and is able to reach other network hosts.
* The routing table has a default route/default gateway configured.
* DNS is handled manually outside of the tool.

To set up and run the script, perform the following:

1. If sipcalc is not installed, run the following command to download and install.  Otherwise, skip to the next step
```sh
# apt-get install sipcalc -y
```
2. Copy the **ninjamode.sh** script to a location on the Kali machine.
3. Mark the script as executable by running:
```sh
# chmod +x ninjamode.sh
```
4. To run the script, execute the following command to turn on Ninja Mode.  
```sh
# ./ninjamode.sh 
```

## Additional Resources
* [Video Demonstration](URL GOES HERE)
