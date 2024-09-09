# Aliases
alias tf='terraform'

# Helper function to list all functions and descriptions
list_helpers() {
  echo "Available Helper Functions:"
  echo "1. hex2dec - Convert hexadecimal to decimal"
  echo "2. hex2bin - Convert hexadecimal to binary"
  echo "3. dec2hex - Convert decimal to hexadecimal"
  echo "4. dec2bin - Convert decimal to binary"
  echo "5. bin2hex - Convert binary to hexadecimal"
  echo "6. bin2dec - Convert binary to decimal"
  echo "7. cert_serial - Display certificate serial number in hex and decimal"
  echo "8. unix2date - Convert Unix epoch time to human-readable date"
  echo "9. date2epoch - Convert a date to Unix epoch time"
  echo "10. futureDate - Get future date based on a description (e.g., days, months)"
  echo "11. pastDate - Get past date based on a description (e.g., days, months)"
  echo "12. futureTime - Get future time based on a description (e.g., hours, minutes)"
  echo "13. pastTime - Get past time based on a description (e.g., hours, minutes)"
  echo "14. futureDT - Get future DateTime based on date and time description"
  echo "15. pastDT - Get past DateTime based on date and time description"
  echo "16. current_epoch - Show current Unix epoch time"
  echo "17. datecompare - Compare two dates or epoch times and show time differences"
  echo "18. pretty_json - Pretty print JSON"
  echo "19. pretty_yaml - Pretty print YAML"
  echo "20. clean_file - Clean file from non-UTF characters and fix line endings"
  echo "21. fix_line_endings - Fix line endings between Windows and Linux"
  echo "22. remove_non_utf - Remove non-UTF characters from file"
  echo "23. check_non_utf - Check for non-UTF characters in a file"
  echo "24. stripwhitespace - Remove leading and trailing whitespaces"
  echo "25. charcount - Count characters in input"
  echo "26. wordcount - Count words in input"
  echo "27. lower - Convert text to lowercase"
  echo "28. upper - Convert text to uppercase"
  echo "29. calc - Simple calculator for command-line math operations"
  echo "30. size - Check file or folder size"
  echo "31. perm - Check file or folder permissions in symbolic and numeric format"
  echo "32. perm2num - Convert symbolic permissions to numeric format"
  echo "33. num2perm - Convert numeric permissions to symbolic format"
  echo "34. unset_tf - Unset Terraform and related environment variables"
  echo "35. unset_aws - Unset AWS environment variables"
  echo "36. unset - Unset all environment variables"
}

# Function to list all defined aliases
list_aliases() {
  echo "Available Aliases:"
  alias
}

# Function to load helper functions into bash
load_helpers() {
  if [ -f ~/.helper_functions.sh ]; then
    source ~/.helper_functions.sh
    echo "Helper functions loaded."
  else
    echo "helper_functions.sh file not found."
  fi
}

# Function to convert Hexadecimal to Decimal
hex2dec() {
  if [ "$1" == "--help" ]; then
    echo "Usage: hex2dec HEX_VALUE"
    echo "Example: hex2dec A1"
    echo "Expected Output: Decimal equivalent of HEX_VALUE"
    return
  fi
  echo "$((16#$1))"
}

# Function to convert Hexadecimal to Binary
hex2bin() {
  if [ "$1" == "--help" ]; then
    echo "Usage: hex2bin HEX_VALUE"
    echo "Example: hex2bin A1"
    echo "Expected Output: Binary equivalent of HEX_VALUE"
    return
  fi
  echo "obase=2; ibase=16; $1" | bc
}

# Function to convert Decimal to Hexadecimal
dec2hex() {
  if [ "$1" == "--help" ]; then
    echo "Usage: dec2hex DECIMAL_VALUE"
    echo "Example: dec2hex 161"
    echo "Expected Output: Hexadecimal equivalent of DECIMAL_VALUE"
    return
  fi
  printf "%X\n" "$1"
}

# Function to convert Decimal to Binary
dec2bin() {
  if [ "$1" == "--help" ]; then
    echo "Usage: dec2bin DECIMAL_VALUE"
    echo "Example: dec2bin 161"
    echo "Expected Output: Binary equivalent of DECIMAL_VALUE"
    return
  fi
  echo "obase=2; $1" | bc
}

