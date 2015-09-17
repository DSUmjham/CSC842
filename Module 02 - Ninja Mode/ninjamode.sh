#!/bin/bash

# Determine where to go based on what the user entered (fail to usage)
parseOptions (){
	if [ -z "$1" ]; then
		on
	else
		case "$1" in
			"-o" | "--off" )
				off
				;;
			*)
				usage
				;;
		esac
	fi
}

# Spoof the MAC address and hostname to random values
on (){
	printf "Turning ninja mode on...\n"

	# Backup original values of machine, don't overwrite if backups exist
	cp -n /etc/hosts /etc/hosts.old
	cp -n /etc/hostname /etc/hostname.old

	# Change the MAC address to random
	ifconfig eth0 down
	macchanger -r eth0
	ifconfig eth0 up

	# Change the hostname to random
	RAND_NUM=$(($RANDOM % 10 + 1)) # Length of the hostname between 1 and 10
	RAND_HOSTNAME=$(cat /dev/urandom  | tr -dc 'A-z1-9' | head -c$RAND_NUM)
	echo | printf "Hostname:      %s\n" $RAND_HOSTNAME
	hostnamectl set-hostname $RAND_HOSTNAME
	echo "127.0.0.1 $RAND_HOSTNAME" > /etc/hosts
	
	# Restart the network manager, hostnamectl destroys your default gateway
	/etc/init.d/network-manager restart > /dev/null

	printf "\nFinding available IP addresses (this may take a while)...\n"
	findAvailIP
	echo "Done."
}

# Change the MAC address and hostname back to the original values
off (){
	printf "Turning ninja mode off...\n"

	# Change the MAC address back to the permanent value
	ifconfig eth0 down
	macchanger -p eth0
	ifconfig eth0 up

	# Change the hostname back to the original value and clean up backup files
	mv /etc/hosts.old /etc/hosts
	mv /etc/hostname.old /etc/hostname
	ORIGINAL_HOSTNAME=$(cat /etc/hostname)
	hostnamectl set-hostname $ORIGINAL_HOSTNAME
	printf "Hostname:      %s\n" $ORIGINAL_HOSTNAME

	# Restart the network manager, hostnamectl destroys your default gateway
	/etc/init.d/network-manager restart > /dev/null
	
	echo "Done."
}

findAvailIP (){
	IFS=$'\n' # Tell the array to break items on the newline rather than space

	# Get the current network information
	NETWORK=($(sipcalc eth0 | grep "Network address" | rev | cut -d' ' -f 1 | rev)) # Figure out the Network ID
	CIDR=($(sipcalc eth0 | grep "Network mask (bits)" | rev | cut -d' ' -f 1 | rev)) # Subnet mask bits
	
	# Build an array of unpingable 
	IP_ARRAY=($(fping -q -u -g ${NETWORK[0]}/${CIDR[0]})) # Find the unreqchable hosts via ping and store them into an array
	ARRAY_LENGTH=${#IP_ARRAY[@]}
	RAND_INDEX=$(($RANDOM % $ARRAY_LENGTH))
	SUBNET=($(sipcalc eth0 | grep '^Network mask\s*-\s255.' | rev | cut -d' ' -f 1 | rev))
	GATEWAY=$(route -n | grep '^0.0.0.0' | cut -d' ' -f10)
	printf "Unused IP:     %s\n" ${IP_ARRAY[$RAND_INDEX]}
	printf "Subnet Mask:   %s\n" $SUBNET 
	printf "Gateway:       %s\n" ${GATEWAY[0]}	
}

# Help menu function
usage (){
	echo "ninjamode"
	echo "Usage: ninjamode <options>"
	echo "This tool is designed to change the system hostname and MAC address to unique/random values in an effort to make the system more difficult to track."
	echo " "
	echo "-o, --off	Turn ninjamode off."
	echo "-h, --help	Print this help message."
}


# Determine the number of command line arguments passed in
if [ $# -gt 1 ]; then 
	usage
else
	parseOptions $1
fi

exit 0

