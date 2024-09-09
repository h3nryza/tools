#!/bin/bash

# Set default values for required and optional parameters
REGION="eu-west-1"
RETENTION_DAYS=7
LOG_ARNS="*"
SHOW_SIZE="TRUE"
SHOW_ITEM_COUNT="TRUE"
OUTPUT="FALSE"
OUTPUT_PREFIX="$(date +'%Y-%m-%d')-logRetentionOutput"
OUTPUT_LOCATION="."
OUTPUT_TYPE="CSV"
EXPORT_LOGS="FALSE"
LOG_LEVEL="INFO"
LOG_PATH="."
LOG_NAME="$(date +'%Y-%m-%d-%H-%M-%S')-setAwsLogGroupRetentionLOGS.txt"

# Color settings for different log levels and statuses
RESET='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
WHITE='\033[1;37m'

# Data store for output
declare -a LOG_DATA

# Function to log messages based on the log level and handle export if enabled
# Usage: log <LEVEL> <MESSAGE>
log() {
    LEVEL=$1
    MESSAGE=$2
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
    LOG_MESSAGE="[$LEVEL] $TIMESTAMP: $MESSAGE"

    # Console logging
    case $LEVEL in
        INFO)
            echo -e "${WHITE}$LOG_MESSAGE${RESET}"
            ;;
        WARNING)
            echo -e "${YELLOW}$LOG_MESSAGE${RESET}"
            ;;
        ERROR)
            echo -e "${RED}$LOG_MESSAGE${RESET}"
            ;;
        SUCCESS)
            echo -e "${GREEN}$LOG_MESSAGE${RESET}"
            ;;
        DEBUG)
            if [[ "$LOG_LEVEL" == "DEBUG" ]]; then
                echo -e "${WHITE}$LOG_MESSAGE${RESET}"
            fi
            ;;
    esac

    # Store log data for export if OUTPUT is enabled
    if [[ "$OUTPUT" == "TRUE" ]]; then
        LOG_DATA+=("$LOG_MESSAGE")
    fi

    # Append log to file if export is enabled
    if [[ "$EXPORT_LOGS" == "TRUE" ]]; then
        echo "$LOG_MESSAGE" >> "$LOG_PATH/$LOG_NAME"
    fi
}

# Function to display help and usage guide
display_help() {
    echo "setAwsLogGroupRetention.sh - Script to set AWS CloudWatch log group retention policies"
    echo ""
    echo "This script automates the process of setting retention policies for AWS CloudWatch log groups."
    echo "It works across multiple regions and log groups, applying a specified retention period."
    echo "Optional flags allow control over additional features like showing log group size, event count, and exporting results."
    echo ""
    echo "Getting Started:"
    echo "  Requires AWS CLI installed and configured with sufficient permissions to perform the following actions:"
    echo "  - 'logs:DescribeLogGroups' to fetch log groups."
    echo "  - 'logs:PutRetentionPolicy' to set retention policies."
    echo ""
    echo "Required parameters:"
    echo "  --region            AWS region(s) to target (comma separated for multiple regions, default: eu-west-1)"
    echo "  --retention         Retention period in days (default: 7)"
    echo ""
    echo "Optional parameters:"
    echo "  --log-arn           Specify the ARN(s) of log groups (default: *, all log groups)"
    echo "  --show-size         Show log group size before and after change (default: TRUE)"
    echo "  --show-item-count   Show the number of log events before and after change (default: TRUE)"
    echo "  --output            Export results to a file (default: FALSE)"
    echo "  --output-prefix     Prefix for the output file (default: yyyy-mm-dd-logRetentionOutput)"
    echo "  --output-location   Location for output file (default: current directory)"
    echo "  --output-type       Output format: CSV, JSON, TXT (default: CSV)"
    echo "  --log-level         Set the log level: INFO, DEBUG, WARNING, ERROR (default: INFO)"
    echo "  --log-path          Directory to save log files (default: current directory)"
    echo "  --log-name          Name of the log file (default: yyyy-mm-dd-hh-ss-logRetentionLogs.txt)"
    echo "  --export-logs       Export logs to a file (default: FALSE)"
    echo ""
    echo "Examples:"
    echo ""
    echo "1. Set default retention for all log groups in a single region:"
    echo "  ./setAwsLogGroupRetention.sh --region us-east-1 --retention 14"
    echo "  Description: Sets retention to 14 days for all log groups in the us-east-1 region."
    echo ""
    echo "2. Set default retention for specific log groups in multiple regions:"
    echo "  ./setAwsLogGroupRetention.sh --region us-west-1,eu-west-1 --retention 30 --log-arn arn:aws:logs:us-west-1:123456789012:log-group:/example-group1,arn:aws:logs:eu-west-1:123456789012:log-group:/example-group2"
    echo "  Description: Sets retention to 30 days for specific log groups in us-west-1 and eu-west-1."
    echo ""
    echo "3. Include log group size before and after change:"
    echo "  ./setAwsLogGroupRetention.sh --region us-east-2 --retention 7 --show-size YES"
    echo "  Description: Shows log group sizes before and after changing retention to 7 days in us-east-2."
    echo ""
    echo "4. Show log item count before and after change:"
    echo "  ./setAwsLogGroupRetention.sh --region ap-south-1 --retention 90 --show-item-count TRUE"
    echo "  Description: Shows the number of log events before and after changing retention to 90 days in ap-south-1."
    echo ""
    exit 0
}

