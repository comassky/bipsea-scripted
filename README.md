
# bipsea-scripted
Just a script to use bipsea BIP85 derivation
Script read AES seed stored on file seed.data, encrypt.sh purpose is to create this file

## Encrypt your Seed

    ./encrypt.sh

 1. Give your seed (space between words)
 2. Your strong AES encryption password

Example of seed : 

> install scatter logic circle pencil average fall shoe quantum disease
> suspect usage

File generated using this command :

 

    gpg --symmetric --batch --passphrase "$password" --cipher-algo AES256`enter code here` --output seed.data

**No leaks, you can (and i recommand) use OFFLINE devices.**

## Read and derivate

    ./script.sh $NUMBER_OF_WORD $INDEX

**$NUMBER_OF_WORD** must be 12 or 24.

Give seed.data password

This script decode seed.data with std GPG decrypt function

    gpg --decrypt --no-symkey-cache --passphrase $password --batch seed.data 2>/dev/null

Find derivated key with 

    bipsea validate -m "$DECODED" | bipsea xprv |  bipsea derive -a mnemonic -n "$1" -i "$2"

And display with QREncode

    qrencode "$derivated" -t ANSI256UTF


