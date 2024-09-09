function updateCounts() {
  const text = document.getElementById('textInput').value;

  // Character count
  document.getElementById('charCount').innerText = text.length;

  // Word count
  document.getElementById('wordCount').innerText = text.trim().split(/\s+/).filter(Boolean).length;

  // Whitespace count
  document.getElementById('whitespaceCount').innerText = (text.match(/\s/g) || []).length;

  // Sentence count
  document.getElementById('sentenceCount').innerText = (text.match(/[.!?](\s|$)/g) || []).length;

  // Paragraph count
  document.getElementById('paragraphCount').innerText = text.split(/\n+/).filter(Boolean).length;

  // Number count
  document.getElementById('numberCount').innerText = (text.match(/\d/g) || []).length;

  // Special characters (excluding spaces)
  document.getElementById('specialCharCount').innerText = (text.match(/[^a-zA-Z0-9\s]/g) || []).length;
}

function autoResize(textarea) {
  textarea.style.height = 'auto';  // Reset height
  textarea.style.height = textarea.scrollHeight + 'px';  // Adjust height based on content
}
