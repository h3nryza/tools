#!/bin/bash

# Function to display help information
display_help() {
    echo "Usage: $0 --domains=domain1,domain2,... --checks=check1,check2,... [--all] [--output_all=LOCATION] [--input=FILE]"
    echo ""
    echo "This script performs various domain information checks and generates HTML and PDF reports."
    echo ""
    echo "Available Checks:"
    echo "  whois     - Perform a WHOIS lookup"
    echo "  a         - Check DNS A record"
    echo "  mx        - Check MX records"
    echo "  spf       - Check SPF records"
    echo "  txt       - Check TXT records"
    echo "  ptr       - Check PTR (reverse DNS) record"
    echo "  cname     - Check CNAME record"
    echo "  arin      - Perform ARIN lookup for IP block information"
    echo "  soa       - Check SOA (Start of Authority) record"
    echo "  tcp       - Check TCP connection to domain"
    echo "  http      - Check HTTP connection to domain"
    echo "  https     - Check HTTPS connection to domain"
    echo "  ns        - Check NS (Name Server) records"
    echo "  ip        - Lookup IP address for domain"
    echo "  srv       - Check SRV (Service) records"
    echo "  aaaa      - Check AAAA (IPv6) record"
    echo "  ping      - Perform a ping test (max 5 pings)"
    echo "  trace     - Perform a trace route (limited to 5 hops)"
    echo "  --all     - Perform all available checks"
    echo ""
    echo "Options:"
    echo "  --domains=domain1,domain2,...  - Specify multiple domains to check"
    echo "  --checks=check1,check2,...     - Specify checks to run"
    echo "  --output_all=LOCATION          - Specify a location to output the reports"
    echo "  --input=FILE                   - Specify a file with a list of domains"
    echo "  --help                         - Display this help message"
    echo ""
    echo "Example Usage:"
    echo "  $0 --domains=example.com,example.net --checks=a,mx --output_all=./outputs/"
    echo "  $0 --input=domains.txt --all --output_all=./outputs/"
    exit 0
}

# Function to create output directory if it doesn't exist
create_output_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "Created output directory: $1"
    fi
}

# Function to get timestamp
get_timestamp() {
    date +"%Y%m%d_%H%M%S"
}

# Function to append HTML formatted output
append_html_output() {
    if [ -z "$2" ]; then
        result="No data returned"
    else
        result="$2"
    fi
    echo "<tr><td>$domain</td><td>$1</td><td><pre>$result</pre></td></tr>" >> "$output_html_file"
}

# Function to export results to HTML and PDF
export_results() {
    timestamp=$(get_timestamp)
    base_filename="${timestamp}_${domain}"
    html_file="${output_dir}/${base_filename}.html"
    pdf_file="${output_dir}/${base_filename}.pdf"

    # Write HTML content to file
    echo -e "<html>\n<head>\n<title>Domain Information Report</title>\n<style>\ntable{width:100%;border-collapse:collapse;margin:20px 0}\nth,td{padding:8px;text-align:left;border:1px solid #ddd;}\nth{background-color:#f2f2f2;}body{font-family:Arial,sans-serif;}\n</style>\n</head>\n<body>\n<h1>Domain Information Report</h1>\n<table>\n<tr><th>Domain</th><th>Check Type</th><th>Results</th></tr>" > "$html_file"
    cat "$output_html_file" >> "$html_file"
    echo "</table></body></html>" >> "$html_file"
    echo "HTML report generated at $html_file"

}

# Function to show progress
show_progress() {
    echo "Running: $1 for $domain"
}