# Function to convert Binary to Hexadecimal
bin2hex() {
  if [ "$1" == "--help" ]; then
    echo "Usage: bin2hex BINARY_VALUE"
    echo "Example: bin2hex 10100001"
    echo "Expected Output: Hexadecimal equivalent of BINARY_VALUE"
    return
  fi
  echo "obase=16; ibase=2; $1" | bc
}

# Function to convert Binary to Decimal
bin2dec() {
  if [ "$1" == "--help" ]; then
    echo "Usage: bin2dec BINARY_VALUE"
    echo "Example: bin2dec 10100001"
    echo "Expected Output: Decimal equivalent of BINARY_VALUE"
    return
  fi
  echo "$((2#$1))"
}

# Function to display certificate serial number in hex and decimal
cert_serial() {
  if [ "$1" == "--help" ]; then
    echo "Usage: cert_serial /path/to/certificate.pem"
    echo "Example: cert_serial cert.pem"
    echo "Expected Output: Serial number in hex and decimal"
    return
  fi
  if [ -f "$1" ]; then
    serial_hex=$(openssl x509 -in "$1" -noout -serial | cut -d'=' -f2)
    serial_dec=$(echo "ibase=16; $serial_hex" | bc)
    echo "Serial (Hex): $serial_hex"
    echo "Serial (Decimal): $serial_dec"
  else
    echo "File not found: $1"
  fi
}

# Function to convert Unix epoch time to human-readable date
unix2date() {
  if [ "$1" == "--help" ]; then
    echo "Usage: unix2date EPOCH_TIME"
    echo "Example: unix2date 1620999600"
    echo "Expected Output: Human-readable date for the provided epoch time"
    return
  fi
  date -d @"$1"
}

# Function to convert a date to Unix epoch time
date2epoch() {
  if [ "$1" == "--help" ]; then
    echo "Usage: date2epoch 'YYYY-MM-DD HH:MM:SS'"
    echo "Example: date2epoch '2024-09-07 15:30:00'"
    echo "Expected Output: Unix epoch time for the provided date"
    return
  fi
  date -d "$1" +"%s"
}

# Function to show the current Unix epoch time
current_epoch() {
  echo "Current Unix Time: $(date +%s)"
}

# Function to compare two dates, times, or epochs and show the difference
datecompare() {
  if [ "$1" == "--help" ]; then
    echo "Usage: datecompare DATE1 DATE2"
    echo "Examples:"
    echo "  datecompare '2024-09-07 15:30:00' '2023-09-06 12:00:00'"
    echo "  datecompare 1620999600 1720999600 # Compare two epoch times"
    return
  fi
  
  date1=$1
  date2=$2

  # Convert dates or epoch to seconds since 1970-01-01
  time1=$(date -d "$date1" +%s)
  time2=$(date -d "$date2" +%s)

  # Calculate the absolute difference in seconds
  diff_seconds=$(( time1 > time2 ? time1 - time2 : time2 - time1 ))

  # Break down the difference into days, hours, minutes, and seconds
  diff_days=$(( diff_seconds / 86400 ))
  diff_hours=$(( (diff_seconds % 86400) / 3600 ))
  diff_minutes=$(( (diff_seconds % 3600) / 60 ))
  diff_seconds=$(( diff_seconds % 60 ))

  # Calculate the difference in months and years
  diff_years=$(date -d "@$time1" +"%Y")
  diff_years=$(( $(date -d "@$time2" +"%Y") - diff_years ))

  diff_months=$(date -d "@$time1" +"%m")
  diff_months=$(( $(date -d "@$time2" +"%m") - diff_months ))
  if [ "$diff_months" -lt 0 ]; then
    diff_months=$(( diff_months + 12 ))
    diff_years=$(( diff_years - 1 ))
  fi

  echo "Time Difference:"
  echo "  Years: $diff_years"
  echo "  Months: $diff_months"
  echo "  Days: $diff_days"
  echo "  Hours: $diff_hours"
  echo "  Minutes: $diff_minutes"
  echo "  Seconds: $diff_seconds"
}

# Simple calculator for math operations
calc() {
  if [ "$1" == "--help" ]; then
    echo "Usage: calc EXPRESSION"
    echo "Example: calc 5+4"
    echo "Expected Output: The result of the math expression"
    return
  fi
  echo "$@" | bc -l
}

# Function to pretty-print JSON
pretty_json() {
  if [ "$1" == "--help" ]; then
    echo "Usage: pretty_json /path/to/file.json"
    echo "Example: pretty_json input.json"
    return
  fi
  jq . "$1"
}

