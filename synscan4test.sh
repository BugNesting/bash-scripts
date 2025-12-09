#!/bin/bash

Help(){
    echo "TCP Port Scan Script - SYN Scan using hping3"
    echo "Syntax: ./synscan4test.sh -t IP"
    echo ""
    echo "Parameters:"
    echo "  -h                Print this help"
    echo "  -t IP             Target IPv4 address"
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

# Validate IPv4 format
if [[ ! $TARGET =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Error: invalid IPv4 format."
    exit 1
fi

###########################################
# Main Execution                           #
###########################################

echo "Scanning $TARGET..."
echo

for PORT in {1..1024}; do
    OUTPUT=$(hping3 -S -p "$PORT" -c 1 -W 1 "$TARGET" 2>/dev/null)

    if echo "$OUTPUT" | grep -q "flags=SA"; then
        echo -e "[OPEN]      Port $PORT"
    elif echo "$OUTPUT" | grep -q "flags=RA"; then
        echo -e "[CLOSED]    Port $PORT"
    else
        echo -e "[FILTERED]  Port $PORT"
    fi
done

echo
echo "Scan completed."
