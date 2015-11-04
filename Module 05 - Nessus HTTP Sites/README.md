# Nessus HTTP Sites README

## General Information
* Author: Michael Ham
* Date: 11/03/2015
* Script Name: Nessus_HTTP_Sites.ps1
* Description: This PowerShell script takes in a Nessus v2 XML report (in the .nessus extension) and parses out any IP addresses that may be running a web server along with the web port.  The script then generates an HTML file that contains a link to each URL along with a list of IP addresses of those hosts.

## Use Case and Background Info
Often times in an offensive network security engagement or penetration testing exercise, web servers can lead to very interesting results in the context of a network.  Whether the web server was intended to be present on the network, it is running as a dependency of another service, or it was possibly rouge/forgotten, it can be a wealth of information for an attacker.  Misconfigurations, information disclosure, or default configuration passwords may be extremely costly to an organization in terms of pride, reputation, and financial aspects.

This tool is designed to help facilitate the discovery and enumeration of web servers in a network.  It provides users with a simple HTML page that they can use to visit each page and inspect the information and configuration there.  In addition, the tool gives a list of any IP addresses containing a web server of some sort for further processing with automation tools such as HTTPScreenshot.

## Installation
The installation instructions assume the following dependencies are met:
* The machine running the script is configured and enabled for PowerShell code execution.
* The user account launching the script has appropriate permissions.

To set up and run the script, perform the following:

1. Copy the **Nessus_HTTP_Sites.ps1** file to your Windows machine and make sure PowerShell execution privileges are set to allow script execution.
2. Run a Nessus scan on your target IP addresses or networks.
3. When the Nessus scan is finished, export the scan results to a .nessus (Nessus v2 XML) file and save it to your Windows machine.
4. Launch the **Nessus_HTTP_Sites.ps1** script with the following PowerShell command:
```PowerShell
> .\Nessus_HTTP_Sites.ps1 <input_file> <output_dir>
```
Where **<input_file>** is the .nessus file and **<output_dir>** is the folder to place the HTML file.
5. Browse to your HTML file and open it up!  You can choose how you want to look through the data, either manually or I recommend using a tool like HTTPScreenshot (see Additional Resources) to run through everything.

## Additional Resources
* [Video Demonstration](https://youtu.be/Q_cGxYIKxxE)
* [Nessus - HyperText Transfer Protocol (HTTP) Information Plugin](http://www.tenable.com/plugins/index.php?view=single&id=24260)
* [HTTPScreenshot](https://github.com/breenmachine/httpscreenshot)
* [MASSCAN](https://github.com/robertdavidgraham/masscan)