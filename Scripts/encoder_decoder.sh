#!/bin/bash

# Function to display help
function display_help() {
    echo "Usage: $0 [option] [input]"
    echo
    echo "Options:"
    echo "  -b64e, --base64-encode       Base64 encode the input"
    echo "  -b64d, --base64-decode       Base64 decode the input"
    echo "  -htmle, --html-encode        HTML encode the input"
    echo "  -htmld, --html-decode        HTML decode the input"
    echo "  -d, --auto-decode            Auto-detect and decode Base64 or HTML"
    echo "  -h, --help                   Display this help menu"
    echo
    echo "Examples:"
    echo "  ./encoder_decoder.sh --base64-encode 'Hello World'"
    echo "  ./encoder_decoder.sh --base64-decode 'SGVsbG8gV29ybGQ='"
    echo "  ./encoder_decoder.sh --html-encode '<div>Hello & Welcome</div>'"
    echo "  ./encoder_decoder.sh --html-decode '&lt;div&gt;Hello &amp; Welcome&lt;/div&gt;'"
    echo "  ./encoder_decoder.sh --auto-decode 'SGVsbG8gV29ybGQ='"
    echo "  ./encoder_decoder.sh --auto-decode '&lt;div&gt;Hello &amp; Welcome&lt;/div&gt;'"
}

# Function to base64 encode
function base64_encode() {
    echo -n "$1" | base64
}

# Function to base64 decode
function base64_decode() {
    echo -n "$1" | base64 --decode
}

# Function to HTML encode
function html_encode() {
    local encoded=$(echo -n "$1" | sed 's/&/\&amp;/g' | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g' | sed 's/"/\&quot;/g' | sed "s/'/\&#39;/g")
    echo -n "$encoded"
}

# Function to HTML decode
function html_decode() {
    local decoded=$(echo -n "$1" | sed 's/\&amp;/\&/g' | sed 's/\&lt;/</g' | sed 's/\&gt;/>/g' | sed 's/\&quot;/"/g' | sed "s/\&#39;/'/g")
    echo -n "$decoded"
}

# Function to auto-detect Base64 or HTML encoding and decode
function auto_decode() {
    local input="$1"
    
    # Check if it's Base64 (must be valid Base64 string and decodable)
    if [[ "$input" =~ ^[A-Za-z0-9+/=]+$ ]] && base64 --decode "$input" >/dev/null 2>&1; then
        echo "Detected Base64 encoding, decoding..."
        base64_decode "$input"
    # Check if it's HTML encoded (look for common HTML entities)
    elif [[ "$input" =~ \&[a-z]+; ]]; then
        echo "Detected HTML encoding, decoding..."
        html_decode "$input"
    else
        echo "Error: Could not auto-detect encoding."
        exit 1
    fi
}

# Parse command-line arguments
case "$1" in
    -b64e|--base64-encode)
        if [ -z "$2" ]; then
            echo "Error: No input provided for encoding"
            exit 1
        fi
        base64_encode "$2"
        ;;
    -b64d|--base64-decode)
        if [ -z "$2" ]; then
            echo "Error: No input provided for decoding"
            exit 1
        fi
        base64_decode "$2"
        ;;
    -htmle|--html-encode)
        if [ -z "$2" ]; then
            echo "Error: No input provided for encoding"
            exit 1
        fi
        html_encode "$2"
        ;;
    -htmld|--html-decode)
        if [ -z "$2" ]; then
            echo "Error: No input provided for decoding"
            exit 1
        fi
        html_decode "$2"
        ;;
    -d|--auto-decode)
        if [ -z "$2" ]; then
            echo "Error: No input provided for decoding"
            exit 1
        fi
        auto_decode "$2"
        ;;
    -h|--help)
        display_help
        ;;
    *)
        echo "Error: Invalid option"
        display_help
        exit 1
        ;;
esac
