#!/bin/bash

# Default values
seed_path="/tmp/seed.data"
num_words=12

# Function to display usage
usage() {
    echo "Usage: $0 [-f seed_path] [-n num_words] -i index"
    echo "Options:"
    echo "  -f seed_path   Specify the path to the seed data file (default: /tmp/seed.data)"
    echo "  -n num_words   Specify the number of words for the mnemonic (default: 12)"
    echo "  -i index       Specify the index (required)"
    echo "  --help         Display this help message"
    exit 1
}

# Parse options
while getopts ":f:n:i:-:" opt; do
  case $opt in
    f) seed_path="$OPTARG" ;;
    n) num_words="$OPTARG" ;;
    i) index="$OPTARG" ;;
    -)
      case "$OPTARG" in
        help) usage ;;
        *) echo "Invalid option --$OPTARG" >&2; usage ;;
      esac ;;
    \?) usage ;;
    :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
  esac
done

# Check if index is provided
if [ -z "$index" ]; then
    echo "Option -i (index) is required." >&2
    usage
fi

# Check if seed_path is set and valid
if [ -z "$seed_path" ]; then
  echo "Option -f is required." >&2
  usage
elif [ ! -r "$seed_path" ]; then
  echo "File $seed_path does not exist or is not readable." >&2
  exit 1
fi

# Function to decrypt data
decrypt_data() {
    gpg --decrypt --no-symkey-cache --passphrase "$password" --batch "$seed_path" 2>/dev/null
}

# Function to derive mnemonic
derive_mnemonic() {
    bipsea validate -m "$1" | bipsea xprv | bipsea derive -a mnemonic -n "$num_words" -i "$index"
}

# Clear the screen and prompt for password securely
clear
read -s -p "Password: " password
clear && printf '\e[3J'

# Decrypt the seed data
DECODED=$(decrypt_data)

# Check if decryption was successful
if [ -z "$DECODED" ]; then
    echo "Decryption failed or produced no output."
    exit 1
fi

# Derive the mnemonic phrase
derivated=$(derive_mnemonic "$DECODED")

# Output the mnemonic phrase and generate a QR code
printf "Mnemonic of %s words, index %s:\n\n" "$num_words" "$index"
echo "$derivated"
printf "\nQRCode of %s words, index %s:\n\n" "$num_words" "$index"
qrencode "$derivated" -t ANSI256UTF8

# Securely erase the password from memory
password=""