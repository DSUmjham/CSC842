#! /usr/bin/python
import csv
import sys
import os

# Get the shellcode text file as the first argument passed to the script
# Shellcode should be in the "python" format from MSFVenom
shellcodeTXT = str(sys.argv[1])
shellcodeCSV = shellcodeTXT + '.csv'

# Remove the unwanted characters from the MSFVenom output
lines = open(shellcodeTXT).readlines()
stripChars = ['+', '=', '"', ' ', '\\']

# Create the .csv file that will contain the shellcode in little endian format
with open(shellcodeCSV, 'wb+') as f:
	for l in lines:
		l = l.translate(None, ''.join(stripChars)).replace('x', ',')[4:]
		f.writelines(l)
		f.flush()

# Open up the previously generated .csv file and start reordering the bytes
with open('%s' % shellcodeCSV, 'rb') as f:
	reader = csv.reader(f)
	shellcodeList = list(reader)

# Flatten the list, by default each line of the .csv gets addded as a new list item.
flattened = []
for sublist in shellcodeList:
    for val in sublist:
        flattened.append(val)

# Group the bytes in sets of four bytes in big endian format (reversed)
grouped = []
while flattened:
    grouped.append(''.join(flattened[3::-1]))
    flattened = flattened[4::]

for item in grouped:
    print '0x' + item + ', ',