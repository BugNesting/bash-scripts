#!/bin/bash

if [ "$1" == "" ]; then
    echo "Port Knocking Script, for testing port knocking, use only with permission and good intentions"
    echo "USAGE: ./portknocking.sh TARGET_IP"
    echo "EXAMPLE: ./portknocking.sh 192.168.1.50"
    exit 1
fi

TARGET=$1

if [[ ! $TARGET =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Invalid IP format."
    exit 1
fi

echo "Sending knock sequence to $TARGET..."
echo "Sequence: 13 → 37 → 30000 → 3000 → 1337"

# Knocks :)
hping3 -S -p 13    -c 1 "$TARGET" 2>/dev/null
hping3 -S -p 37    -c 1 "$TARGET" 2>/dev/null
hping3 -S -p 30000 -c 1 "$TARGET" 2>/dev/null
hping3 -S -p 3000  -c 1 "$TARGET" 2>/dev/null
hping3 -S -p 1337  -c 1 "$TARGET" 2>/dev/null

echo -e "\e[1;32mKnocks sent successfully! Check Pcap or try connection\e[0m"