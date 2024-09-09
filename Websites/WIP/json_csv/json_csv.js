function updateLineNumbers(textareaId, lineNumberId) {
  const textarea = document.getElementById(textareaId);
  const lineNumbersDiv = document.getElementById(lineNumberId);
  const lines = textarea.value.split('\n').length;
  let lineNumberText = '';
  for (let i = 1; i <= lines; i++) {
      lineNumberText += i + '\n';
  }
  lineNumbersDiv.innerText = lineNumberText;
}

function convertJsonToCsv() {
  clearError("jsonError");  // Clear previous errors
  const jsonInput = document.getElementById('jsonInput').value;

  try {
      const jsonObj = JSON.parse(jsonInput);  // Parse the JSON
      const flatJson = flattenJson(jsonObj);  // Flatten the JSON
      const csv = jsonToCsv(flatJson);
      document.getElementById('resultOutput').value = csv;
      updateLineNumbers('resultOutput', 'resultLineNumbers');  // Update line numbers in the result
  } catch (e) {
      highlightError('jsonInput', e.message);  // Highlight the error in JSON input
      document.getElementById('jsonError').innerText = "Error: " + e.message;
  }
}

function jsonToCsv(jsonArray) {
  const headers = Object.keys(jsonArray[0]);
  const csvRows = jsonArray.map(row => 
      headers.map(header => `"${row[header]}"`).join(',')  // Enclose values in double quotes
  );
  
  return [headers.join(','), ...csvRows].join('\n');
}

function flattenJson(jsonObj) {
  const result = [];

  function recurse(currentObj, currentPath) {
      if (typeof currentObj !== 'object' || currentObj === null) {
          return { [currentPath]: currentObj };
      }

      return Object.keys(currentObj).reduce((acc, key) => {
          const newKey = currentPath ? `${currentPath}.${key}` : key;
          return { ...acc, ...recurse(currentObj[key], newKey) };
      }, {});
  }

  if (Array.isArray(jsonObj)) {
      jsonObj.forEach(item => {
          result.push(recurse(item, ''));
      });
  } else {
      result.push(recurse(jsonObj, ''));
  }

  return result;
}

function convertCsvToJson() {
  clearError("csvError");  // Clear previous errors
  const csvInput = document.getElementById('csvInput').value;

  try {
      const json = csvToJson(csvInput);
      document.getElementById('resultOutput').value = JSON.stringify(json, null, 4);  // Format JSON with 4 space indent
      updateLineNumbers('resultOutput', 'resultLineNumbers');  // Update line numbers in the result
  } catch (e) {
      highlightError('csvInput', e.message);  // Highlight the error in CSV input
      document.getElementById('csvError').innerText = "Error: " + e.message;
  }
}

function csvToJson(csvText) {
  const [headerLine, ...lines] = csvText.split('\n').filter(Boolean);
  const headers = parseCsvLine(headerLine);

  return lines.map(line => {
      const values = parseCsvLine(line);
      return headers.reduce((obj, header, index) => {
          obj[header] = values[index];
          return obj;
      }, {});
  });
}

function parseCsvLine(line) {
  const values = [];
  let current = '';
  let insideQuotes = false;
  let quoteChar = null;

  for (let i = 0; i < line.length; i++) {
      const char = line[i];

      if ((char === '"' || char === "'") && !insideQuotes) {
          insideQuotes = true;  // Entering a quoted section
          quoteChar = char;  // Track if it's single or double quotes
      } else if (char === quoteChar && insideQuotes) {
          if (line[i + 1] === quoteChar) {
              // Escaped quote
              current += quoteChar;
              i++;  // Skip next quote
          } else {
              insideQuotes = false;  // Leaving quoted section
              quoteChar = null;
          }
      } else if (char === ',' && !insideQuotes) {
          // End of current value
          values.push(current.trim());
          current = '';
      } else {
          current += char;
      }
  }

  // Push the final value
  values.push(current.trim());

  return values;
}

function copyToClipboard() {
  const resultOutput = document.getElementById('resultOutput');
  resultOutput.select();
  document.execCommand('copy');
  alert("Copied to clipboard");
}

function downloadResult() {
  const result = document.getElementById('resultOutput').value;
  const blob = new Blob([result], { type: "text/plain" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = "result.txt";
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
}

function highlightError(inputId, errorMsg) {
  const inputElement = document.getElementById(inputId);
  inputElement.style.borderColor = "red";  // Highlight the error area with red border
}

function clearError(errorBlockId) {
  document.getElementById('jsonInput').style.borderColor = "";  // Reset JSON input border
  document.getElementById('csvInput').style.borderColor = "";  // Reset CSV input border
  document.getElementById(errorBlockId).innerText = "";  // Clear error messages
}

function autoResize(textarea) {
  textarea.style.height = 'auto';  // Reset height
  textarea.style.height = textarea.scrollHeight + 'px';  // Adjust height based on content
  updateLineNumbers(textarea.id, textarea.id + 'LineNumbers');  // Update line numbers when resizing
}