# Function to pretty-print YAML
pretty_yaml() {
  if [ "$1" == "--help" ]; then
    echo "Usage: pretty_yaml /path/to/file.yaml"
    echo "Example: pretty_yaml input.yaml"
    return
  fi
  yq eval . "$1"
}

# Function to clean a file by removing non-UTF characters and fixing line endings
clean_file() {
  if [ "$1" == "--help" ]; then
    echo "Usage: clean_file /path/to/file"
    echo "Expected Output: Cleaned file with fixed line endings and non-UTF characters removed"
    return
  fi
  iconv -f utf-8 -t utf-8 -c "$1" -o "$1.cleaned"
  sed -i 's/\r$//' "$1.cleaned"
  echo "File cleaned and saved as $1.cleaned"
}

# Function to fix line endings (Windows to Linux)
fix_line_endings() {
  if [ "$1" == "--help" ]; then
    echo "Usage: fix_line_endings /path/to/file"
    echo "Expected Output: Fixed line endings in the specified file"
    return
  fi
  sed -i 's/\r$//' "$1"
}

# Function to remove non-UTF characters from a file
remove_non_utf() {
  if [ "$1" == "--help" ]; then
    echo "Usage: remove_non_utf /path/to/file"
    echo "Expected Output: File with non-UTF characters removed"
    return
  fi
  iconv -f utf-8 -t utf-8 -c "$1" -o "$1.cleaned"
  echo "Non-UTF characters removed. Cleaned file saved as $1.cleaned"
}

# Function to check for non-UTF characters in a file
check_non_utf() {
  if [ "$1" == "--help" ]; then
    echo "Usage: check_non_utf /path/to/file"
    echo "Expected Output: Information on whether the file contains non-UTF characters"
    return
  fi
  iconv -f utf-8 -t utf-8 "$1" -o /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "No non-UTF characters found in $1."
  else
    echo "Non-UTF characters found in $1."
  fi
}