# Functions to perform individual checks with formatted output
whois_lookup() { show_progress "WHOIS Lookup"; result=$(whois $domain); append_html_output "WHOIS" "$result"; }
dns_a_lookup() { show_progress "DNS A Record Lookup"; result=$(dig +short A $domain); append_html_output "DNS A" "$result"; }
mx_record_lookup() { show_progress "MX Record Lookup"; result=$(dig +short MX $domain); append_html_output "MX" "$result"; }
spf_record_lookup() { show_progress "SPF Record Lookup"; result=$(dig +short TXT $domain | grep 'v=spf1'); append_html_output "SPF" "$result"; }
txt_record_lookup() { show_progress "TXT Record Lookup"; result=$(dig +short TXT $domain); append_html_output "TXT" "$result"; }
ptr_record_lookup() { show_progress "PTR Record Lookup"; result=$(dig +short PTR $domain); append_html_output "PTR" "$result"; }
cname_record_lookup() { show_progress "CNAME Record Lookup"; result=$(dig +short CNAME $domain); append_html_output "CNAME" "$result"; }
arin_lookup() { show_progress "ARIN Lookup"; result=$(whois $domain | grep -i "netrange\|cidr\|orgname"); append_html_output "ARIN" "$result"; }
soa_record_lookup() { show_progress "SOA Record Lookup"; result=$(dig +short SOA $domain); append_html_output "SOA" "$result"; }
tcp_check() { show_progress "TCP Check"; result=$(timeout 5 bash -c "</dev/tcp/$domain/80" && echo "TCP connection to port 80 successful" || echo "TCP connection to port 80 failed"); append_html_output "TCP" "$result"; }
http_check() { show_progress "HTTP Check"; result=$(curl -Is http://$domain | head -n 1); append_html_output "HTTP" "$result"; }
https_check() { show_progress "HTTPS Check"; result=$(curl -Is https://$domain | head -n 1); append_html_output "HTTPS" "$result"; }
ns_record_lookup() { show_progress "NS Record Lookup"; result=$(dig +short NS $domain); append_html_output "NS" "$result"; }
ip_lookup() { show_progress "IP Lookup"; result=$(dig +short $domain); append_html_output "IP" "$result"; }
srv_record_lookup() { show_progress "SRV Record Lookup"; result=$(dig +short SRV $domain); append_html_output "SRV" "$result"; }
aaaa_record_lookup() { show_progress "AAAA Record Lookup"; result=$(dig +short AAAA $domain); append_html_output "AAAA" "$result"; }
ping_test() { show_progress "Ping Test"; result=$(ping -c 5 $domain); append_html_output "PING" "$result"; }
trace_route() { show_progress "Trace Route"; result=$(traceroute -m 5 $domain); append_html_output "TRACE" "$result"; }

# Function to perform all checks
perform_all_checks() {
    whois_lookup
    dns_a_lookup
    mx_record_lookup
    spf_record_lookup
    txt_record_lookup
    ptr_record_lookup
    cname_record_lookup
    arin_lookup
    soa_record_lookup
    tcp_check
    http_check
    https_check
    ns_record_lookup
    ip_lookup
    srv_record_lookup
    aaaa_record_lookup
    ping_test
    trace_route
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --domains:*)
            domains_str="${1#--domains:}"
            IFS=',' read -r -a domains <<< "$domains_str"
            shift
            ;;
        --checks:*)
            checks_str="${1#--checks:}"
            IFS=',' read -r -a checks <<< "$checks_str"
            shift
            ;;
        --output_all=*)
            output_dir="${1#*=}"
            create_output_directory "$output_dir"
            shift
            ;;
        --input=*)
            input_file="${1#*=}"
            while IFS= read -r line; do
                domains+=("$line")
            done < "$input_file"
            shift
            ;;
        --help|-h)
            display_help
            ;;
        --all)
            checks=("whois" "a" "mx" "spf" "txt" "ptr" "cname" "arin" "soa" "tcp" "http" "https" "ns" "ip" "srv" "aaaa" "ping" "trace")
            shift
            ;;
        *)
            domains+=("$1")
            shift
            ;;
    esac
done

# Ensure there is at least one domain
if [ ${#domains[@]} -eq 0 ]; then
    display_help
fi

# Default to all checks if no specific checks are given
if [ ${#checks[@]} -eq 0 ]; then
    checks=("whois" "a" "mx" "spf" "txt" "ptr" "cname" "arin" "soa" "tcp" "http" "https" "ns" "ip" "srv" "aaaa" "ping" "trace")
fi

# Perform the requested checks for each domain
for domain in "${domains[@]}"; do
    output_html_file=$(mktemp)  # Create a temporary file to store HTML output for each domain

    # Start the HTML output file with the header
    echo -e "<html>\n<head>\n<title>Domain Information Report</title>\n<style>\ntable{width:100%;border-collapse:collapse;margin:20px 0}\nth,td{padding:8px;text-align:left;border:1px solid #ddd;}\nth{background-color:#f2f2f2;}body{font-family:Arial,sans-serif;}\n</style>\n</head>\n<body>\n<h1>Domain Information Report</h1>\n<table>\n<tr><th>Domain</th><th>Check Type</th><th>Results</th></tr>" > "$output_html_file"

    for check in "${checks[@]}"; do
        case $check in
            whois) whois_lookup ;;
            a) dns_a_lookup ;;
            mx) mx_record_lookup ;;
            spf) spf_record_lookup ;;
            txt) txt_record_lookup ;;
            ptr) ptr_record_lookup ;;
            cname) cname_record_lookup ;;
            arin) arin_lookup ;;
            soa) soa_record_lookup ;;
            tcp) tcp_check ;;
            http) http_check ;;
            https) https_check ;;
            ns) ns_record_lookup ;;
            ip) ip_lookup ;;
            srv) srv_record_lookup ;;
            aaaa) aaaa_record_lookup ;;
            ping) ping_test ;;
            trace) trace_route ;;
            *) echo "Unknown check: $check" ;;
        esac
    done

    # Close the HTML tags
    echo "</table></body></html>" >> "$output_html_file"

    # Export the results to the final HTML and PDF files
    export_results

    # Clean up the temporary file
    rm "$output_html_file"
done
