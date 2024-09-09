function convertFromHex() {
  const hexValue = document.getElementById('hexInput').value.trim();
  if (hexValue === '') {
      clearFields();
      return;
  }

  if (!/^[0-9a-fA-F]+$/.test(hexValue)) {
      alert("Invalid Hexadecimal Input");
      return;
  }

  const decimalValue = parseInt(hexValue, 16);
  document.getElementById('decimalInput').value = decimalValue;
  document.getElementById('binaryInput').value = decimalValue.toString(2);
}

function convertFromBinary() {
  const binaryValue = document.getElementById('binaryInput').value.trim();
  if (binaryValue === '') {
      clearFields();
      return;
  }

  if (!/^[01]+$/.test(binaryValue)) {
      alert("Invalid Binary Input");
      return;
  }

  const decimalValue = parseInt(binaryValue, 2);
  document.getElementById('decimalInput').value = decimalValue;
  document.getElementById('hexInput').value = decimalValue.toString(16).toUpperCase();
}

function convertFromDecimal() {
  const decimalValue = document.getElementById('decimalInput').value.trim();
  if (decimalValue === '') {
      clearFields();
      return;
  }

  if (!/^\d+$/.test(decimalValue)) {
      alert("Invalid Decimal Input");
      return;
  }

  const intValue = parseInt(decimalValue, 10);
  document.getElementById('hexInput').value = intValue.toString(16).toUpperCase();
  document.getElementById('binaryInput').value = intValue.toString(2);
}

function clearFields() {
  document.getElementById('hexInput').value = '';
  document.getElementById('binaryInput').value = '';
  document.getElementById('decimalInput').value = '';
}

function autoResize(textarea) {
  textarea.style.height = 'auto';  // Reset height
  textarea.style.height = textarea.scrollHeight + 'px';  // Set height based on content
}
