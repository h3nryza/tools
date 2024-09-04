function convertNumber() {
  const inputValue = document.getElementById('inputValue').value;
  const inputType = document.getElementById('inputType').value;
  const outputType = document.getElementById('outputType').value;
  let result = '';

  if (!inputValue) {
      alert('Please enter a number.');
      return;
  }

  try {
      switch (inputType) {
          case 'decimal':
              result = convertFromDecimal(inputValue, outputType);
              break;
          case 'hex':
              result = convertFromHex(inputValue, outputType);
              break;
          case 'binary':
              result = convertFromBinary(inputValue, outputType);
              break;
      }
      document.getElementById('output').innerText = result;
      document.getElementById('resultBlock').style.display = 'block';
  } catch (error) {
      alert('Error in conversion: ' + error.message);
  }
}

function convertFromDecimal(value, outputType) {
  const decimalValue = parseInt(value, 10);
  if (isNaN(decimalValue)) throw new Error('Invalid decimal number.');
  
  switch (outputType) {
      case 'hex': return decimalValue.toString(16).toUpperCase();
      case 'binary': return decimalValue.toString(2);
      default: return decimalValue.toString(10);
  }
}

function convertFromHex(value, outputType) {
  const decimalValue = parseInt(value, 16);
  if (isNaN(decimalValue)) throw new Error('Invalid hexadecimal number.');
  
  switch (outputType) {
      case 'decimal': return decimalValue.toString(10);
      case 'binary': return decimalValue.toString(2);
      default: return value.toUpperCase();
  }
}

function convertFromBinary(value, outputType) {
  const decimalValue = parseInt(value, 2);
  if (isNaN(decimalValue)) throw new Error('Invalid binary number.');
  
  switch (outputType) {
      case 'decimal': return decimalValue.toString(10);
      case 'hex': return decimalValue.toString(16).toUpperCase();
      default: return value;
  }
}

function copyToClipboard() {
  const output = document.getElementById('output').innerText;
  navigator.clipboard.writeText(output).then(() => {
      alert('Copied to clipboard');
  });
}
