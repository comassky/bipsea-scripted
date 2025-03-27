#!/bin/bash
clear
read -p "Parent seed : " seed
read -s -p "Password : " password
echo "$seed" | gpg --symmetric --batch --yes --passphrase "$password" --cipher-algo AES256 --output /tmp/seed.data
#Clear and remove CLI history
clear && printf '\e[3J'
echo "File seed.data created"
