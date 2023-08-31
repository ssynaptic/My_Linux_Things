#!/bin/bash

function exiting() {
    echo "Exiting..."
    sleep 1
    exit
}

trap exiting SIGINT

GREEN="\033[0;32m"
RED="\033[0;31m"
ORANGE="\033[0;33m"

if [ $# -lt 2 ]; then
    echo "Usage: $0 <network> <timeout>"
    exit 1
fi

# Validar el formato de la dirección IP
network_regex='^([[:digit:]]+\.){3}'
if ! [[ $1 =~ $network_regex ]]; then
    echo -e "${RED}Invalid network format. Exiting..."
    exit 1
fi

network=$(echo $1 | grep -oE '^([[:digit:]]+\.){3}')
timeout="$2"

echo "$network"

for i in {1..254}; do
    echo -e "${ORANGE}Pinging Host: $network$i"
    if ping -c 1 -t 128 -W $timeout $network$i &> /dev/null; then
        echo -e "${GREEN}Host $network$i Active"
    else
        echo -e "${RED}Host $network$i Inactive"
    fi
done

echo "Ping Sweep Finished"