# Check if AWS CLI is installed
check_dependencies() {
    command -v aws >/dev/null 2>&1 || {
        log ERROR "AWS CLI is not installed. Please install it before running the script."
        exit 1
    }
}

# Fetch log group size and/or log event count based on options
# Usage: fetch_log_group_metrics <LOG_GROUP> <REGION> <TIMING> (TIMING: Before/After)
fetch_log_group_metrics() {
    local LOG_GROUP=$1
    local REGION=$2
    local TIMING=$3  # This indicates whether it's before or after applying the retention policy
    local START_TIME=$(date +%s) # Start time for fetching data
    local SIZE=""
    local COUNT=""

    # Fetch log group size if SHOW_SIZE is TRUE
    if [[ "$SHOW_SIZE" == "TRUE" ]]; then
        SIZE=$(aws logs describe-log-streams --log-group-name "$LOG_GROUP" --region "$REGION" --query 'logStreams[*].storedBytes' --output text | awk '{s+=$1} END {print s}')
    fi

    # Fetch log group count if SHOW_ITEM_COUNT is TRUE
    if [[ "$SHOW_ITEM_COUNT" == "TRUE" ]]; then
        COUNT=$(aws logs describe-log-streams --log-group-name "$LOG_GROUP" --region "$REGION" --query 'logStreams[*].logStreamName' --output text | wc -l)
    fi

    local END_TIME=$(date +%s) # End time for fetching data
    local TIME_TAKEN=$((END_TIME - START_TIME)) # Time taken in seconds

    # Log both values inline and show time taken to retrieve in a single line
    if [[ "$SHOW_SIZE" == "TRUE" || "$SHOW_ITEM_COUNT" == "TRUE" ]]; then
        local message="Log Group: $LOG_GROUP"
        
        # Append size if SHOW_SIZE is TRUE
        if [[ "$SHOW_SIZE" == "TRUE" ]]; then
            if [[ -n "$SIZE" ]]; then
                message="$message, Size: $SIZE bytes"
            else
                message="$message, Size: Unable to retrieve size"
            fi
        fi
        
        # Append count if SHOW_ITEM_COUNT is TRUE
        if [[ "$SHOW_ITEM_COUNT" == "TRUE" ]]; then
            if [[ -n "$COUNT" ]]; then
                message="$message, Count: $COUNT log streams"
            else
                message="$message, Count: Unable to retrieve log stream count"
            fi
        fi
        
        # Append the time taken
        message="$message, Time taken: $TIME_TAKEN seconds."
        
        # Log the final message in one line
        log INFO "$message"
    fi
}

# Set retention policy for a given log group
# Usage: set_retention <LOG_GROUP> <RETENTION_DAYS> <REGION>
set_retention() {
    local LOG_GROUP=$1
    local RETENTION_DAYS=$2
    local REGION=$3
    local START_TIME=$(date +%s) # Start time for setting retention

    aws logs put-retention-policy --log-group-name "$LOG_GROUP" --retention-in-days "$RETENTION_DAYS" --region "$REGION"
    
    local END_TIME=$(date +%s) # End time for setting retention
    local TIME_TAKEN=$((END_TIME - START_TIME)) # Time taken in seconds

    log INFO "Retention policy set to $RETENTION_DAYS days for log group $LOG_GROUP in region $REGION in $TIME_TAKEN seconds."
}

