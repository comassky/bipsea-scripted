#!/bin/bash
clear
read -s -p "Password: " password
clear && printf '\e[3J'
DECODED=`gpg --decrypt --no-symkey-cache --passphrase "$password" --batch /tmp/seed.data 2>/dev/null`
cmd='bipsea validate -m "$DECODED" | bipsea xprv |  bipsea derive -a mnemonic -n "$1" -i "$2"'
derivated=$(eval "$cmd")

printf "Mnemonic of $1 words, index $2 : \n \n"
echo "$derivated"
printf "\nQRCode of $1 words, index $2 : \n \n"
qrencode "$derivated" -t ANSI256UTF8
