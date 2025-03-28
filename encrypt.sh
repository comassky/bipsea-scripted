#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -o output_path"
    echo "Options:"
    echo "  -o    Specify the output file path"
    echo "  -h    Display this help message"
    exit 1
}

# Function to clear terminal and history
clear_terminal() {
    clear && printf '\e[3J'
}

# Parse options provided by the user
while getopts ":o:h" opt; do
    case $opt in
        o)
            output_path=$OPTARG  # Store the output path specified by the user
            ;;
        h)
            usage  # Display usage information
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage  # Display usage information for invalid options
            ;;
    esac
done

# Check if output path is specified
if [ -z "$output_path" ]; then
    echo "Output path not specified." >&2
    usage  # Display usage information if output path is not specified
fi

clear_terminal  # Clear the terminal and history
read -p "Parent seed : " seed  # Prompt user for seed input
read -s -p "Password : " password  # Prompt user for password input (hidden)
echo
read -s -p "Confirm Password : " confirm_password  # Prompt user to confirm password (hidden)
echo

# Check if passwords match
if [ "$password" != "$confirm_password" ]; then
    clear_terminal
    echo "Passwords do not match. Please try again."
    exit 1  # Exit if passwords do not match
fi

# Sanitize input to remove newline characters
seed=$(echo "$seed" | tr -d '\n')
password=$(echo "$password" | tr -d '\n')

# Encrypt the seed using GPG with AES256 encryption
if echo "$seed" | gpg --symmetric --batch --yes --passphrase "$password" --cipher-algo AES256 --output "$output_path"; then
    clear_terminal
    absolute_path=$(realpath "$output_path")  # Get the absolute path of the output file
    echo "File created : $absolute_path"
else
    clear_terminal
    echo "Encryption failed. Please check your inputs and try again."
    exit 1  # Exit if encryption fails
fi

# Securely erase the password from memory
password=""
seed=""

# Set appropriate permissions for the output file
chmod 600 "$absolute_path"
# Log file type using file command
file_type=$(file "$absolute_path")
echo -e "$file_type"
