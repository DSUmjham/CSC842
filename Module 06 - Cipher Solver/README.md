# Cipher Solver README

## General Information
* Author: Michael Ham
* Date: 11/17/2015
* Script Name: cipher_solver.py
* Description: This Python script takes in a string of ciphertext and runs it through several decoding functions.  The purpose of the script is to help a user identify what cipher was used to generate the text and display the decoded value.

## Use Case and Background Info
This tool was inspired by a capture the flag exercise I was part of earlier this year.  One of the flags was to determine which cipher was used to generate the encoded text and also return the plaintext value.  The tool I wrote will take in a string of ciphertext and return the possible deciphered values from simple shift and substitution ciphers. These ciphers include:
* AtBash
* Base64
* Caesar (all rotations)
* ROT13
* URL Safe

## Installation
The installation instructions assume the following dependencies are met:

* The script is written for Python 2.7.9.  This is included by default on Kali 2.0.

To set up and run the script, perform the following:

1. Copy the **cipher_solver.py** script to a location on the Kali machine.
3. Mark the script as executable by running:
```sh
# chmod +x shellcode_solver.py
```
4. To run the script, execute the following command:
```sh
# python shellcode_solver.py -s <string>
```
Where **string** is the string of cipher text the user wishes to solve.

## Additional Resources
* [Video Demonstration](https://youtu.be/S3n7Zyjpoek)
* [AtBash](https://en.wikipedia.org/wiki/Atbash)
* [Base64](https://en.wikipedia.org/wiki/Base64)
* [Caesar Cipher](https://en.wikipedia.org/wiki/Caesar_cipher)
* [ROT13](https://en.wikipedia.org/wiki/ROT13)
* [Rumkin](http://rumkin.com/tools/cipher/)