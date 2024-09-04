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
    echo "This script extracts detailed information from the provided certificate file."
    echo "It supports PEM, DER, and PKCS12 (PFX) formats."
    echo ""
    echo "Options:"
    echo "  -h, --help                     Show this help message"
    echo "  -cert, -c <certificate_file>   Specify the path to the certificate file"
    echo "  -p, --password <password>      Password for PKCS12 (PFX) files (optional, prompt if needed)"
    echo ""
    echo "You can also directly run the script as:"
    echo "./get_cert_info.sh /path/to/certificate.pem"
    echo ""
    echo "Steps to use the script:"
    echo "Make the script executable: chmod +x get_cert_info.sh"
    echo ""
    echo "EXAMPLES:"
    echo "Information from pfx will require a password:"
    echo "./get_cert_info.sh --certificate /path/to/certificate.pfx --password mypassword"
    echo "./get_cert_info.sh -c /path/to/certificate.pfx --p mypassword"
    echo ""
    echo "./get_cert_info.sh --certificate /path/to/certificate.pem"
    echo "./get_cert_info.sh -c /path/to/certificate.pem"
     echo "./get_cert_info.sh /path/to/certificate.pem"
    echo ""
    echo "Display help:"
    echo "./get_cert_info.sh -h"
    echo "./get_cert_info.sh --help"
    echo ""
    exit 0
}

# Function to detect the certificate type using the file command
detect_certificate_type() {
    local cert_file=$1

    # Use the 'file' command to determine the certificate type
    file_type=$(file --mime-type -b "$cert_file")
    
    if [[ "$file_type" == "application/x-x509-ca-cert" ]]; then
        echo "pem"
    elif [[ "$file_type" == "application/pkcs12" ]]; then
        echo "pfx"
    elif [[ "$file_type" == "application/x-x509-ca-cert" ]]; then
        echo "der"
    else
        echo "unknown"
    fi
}

# Function to extract and display certificate information for PEM and DER formats
get_certificate_info() {
    local cert_file=$1
    local cert_format=$2

    echo "Extracting information from $cert_file..."

    # Determine the correct openssl flag for the format (PEM or DER)
    local format_flag=""
    if [ "$cert_format" == "der" ]; then
        format_flag="-inform DER"
    fi

    # Common Name (CN)
    CN=$(openssl x509 $format_flag -in "$cert_file" -noout -subject | grep -oP "CN=\K[^,]+")
    echo "Common Name (CN): $CN"

    # Subject Alternative Names (SANs)
    SAN=$(openssl x509 $format_flag -in "$cert_file" -noout -ext subjectAltName | grep -oP "DNS:[^,]+" | tr "\n" ", " | sed 's/, $//')
    echo "Subject Alternative Names: ${SAN:-N/A}"

    # Hex Serial Number
    SERIAL_HEX=$(openssl x509 $format_flag -in "$cert_file" -serial -noout | cut -d'=' -f2)
    echo "Hex Serial Number: $SERIAL_HEX"

    # Decimal Serial Number
    SERIAL_DEC=$(hex_to_decimal $SERIAL_HEX)
    echo "Decimal Serial Number: $SERIAL_DEC"

    # Thumbprint (SHA-1)
    THUMBPRINT=$(openssl x509 $format_flag -in "$cert_file" -fingerprint -noout | cut -d'=' -f2)
    echo "Thumbprint (SHA-1): $THUMBPRINT"

    # Validity dates
    VALID_FROM=$(openssl x509 $format_flag -in "$cert_file" -startdate -noout | cut -d'=' -f2)
    VALID_TO=$(openssl x509 $format_flag -in "$cert_file" -enddate -noout | cut -d'=' -f2)
    echo "Date Issued: $VALID_FROM"
    echo "Date of Expiration: $VALID_TO"

    # Certificate Issuer
    ISSUER=$(openssl x509 $format_flag -in "$cert_file" -issuer -noout | sed 's/issuer= //')
    echo "Issuer: $ISSUER"

    # Certificate Version
    VERSION=$(openssl x509 $format_flag -in "$cert_file" -text -noout | grep "Version" | cut -d':' -f2)
    echo "Version: $VERSION"

    # Signature Algorithm
    SIG_ALGO=$(openssl x509 $format_flag -in "$cert_file" -text -noout | grep "Signature Algorithm" | head -1 | cut -d':' -f2 | xargs)
    echo "Signature Algorithm: $SIG_ALGO"

    # Key Usage
    KEY_USAGE=$(openssl x509 $format_flag -in "$cert_file" -text -noout | grep -A 1 "Key Usage" | tail -1 | xargs)
    echo "Key Usage: ${KEY_USAGE:-N/A}"

    # Extended Key Usage
    EXT_KEY_USAGE=$(openssl x509 $format_flag -in "$cert_file" -text -noout | grep -A 1 "Extended Key Usage" | tail -1 | xargs)
    echo "Extended Key Usage: ${EXT_KEY_USAGE:-N/A}"
}

# Function to extract and display information from PKCS12 (PFX) format
get_pfx_info() {
    local pfx_file=$1
    local password=$2

    echo "Extracting information from PKCS12 (PFX) file..."

    if [ -z "$password" ]; then
        # Try opening without password, and check if it fails
        if ! openssl pkcs12 -in "$pfx_file" -nokeys -clcerts -passin pass: 2>/dev/null | openssl x509 -noout -text; then
            # Prompt user for password if it fails
            read -sp "Enter the PKCS12 password: " password
            echo ""
        fi
    fi

    # Extract and display the certificate using the provided or entered password
    openssl pkcs12 -in "$pfx_file" -nokeys -clcerts -passin pass:"$password" | openssl x509 -noout -text
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided."
    echo "Use --help or -h for usage information."
    exit 1
fi

# Default certificate format is PEM, empty password for PFX
CERT_PASSWORD=""
CERT_FILE=""
CERT_TYPE=""

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
    -p|--password)
    CERT_PASSWORD="$2"
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

# Detect the certificate type and process accordingly
CERT_TYPE=$(detect_certificate_type "$CERT_FILE")

if [[ "$CERT_TYPE" == "pem" || "$CERT_TYPE" == "der" ]]; then
    get_certificate_info "$CERT_FILE" "$CERT_TYPE"
elif [[ "$CERT_TYPE" == "pfx" ]]; then
    get_pfx_info "$CERT_FILE" "$CERT_PASSWORD"
else
    echo "Error: Unsupported certificate format."
    exit 1
fi
