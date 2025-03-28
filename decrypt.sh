#!/bin/bash

# Function to display help message
usage() {
  echo "Usage: $0 -f <seed_path>"
  echo
  echo "Options:"
  echo "  -f <seed_path>  Path to the seed data file (required)"
  echo "  -h              Display this help message"
  exit 1
}

# Parse options
while getopts ":f:h" opt; do
  case $opt in
    f) 
      seed_path="$OPTARG"
      ;;
    h)
      usage
      ;;
    \?) 
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :) 
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

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

# Clear the screen
clear

# Prompt for password securely
read -s -p "Password: " password

# Clear the screen again and remove scrollback buffer
clear && printf '\e[3J'

# Decrypt the data
DECODED=$(decrypt_data)

# Check if decryption was successful
if [ -z "$DECODED" ]; then
    echo "Decryption failed or produced no output."
    exit 1
fi

# Print the decrypted mnemonic
printf "\nMnemonic :\n\n"
echo "$DECODED"

# Generate QR code from the decrypted mnemonic
printf "\nQRCode \n\n"
qrencode "$DECODED" -t ANSI256UTF8

# Securely erase the password from memory
password=""