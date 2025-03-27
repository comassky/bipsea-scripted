# bipsea-scripted
Just a script to use bipsea BIP85 derivation
Script read AES seed stored on file seed.data, encrypt.sh purpose is to create this file

##Encrypt your Seed

./encrypt.sh

Give your seed
Give your password

File generated using this command :

gpg --symmetric --batch --passphrase "$password" --cipher-algo AES256 --output seed.data

No leaks

## Read and derivate

./script.sh $NUMBER_OF_WORD $INDEX

$NUMBER_OF_WORD must be 12 or 24.

Give seed.data password

This one decode seed.data with std GPG function

gpg --decrypt --no-symkey-cache --passphrase $password --batch seed.data 2>/dev/null

Find derivate with 

bipsea validate -m "$DECODED" | bipsea xprv |  bipsea derive -a mnemonic -n "$1" -i "$2"

And display with QREncode

qrencode "$derivated" -t ANSI256UTF


