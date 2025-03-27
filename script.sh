#!/bin/bash
clear
read -s -p "Password: " password
printf "\n"
#DECODED=`openssl enc -in seed.data -d -aes256 -pass "pass:${password}" -pbkdf2`
#cmd='bipsea validate -m "$DECODED" | bipsea xprv |  bipsea derive -a mnemonic -n "$1" -i "$2"'
#derivated=$(eval "$cmd")
#qrencode "$derivated" -t ANSI256UTF8
DECODED=`gpg --decrypt --no-symkey-cache --passphrase $password --batch seed.data 2>/dev/null`
cmd='bipsea validate -m "$DECODED" | bipsea xprv |  bipsea derive -a mnemonic -n "$1" -i "$2"'
printf "QRCode of $1 words, index $2 \n"
derivated=$(eval "$cmd")
qrencode "$derivated" -t ANSI256UTF8
