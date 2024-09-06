#!/bin/bash

# Function to display help
function show_help() {
    echo "RSA Key Validator"
    echo ""
    echo "Usage: rsa_validator.sh -f <rsa_key_file>"
    echo ""
    echo "Options:"
    echo "  -f, --file    Specify the path to the RSA key file to validate"
    echo "  -h, --help    Show this help message"
    exit 0
}

# Function to validate RSA key
function validate_rsa_key() {
    local rsa_key_file=$1

    # Check if the file exists
    if [[ ! -f "$rsa_key_file" ]]; then
        echo "Error: File '$rsa_key_file' not found!"
        exit 1
    fi

    # Attempt to validate RSA private key
    openssl rsa -in "$rsa_key_file" -check -noout 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "RSA Private Key is valid."
        return
    fi

    # Attempt to validate RSA public key
    openssl rsa -pubin -in "$rsa_key_file" -noout 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "RSA Public Key is valid."
        return
    fi

    # If neither worked, it's not a valid RSA key
    echo "Invalid RSA Key format."
}

# Parse command-line arguments
if [[ $# -eq 0 ]]; then
    show_help
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
        rsa_key_file="$2"
        shift
        shift
        ;;
        -h|--help)
        show_help
        ;;
        *)
        echo "Invalid option: $1"
        show_help
        ;;
    esac
done

# Validate the RSA key
if [[ -n "$rsa_key_file" ]]; then
    validate_rsa_key "$rsa_key_file"
else
    echo "Error: RSA key file is required."
    show_help
fi
