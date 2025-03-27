#!/bin/sh
clear
read -s -p "Password: " password
printf "\n"
DECODED=`gpg --decrypt --no-symkey-cache --passphrase $password --batch seed.data 2>/dev/null`
cmd='bipsea validate -m "$DECODED" | bipsea xprv |  bipsea derive -a mnemonic -n "$1" -i "$2"'
printf "QRCode of $1 words, index $2 \n"
derivated=$(eval "$cmd")
qrencode "$derivated" -t ANSI256UTF8
