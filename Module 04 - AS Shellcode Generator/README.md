# Action Script Shellcode Generator README

## General Information
* Author: Michael Ham
* Date: 10/16/2015
* Script Name: as_shellcode_gen.py
* Description: This Python script takes shellcode from MSFVenom and formats it into 4 byte chunks of big endian order.  The output from MSFVenom used in the script is Python, but can be adapted easily.

## Use Case and Background Info
This tool was inspired by research on a Windows 10 Flash 17 vulenrabitly.  When looking through the vulnerabiltiy, one of my goals was to modify available explot code with new shellcode in an effort to acheive differnt outcomes.  One of the problems in modifying the particular vulnerabiltiy I was researchign is that the shellcode was stored in a vector composed of uints (4 bytes), and none of the MSFVenom output formats would quite get there.  The task became quite tedious as I tried multiple varients of the shellcode, and quickly tired of manually formatting it.  As an added feature, the script outputs a .csv file of each of the bytes to make adaptation easy for any other formats the shellcode may be needed in.

## Installation
The installation instructions assume the following dependencies are met:

* The script is written for Python 2.7.9.  This is included by default on Kali 2.0.

To set up and run the script, perform the following:

1. A text file of shellcode needs to be genrated first with MSFVenom using the Python output format specifier. When running MSFVenom, you can use the following as a reference for generating the file:

``` sh
# msfvenom -a x86 --platform Windows -p windows/exec CMD=cmd.exe -e x86/shikata_ga_nai -b '\x00\x0A\x0D' -i 3 -f python > shellcode.txt
```

2. Copy the **as_shellcode_gen.py** script to a location on the Kali machine.
3. Mark the script as executable by running:
```sh
# chmod +x as_shellcode_gen.py
```
4. To run the script, execute the following command:
```sh
# python as_shellcode_gen.py <shellcode file>
```
Where **<shellcode file>** is the name of the host list generated in step 1.

## Additional Resources
* [Video Demonstration](https://youtu.be/rSz0jdFyt3w)
* [Action Script Vectors](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Vector.html)
* [MSFVenom](https://www.offensive-security.com/metasploit-unleashed/msfvenom/)