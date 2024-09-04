#!/bin/bash

# Function to convert decimal to hexadecimal
decimal_to_hex() {
    printf "%X\n" "$1"
}

# Function to convert hexadecimal to decimal
hex_to_decimal() {
    echo "$((16#$1))"
}

# Function to convert decimal to binary
decimal_to_binary() {
    echo "obase=2; $1" | bc
}

# Function to convert hexadecimal to binary
hex_to_binary() {
    local decimal_value=$(hex_to_decimal "$1")
    decimal_to_binary "$decimal_value"
}

# Function to convert binary to decimal
binary_to_decimal() {
    echo "$((2#$1))"
}

# Function to convert binary to hexadecimal
binary_to_hex() {
    local decimal_value=$(binary_to_decimal "$1")
    decimal_to_hex "$decimal_value"
}

# Display help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "This script converts numbers between decimal, hexadecimal, and binary formats."
    echo ""
    echo "Options:"
    echo "  -h, --help               Show this help message"
    echo "  -in, --input <value>     The input number to be converted"
    echo "  -t, --type <format>      Specify the type of input: decimal|d, hex, binary|b"
    echo "  -o, --output <format>    Specify the desired output: hex|h, decimal|d, binary|b"
    echo ""
    echo "Examples:"
    echo "1. Convert decimal to hexadecimal:"
    echo "./converter_hexdecbin.sh -in 255 -t decimal -o hex"
    echo "./converter_hexdecbin.sh --input 255 --type decimal --output hex"
    echo "./converter_hexdecbin.sh -in 255 -t d -o h"
    echo "./converter_hexdecbin.sh --input 255 --type d --output h"
    echo ""
    echo "2. Convert decimal to binary:"
    echo "./converter_hexdecbin.sh -in 255 -t decimal -o binary"
    echo "./converter_hexdecbin.sh --input 255 --type decimal --output binary"
    echo "./converter_hexdecbin.sh -in 255 -t d -o b"
    echo "./converter_hexdecbin.sh --input 255 --type d --output b"
    echo ""
    echo "3. Convert hexadecimal to decimal:"
    echo "./converter_hexdecbin.sh -in FF -t hex -o decimal"
    echo "./converter_hexdecbin.sh --input FF --type hex --output decimal"
    echo "./converter_hexdecbin.sh -in FF -t hex -o d"
    echo "./converter_hexdecbin.sh --input FF --type hex --output d"
    echo ""
    echo "4. Convert hexadecimal to binary:"
    echo "./converter_hexdecbin.sh -in FF -t hex -o binary"
    echo "./converter_hexdecbin.sh --input FF --type hex --output binary"
    echo "./converter_hexdecbin.sh -in FF -t hex -o b"
    echo "./converter_hexdecbin.sh --input FF --type hex --output b"
    echo ""
    echo "5. Convert binary to decimal:"
    echo "./converter_hexdecbin.sh -in 1010 -t binary -o decimal"
    echo "./converter_hexdecbin.sh --input 1010 --type binary --output decimal"
    echo "./converter_hexdecbin.sh -in 1010 -t b -o d"
    echo "./converter_hexdecbin.sh --input 1010 --type b --output d"
    echo ""
    echo "6. Convert binary to hexadecimal:"
    echo "./converter_hexdecbin.sh -in 1010 -t binary -o hex"
    echo "./converter_hexdecbin.sh --input 1010 --type binary --output hex"
    echo "./converter_hexdecbin.sh -in 1010 -t b -o h"
    echo "./converter_hexdecbin.sh --input 1010 --type b --output h"
    echo ""
    echo "Steps to use the script:"
    echo "Make the script executable: chmod +x converter_hexdecbin.sh"
    echo ""
    exit 0
}

# Parse the command-line options
INPUT=""
INPUT_TYPE=""
OUTPUT_TYPE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -in|--input)
            INPUT="$2"
            shift
            shift
            ;;
        -t|--type)
            INPUT_TYPE="$2"
            shift
            shift
            ;;
        -o|--output)
            OUTPUT_TYPE="$2"
            shift
            shift
            ;;
        *)
            echo "Error: Invalid option $1"
            show_help
            ;;
    esac
done

# Check if input, type, and output are provided
if [ -z "$INPUT" ] || [ -z "$INPUT_TYPE" ] || [ -z "$OUTPUT_TYPE" ]; then
    echo "Error: Missing input, type, or output."
    show_help
fi

# Perform the conversion based on the input type and target
case "$INPUT_TYPE" in
    decimal|d)
        case "$OUTPUT_TYPE" in
            hex|h)
                decimal_to_hex "$INPUT"
                ;;
            binary|b)
                decimal_to_binary "$INPUT"
                ;;
            *)
                echo "Error: Unsupported output $OUTPUT_TYPE for decimal input."
                exit 1
                ;;
        esac
        ;;
    hex|h)
        case "$OUTPUT_TYPE" in
            decimal|d)
                hex_to_decimal "$INPUT"
                ;;
            binary|b)
                hex_to_binary "$INPUT"
                ;;
            *)
                echo "Error: Unsupported output $OUTPUT_TYPE for hexadecimal input."
                exit 1
                ;;
        esac
        ;;
    binary|b)
        case "$OUTPUT_TYPE" in
            decimal|d)
                binary_to_decimal "$INPUT"
                ;;
            hex|h)
                binary_to_hex "$INPUT"
                ;;
            *)
                echo "Error: Unsupported output $OUTPUT_TYPE for binary input."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Error: Unsupported input type $INPUT_TYPE."
        exit 1
        ;;
esac
