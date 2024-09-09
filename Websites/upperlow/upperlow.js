function convertToLowercase() {
  const uppercaseText = document.getElementById('uppercaseInput').value;
  document.getElementById('lowercaseInput').value = uppercaseText.toLowerCase();
}

function convertToUppercase() {
  const lowercaseText = document.getElementById('lowercaseInput').value;
  document.getElementById('uppercaseInput').value = lowercaseText.toUpperCase();
}

function autoResize(textarea) {
  textarea.style.height = 'auto';  // Reset height
  textarea.style.height = textarea.scrollHeight + 'px';  // Set height based on content
}
