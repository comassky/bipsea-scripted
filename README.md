


# bipsea-scripted
Just a script to use bipsea  BIP85 derivation  (https://github.com/akarve/bipsea, officially recognized by BIP85 https://github.com/bitcoin/bips/blob/master/bip-0085.mediawiki )

Script script.sh read AES encrypted seed stored on file seed.data (AES256 Gpg encrypted file)

I also provide a script to encrypt your seed via gpg :  encrypt.sh (you can also create it with GPG manually)

![til](./example.gif)

## Encrypt your Seed

    ./encrypt.sh

 1. Give your seed (space between words)
 2. Your strong AES encryption password

Example of seed : 

> install scatter logic circle pencil average fall shoe quantum disease
> suspect usage

## Read and derivate

    ./script.sh $NUMBER_OF_WORD $INDEX

$NUMBER_OF_WORD must be 12 or 24.

 1. Give seed.data password

## How it works

### Encryption

File is generated using this command :

    gpg --symmetric --batch --passphrase "$password" --cipher-algo AES256 --output seed.data

After file generation, script clear CLI history with this command line (https://askubuntu.com/a/473770)

    clear && printf '\e[3J'

**No leaks, you can (and i recommand) use OFFLINE devices.**

### Read & Derivation

This script decode seed.data with std GPG decrypt function

    gpg --decrypt --no-symkey-cache --passphrase $password --batch seed.data 2>/dev/null

Find derivated key with 

    bipsea validate -m "$DECODED" | bipsea xprv |  bipsea derive -a mnemonic -n "$1" -i "$2"

And display with QREncode

    qrencode "$derivated" -t ANSI256UTF8

## Docker

You can run this scripts inside docker container without network access :

 - Build image 
	 - `docker build -t imageName .`
 - Run container without network access
	 - `docker run --rm -it --net=none imageName /bin/bash`
    	 - or use image build from this repository `docker run --rm -it --net=none ghcr.io/comassky/bipsea-scripted:main /bin/bash`
 - Use script as previously discribed
