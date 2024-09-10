#!/bin/bash

# Step 1: Get the latest assessment ARN
assessment_arn=$(aws resiliencehub list-app-assessments --query "reverse(sort_by(assessmentSummaries, &endTime))[:1].assessmentArn" --output text)

# Check if an assessment ARN was found
if [ -z "$assessment_arn" ]; then
    echo "Error: Could not retrieve the latest assessment ARN."
    exit 1
fi

# Step 2: Get the detailed report using the assessment ARN
assessment_report_raw=$(aws resiliencehub list-app-component-compliances --assessment-arn "$assessment_arn" --output json)

# Step 3: Clean the JSON report to remove control characters
assessment_report=$(echo "$assessment_report_raw" | tr -d '\000-\037')

# Step 4: Extract app name from ARN for file naming
app_name=$(echo "$assessment_arn" | awk -F'/' '{print $NF}')

# Output file names
html_file="dr_compliance_report.html"
pdf_file="dr_compliance_report.pdf"

# Step 5: Create the HTML header
cat <<EOL > "$html_file"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compliance Report for $app_name</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 20px;
            background-color: #f4f4f9;
        }
        h1, h2 {
            color: #333;
        }
        .component {
            border: 1px solid #ddd;
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 8px;
            background-color: #fff;
        }
        .compliance-status {
            padding: 5px;
            border-radius: 5px;
            font-weight: bold;
            display: inline-block;
        }
        .breached {
            background-color: #f44336;
            color: #fff;
        }
        .met {
            background-color: #4caf50;
            color: #fff;
        }
        .description {
            margin-top: 10px;
        }
        .separator {
            margin: 10px 0;
            height: 1px;
            background-color: #ddd;
        }
    </style>
</head>
<body>
    <h1>Compliance Report for $app_name</h1>
EOL

# Function to highlight compliance status
highlight_status_html() {
  local status=$1
  if [[ $status == *"Breach"* ]]; then
    echo "<span class='compliance-status breached'>Policy Breached</span>"
  else
    echo "<span class='compliance-status met'>Policy Met</span>"
  fi
}

# Step 6: Group components by compliance status
generate_section() {
  local section_title=$1
  local compliance_filter=$2

  echo "<h2>$section_title</h2>" >> "$html_file"
  echo "$assessment_report" | jq -c ".componentCompliances[] | select(.compliance.Software.complianceStatus == \"$compliance_filter\")" | while read -r component; do
    appComponentName=$(echo "$component" | jq -r '.appComponentName')
    status=$(echo "$component" | jq -r '.compliance.Software.complianceStatus')
    rpoDescription=$(echo "$component" | jq -r '.compliance.Software.rpoDescription')
    rtoDescription=$(echo "$component" | jq -r '.compliance.Software.rtoDescription')

    echo "<div class='component'>" >> "$html_file"
    echo "<h3>Component: $appComponentName</h3>" >> "$html_file"
    echo "<p>Status: $(highlight_status_html "$status")</p>" >> "$html_file"
    echo "<p>RPO Description: $rpoDescription</p>" >> "$html_file"
    echo "<p>RTO Description: $rtoDescription</p>" >> "$html_file"
    echo "<div class='separator'></div>" >> "$html_file"
    echo "</div>" >> "$html_file"
  done
}

# Step 7: Generate sections for breached and non-breached policies
generate_section "Breached Policies" "PolicyBreached"
generate_section "Non-Breached Policies" "PolicyMet"

# Step 8: Close the HTML file
cat <<EOL >> "$html_file"
</body>
</html>
EOL

echo "HTML report generated: $html_file"

# Step 9: Convert the HTML report to PDF using wkhtmltopdf if installed
if command -v wkhtmltopdf &> /dev/null
then
    wkhtmltopdf "$html_file" "$pdf_file"
    echo "PDF report generated: $pdf_file"
else
    echo "wkhtmltopdf is not installed. Please install it to generate PDF reports."
fi