# Function to remove leading and trailing whitespaces
stripwhitespace() {
  if [ "$1" == "--help" ]; then
    echo "Usage: stripwhitespace 'STRING'"
    echo "Example: stripwhitespace '  Hello World  '"
    echo "Expected Output: 'Hello World'"
    return
  fi
  echo "$@" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Function to count characters in a string
charcount() {
  if [ "$1" == "--help" ]; then
    echo "Usage: charcount 'STRING'"
    echo "Example: charcount 'Hello'"
    echo "Expected Output: Number of characters in the string"
    return
  fi
  echo "$@" | wc -m
}

# Function to count words in a string
wordcount() {
  if [ "$1" == "--help" ]; then
    echo "Usage: wordcount 'STRING'"
    echo "Example: wordcount 'Hello World'"
    echo "Expected Output: Number of words in the string"
    return
  fi
  echo "$@" | wc -w
}

# Function to convert text to lowercase
lower() {
  if [ "$1" == "--help" ]; then
    echo "Usage: lower 'STRING'"
    echo "Example: lower 'HELLO'"
    echo "Expected Output: 'hello'"
    return
  fi
  echo "$@" | tr '[:upper:]' '[:lower:]'
}

# Function to convert text to uppercase
upper() {
  if [ "$1" == "--help" ]; then
    echo "Usage: upper 'STRING'"
    echo "Example: upper 'hello'"
    echo "Expected Output: 'HELLO'"
    return
  fi
  echo "$@" | tr '[:lower:]' '[:upper:]'
}

# Bash and Terraform completions (example)
bash_completion() {
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
    echo "Bash completion enabled."
  else
    echo "Bash completion script not found."
  fi
}

terraform_completion() {
  terraform -install-autocomplete
  echo "Terraform completion enabled."
}

# Function to check file or folder size
size() {
  if [ "$1" == "--help" ]; then
    echo "Usage: size /path/to/file_or_folder"
    echo "Example: size /path/to/file"
    echo "Expected Output: Displays the size of the specified file or folder"
    return
  fi

  target=$1

  if [ -z "$target" ]; then
    echo "Error: Please specify a file or folder path."
    return 1
  fi

  if [ ! -e "$target" ]; then
    echo "Error: $target does not exist."
    return 1
  fi

  if [ -f "$target" ]; then
    echo "File: $target"
    size=$(du -h "$target" | cut -f1)
    echo "Size: $size"
  elif [ -d "$target" ]; then
    echo "Folder: $target"
    size=$(du -sh "$target" | cut -f1)
    echo "Size: $size"
  else
    echo "Error: $target is neither a file nor a folder."
    return 1
  fi
}

# Function to check file or folder permissions and convert to numeric format
perm() {
  if [ "$1" == "--help" ]; then
    echo "Usage:"
    echo "  perm /path/to/file_or_folder   # Display permissions of a file/folder in both symbolic and numeric format"
    echo "  perm 'drwxr-xr-x'             # Convert permission string to numeric format"
    echo "Example:"
    echo "  perm /path/to/file            # Shows: Permissions: -rwxr-xr-x (755)"
    echo "  perm 'drwxr-xr-x'             # Converts to: 755"
    return
  fi

  target=$1

  if [ -e "$target" ]; then
    perm_str=$(stat -c "%A" "$target")
    numeric_permissions=$(perm2num "$perm_str")
    echo "Permissions: $perm_str ($numeric_permissions)"
  
  elif [[ "$target" =~ ^[-d][rwx-]{9}$ ]]; then
    numeric_permissions=$(perm2num "$target")
    echo "Numeric Permissions: $numeric_permissions"
  
  else
    echo "Error: Invalid file/folder or permission string."
    return 1
  fi
}

# Function to convert symbolic permissions to numeric format
perm2num() {
  perm_str=$1
  num=""
  for (( i=1; i<${#perm_str}; i+=3 )); do
    digit=0
    [[ ${perm_str:$i:1} == "r" ]] && ((digit+=4))
    [[ ${perm_str:$i+1:1} == "w" ]] && ((digit+=2))
    [[ ${perm_str:$i+2:1} == "x" ]] && ((digit+=1))
    num+="$digit"
  done
  echo "$num"
}

# Function to convert numeric permissions to symbolic format and show how to apply changes using + notation
num2perm() {
  if [ "$1" == "--help" ]; then
    echo "Usage: num2perm NUMERIC_PERMISSIONS"
    echo "Example: num2perm 755"
    echo "Expected Output: Symbolic representation of the permissions (e.g., rwxr-xr-x)"
    echo "Also provides instructions on how to modify permissions using +r, +w, +x."
    return
  fi

  num_perm=$1

  if [[ ! "$num_perm" =~ ^[0-7]{3}$ ]]; then
    echo "Error: Invalid numeric permission format."
    return 1
  fi

  perm=""
  for (( i=0; i<${#num_perm}; i++ )); do
    case ${num_perm:$i:1} in
      7) perm+="rwx" ;;
      6) perm+="rw-" ;;
      5) perm+="r-x" ;;
      4) perm+="r--" ;;
      3) perm+="-wx" ;;
      2) perm+="-w-" ;;
      1) perm+="--x" ;;
      0) perm+="---" ;;
    esac
  done

  echo "Symbolic Permissions: $perm"

  user_perm=${perm:0:3}
  group_perm=${perm:3:3}
  other_perm=${perm:6:3}

  echo "To apply permissions using + notation:"
  echo "For user permissions:"
  [[ "$user_perm" =~ r ]] && echo "  chmod u+r   # Add read permission"
  [[ "$user_perm" =~ w ]] && echo "  chmod u+w   # Add write permission"
  [[ "$user_perm" =~ x ]] && echo "  chmod u+x   # Add execute permission"
  
  echo "For group permissions:"
  [[ "$group_perm" =~ r ]] && echo "  chmod g+r   # Add read permission"
  [[ "$group_perm" =~ w ]] && echo "  chmod g+w   # Add write permission"
  [[ "$group_perm" =~ x ]] && echo "  chmod g+x   # Add execute permission"

  echo "For others' permissions:"
  [[ "$other_perm" =~ r ]] && echo "  chmod o+r   # Add read permission"
  [[ "$other_perm" =~ w ]] && echo "  chmod o+w   # Add write permission"
  [[ "$other_perm" =~ x ]] && echo "  chmod o+x   # Add execute permission"
}

# Function to unset Terraform and related environment variables
unset_tf() {
    unset TF_WORKSPACE
    unset ENVIRONMENT
    unset GITHUB_TOKEN

    echo "Terraform and related environment variables have been unset."
}

# Function to unset AWS environment variables
unset_aws() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    echo "AWS environment variables have been unset."
}

# Function to unset AWS environment variables
unset() {
    unset TF_WORKSPACE
    unset ENVIRONMENT
    unset GITHUB_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    echo "Environment variables are unset."
}