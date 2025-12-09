#!/bin/bash

Help(){
    echo "Ping sweeper script - scan a /24 network and list online hosts."
    echo "Syntax: ./pingsweeper.sh -t NETWORK"
    echo ""
    echo "Parameters:"
    echo "-h                  Print this help"
    echo "-t NETWORK          Define local network (ex: 192.168.1)"
}

###########################################
# Parameters Parsing                       #
###########################################

while getopts "h:t:" opt; do
  case $opt in
    h) Help; exit;;
    t) TARGET="$OPTARG" ;;
    *) echo "Invalid option"; exit 1 ;;
  esac
done

if [ -z "$TARGET" ]; then
    Help
    exit 1
fi

# Reject full IP (4 octets)
if [[ $TARGET =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Error: full IP provided ($TARGET). Use network only, e.g., 192.168.1"
    exit 1
fi

# Must be exactly 3 octets
if [[ ! $TARGET =~ ^([0-9]{1,3}\.){2}[0-9]{1,3}$ ]]; then
    echo "Error: invalid network format. Use: 192.168.1"
    exit 1
fi



###########################################
# Main Execution                           #
###########################################

echo "Scanning ${TARGET}.0/24 ..."
echo

for host in {1..254}; do
    ip="${TARGET}.${host}"
    if ping -c 1 -W 1 "$ip" &> /dev/null; then
        echo -e "\e[1;32m$ip   [ONLINE]\e[0m"
    fi
done

echo
echo "Scan completed."