# Export logs in the selected format
export_logs() {
    local OUTPUT_FILE="$OUTPUT_LOCATION/$OUTPUT_PREFIX"

    case "$OUTPUT_TYPE" in
        CSV)
            log INFO "Exporting logs to CSV..."
            echo "Timestamp,Log_Level,Message" > "$OUTPUT_FILE.csv"
            for entry in "${LOG_DATA[@]}"; do
                echo "$entry" | awk -F ' ' '{print $2","$1","substr($0,index($0,$3))}' >> "$OUTPUT_FILE.csv"
            done
            ;;
        JSON)
            log INFO "Exporting logs to JSON..."
            echo "[" > "$OUTPUT_FILE.json"
            for entry in "${LOG_DATA[@]}"; do
                echo "{\"timestamp\":\"$(echo $entry | awk -F ' ' '{print $2}')\",\"level\":\"$(echo $entry | awk -F ' ' '{print $1}')\",\"message\":\"$(echo $entry | awk '{$1=$2=""; print $0}')\"}," >> "$OUTPUT_FILE.json"
            done
            echo "{}]" >> "$OUTPUT_FILE.json"  # Add empty object to close the JSON array
            ;;
        TXT)
            log INFO "Exporting logs to TXT..."
            printf "%s\n" "${LOG_DATA[@]}" > "$OUTPUT_FILE.txt"
            ;;
        *)
            log ERROR "Unsupported export format: $OUTPUT_TYPE"
            exit 1
            ;;
    esac

    log SUCCESS "Logs have been exported to $OUTPUT_FILE.$OUTPUT_TYPE"
}

# Parse input arguments and flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --region) REGION="$2"; shift ;;
        --retention) RETENTION_DAYS="$2"; shift ;;
        --log-arn) LOG_ARNS="$2"; shift ;;
        --show-size) SHOW_SIZE=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift ;;
        --show-item-count) SHOW_ITEM_COUNT=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift ;;
        --output) OUTPUT=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift ;;
        --output-prefix) OUTPUT_PREFIX="$2"; shift ;;
        --output-location) OUTPUT_LOCATION="$2"; shift ;;
        --output-type) OUTPUT_TYPE=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift ;;
        --log-level) LOG_LEVEL=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift ;;
        --log-path) LOG_PATH="$2"; shift ;;
        --log-name) LOG_NAME="$2"; shift ;;
        --export-logs) EXPORT_LOGS=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift ;;
        -h|--help) display_help ;;
        *) log ERROR "Unknown parameter passed: $1"; display_help ;;
    esac
    shift
done

# Confirm the settings with the user before proceeding
clear
echo "Please confirm your settings:"
echo "  Region: $REGION"
echo "  Retention: $RETENTION_DAYS days"
echo "  Log ARNs: $LOG_ARNS"
echo "  Show Size: $SHOW_SIZE"
echo "  Show Item Count: $SHOW_ITEM_COUNT"
echo "  Output: $OUTPUT"
echo "  Output Prefix: $OUTPUT_PREFIX"
echo "  Output Location: $OUTPUT_LOCATION"
echo "  Output Type: $OUTPUT_TYPE"
echo "  Log Level: $LOG_LEVEL"
echo "  Log Path: $LOG_PATH"
echo "  Log Name: $LOG_NAME"
echo ""
read -p "Are you sure you want to continue? (Y/N): " CONFIRMATION
CONFIRMATION=$(echo "$CONFIRMATION" | tr '[:lower:]' '[:upper:]')

# Exit if the user chooses not to proceed
if [[ "$CONFIRMATION" != "Y" && "$CONFIRMATION" != "YES" ]]; then
    log ERROR "User chose to exit the script."
    echo "Context: The script was terminated because the user opted to exit. Run --help for usage."
    read -p "Press ENTER to exit..." 
    exit 1
fi

# Ensure AWS CLI is installed
check_dependencies

# Split regions into an array
IFS=',' read -r -a REGION_ARRAY <<< "$REGION"

# Process each region and its log groups
for REGION in "${REGION_ARRAY[@]}"; do
    log INFO "Processing region: $REGION"

    # Fetch all log groups if * is specified, otherwise use provided ARNs
    if [[ "$LOG_ARNS" == "*" ]]; then
        LOG_GROUPS=$(aws logs describe-log-groups --region "$REGION" --query 'logGroups[*].logGroupName' --output text)
    else
        IFS=',' read -r -a LOG_GROUPS <<< "$LOG_ARNS"
    fi

    # Iterate through log groups and set retention
    for LOG_GROUP in $LOG_GROUPS; do
        log INFO "Processing log group: $LOG_GROUP"

        # Fetch and log size and/or item count before the change
        fetch_log_group_metrics "$LOG_GROUP" "$REGION" "Before"

        # Apply the retention policy to the log group
        set_retention "$LOG_GROUP" "$RETENTION_DAYS" "$REGION"

        # Fetch and log size and/or item count after the change
        fetch_log_group_metrics "$LOG_GROUP" "$REGION" "After"
    done
done

# Optionally, export logs if the OUTPUT flag is set
if [[ "$OUTPUT" == "TRUE" ]]; then
    export_logs
fi

# Final success message
log SUCCESS "Retention policy update process completed for all log groups."
