#!/bin/bash

# Make sure the user passed in a file to read from
if [ "$#" -ne 1 ]; then
	printf "Usage: ./nullscanner.sh <IP Input Filename>\n"
	exit
fi

# Read in the file contents, store them into an array
index=0
while IFS=' ' read -r line || [[ -n "$line" ]]; do
	HOSTARRAY[$index]="$line"
	((++index))
done < "$1"

# Loop through the array and test each host for a NULL session
for (( i = 0; i < ${#HOSTARRAY[@]} ; i++ )) do
	
	if(rpcclient -U "" -N -p 445 -c quit ${HOSTARRAY[$i]} &> /dev/null)
	then
		printf "[+] ${HOSTARRAY[$i]} NULL Session enabled with blank user.\n"
		rpcclient -U "" -N -p 445 -c srvinfo ${HOSTARRAY[$i]}
		rpcclient -U "" -N -p 445 -c lsaquery ${HOSTARRAY[$i]}
		rpcclient -U "" -N -p 445 -c enumdomusers ${HOSTARRAY[$i]}
		rpcclient -U "" -N -p 445 -c "lookupnames administrators" ${HOSTARRAY[$i]}
		rpcclient -U "" -N -p 445 -c "lookupnames administrator" ${HOSTARRAY[$i]}
	elif (rpcclient -U Guest -N -p 445 -c quit ${HOSTARRAY[$i]} &> /dev/null)
	then
		printf "[+] ${HOSTARRAY[$i]} NULL Session enabled with Guest user.\n"
		rpcclient -U Guest -N -p 445 -c srvinfo ${HOSTARRAY[$i]}		
		rpcclient -U Guest -N -p 445 -c lsaquery ${HOSTARRAY[$i]}
		rpcclient -U Guest -N -p 445 -c enumdomusers ${HOSTARRAY[$i]}
		rpcclient -U Guest -N -p 445 -c "lookupnames administrators" ${HOSTARRAY[$i]}
		rpcclient -U Guest -N -p 445 -c "lookupnames administrator" ${HOSTARRAY[$i]}
	else
		printf "[*] ${HOSTARRAY[$i]} NULL Session not enabled.\n"
	fi
done
