#!/bin/bash

# Function to convert hex to decimal
hex_to_decimal() {
  local hex=$1
  echo "obase=10; ibase=16; $hex" | bc
}

# Display help function
show_help() {
    echo "Usage: $0 [OPTIONS] <certificate_file>"
    echo ""
    echo "This script extracts the serial number from the provided certificate file,"
    echo "converts it from hexadecimal to decimal, checks if it's encoded, and displays both values."
    echo ""
    echo "Options:"
    echo "  -h, --help                    Show this help message"
    echo "  -cert, -c <certificate_file>   Specify the path to the certificate file"
    echo ""
    echo "You can also directly run the script as:"
    echo "./get_cert_serial.sh /path/to/certificate.pem"
    echo ""
    echo "Steps to use the script:"
    echo "Make the script executable: chmod +x get_cert_serial.sh"
    echo ""
    echo "EXAMPLES"
    echo "./get_cert_serial.sh --certificate /path/to/certificate.pem"
    echo "./get_cert_serial.sh /path/to/certificate.pem"
    echo "./get_cert_serial.sh -h"
    echo ""
    exit 0
}

# Function to check if the certificate is encoded
check_if_encoded() {
    local cert_file=$1

    # Check for PEM encoding by looking for the "BEGIN CERTIFICATE" marker
    if grep -q "-----BEGIN CERTIFICATE-----" "$cert_file"; then
        echo "The certificate is PEM encoded."
    else
        # If not PEM, check if it's a binary file (DER/PKCS12)
        file_type=$(file "$cert_file")
        if [[ "$file_type" == *"DER"* || "$file_type" == *"PKCS12"* ]]; then
            echo "The certificate is binary encoded (DER or PKCS12)."
        else
            echo "Unknown encoding format."
        fi
    fi
}

# Function to extract and print the serial number
get_serial_number() {
    local cert_file=$1

    # Extract the serial number in hex format
    SERIAL_HEX=$(openssl x509 -in "$cert_file" -serial -noout | cut -d'=' -f2)

    # Check if the serial number was extracted successfully
    if [ -z "$SERIAL_HEX" ]; then
        echo "Error: Could not extract the serial number from the certificate file."
        exit 1
    fi

    # Convert the serial number from hex to decimal
    SERIAL_DEC=$(hex_to_decimal $SERIAL_HEX)

    echo "Hex Serial Number: $SERIAL_HEX"
    echo "Decimal Serial Number: $SERIAL_DEC"
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided."
    echo "Use --help or -h for usage information."
    exit 1
fi

# Check if only the certificate file path is provided directly
if [ $# -eq 1 ] && [[ "$1" != -* ]]; then
    CERT_FILE="$1"
    check_if_encoded "$CERT_FILE"
    get_serial_number "$CERT_FILE"
    exit 0
fi

# Parse command-line options
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    show_help
    ;;
    -cert|-c)
    CERT_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "Error: Unknown option $1"
    show_help
    ;;
esac
done

# Check if certificate file is provided
if [ -z "$CERT_FILE" ]; then
    echo "Error: No certificate file provided."
    echo "Use --help or -h for usage information."
    exit 1
fi

# Check if the certificate is encoded
check_if_encoded "$CERT_FILE"

# Extract and print the serial number
get_serial_number "$CERT_FILE"
