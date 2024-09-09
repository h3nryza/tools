// Function to auto-resize the textarea based on content
function autoResize(textarea) {
  textarea.style.height = 'auto';  // Reset height to auto
  textarea.style.height = textarea.scrollHeight + 'px';  // Set new height based on content
}

// Function to update line numbers as you type
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

// Function to apply rainbow brackets to JSON content
function applyRainbowBrackets(jsonInput) {
  const brackets = ['{', '}', '[', ']', '(', ')'];
  let depth = 0;
  const colors = [
      'bracket-color-1', 'bracket-color-2', 'bracket-color-3', 
      'bracket-color-4', 'bracket-color-5', 'bracket-color-6', 
      'bracket-color-7'
  ];

  let result = '';  // We'll store the final result here

  // Iterate over each character in the JSON input
  for (let i = 0; i < jsonInput.length; i++) {
      const char = jsonInput[i];
      
      if (brackets.includes(char)) {
          const colorClass = colors[(depth % colors.length)];

          if (char === '{' || char === '[' || char === '(') {
              // Opening bracket, increase depth
              depth++;
              result += `<span class="${colorClass}">${char}</span>`;
          } else {
              // Closing bracket, decrease depth
              result += `<span class="${colorClass}">${char}</span>`;
              depth--;
          }
      } else {
          // For non-bracket characters, preserve newlines and spaces
          if (char === '\n') {
              result += '<br>';
          } else if (char === ' ') {
              result += '&nbsp;';
          } else {
              result += char;  // Preserve other characters as is
          }
      }
  }

  return result;
}

// Function to format JSON input and print with rainbow brackets
function formatWithRainbowBrackets() {
  const jsonInput = document.getElementById('jsonInput').value;
  
  try {
      // Validate and format the JSON
      const jsonObj = JSON.parse(jsonInput);
      const prettyJson = JSON.stringify(jsonObj, null, 4);

      // Apply rainbow brackets to the formatted JSON
      const formattedWithBrackets = applyRainbowBrackets(prettyJson);
      document.getElementById('resultOutput').innerHTML = `<pre>${formattedWithBrackets}</pre>`;
  } catch (e) {
      document.getElementById('jsonError').innerText = 'Invalid JSON: ' + e.message;
  }
}

// Function to copy the result to the clipboard
function copyToClipboard() {
  const resultOutput = document.getElementById('resultOutput').innerText;
  navigator.clipboard.writeText(resultOutput).then(() => {
      alert('Result copied to clipboard!');
  });
}

// Function to download the result as a .txt file
function downloadResult() {
  const resultOutput = document.getElementById('resultOutput').innerText;
  const blob = new Blob([resultOutput], { type: 'text/plain' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = 'formatted_json.txt';
  link.click();
}
