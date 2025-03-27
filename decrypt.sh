#!/bin/bash
clear
read -s -p "Password : " password
DECODED=`gpg --decrypt --no-symkey-cache --passphrase "$password" --batch /tmp/seed.data 2>/dev/null`
clear
printf "Mnemonic : \n \n"
echo "$DECODED"
printf "\nQRCode  : \n \n"
qrencode "$DECODED" -t ANSI256UTF8
