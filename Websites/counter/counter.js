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
  document.getElementById('numberCount').innerText = (text.match(/\d+/g) || []).length;

  // Special characters (excluding spaces)
  document.getElementById('specialCharCount').innerText = (text.match(/[^a-zA-Z0-9\s]/g) || []).length;
}

function autoResize(textarea) {
  textarea.style.height = 'auto';  // Reset height
  textarea.style.height = textarea.scrollHeight + 'px';  // Adjust height based on content
}

function highlightText(type) {
  const textArea = document.getElementById('textInput');
  const text = textArea.value;
  const highlightedTextArea = document.getElementById('highlightedText');
  let highlightedText = '';

  // Helper function to ensure the same font properties between pre and textarea
  copyTextareaStyle(textArea, highlightedTextArea);

  switch (type) {
    case 'char':
      const highlightCharCount = parseInt(document.getElementById('highlightCharCount').value, 10) || 0;
      highlightedText = `<span class="highlighted">${text.slice(0, highlightCharCount)}</span>${text.slice(highlightCharCount)}`;
      break;

    case 'word':
      const words = text.split(/(\s+)/);  // Split words, keeping spaces intact
      const highlightWordCount = parseInt(document.getElementById('highlightWordCount').value, 10) || 0;
      let wordIndex = 0;
      highlightedText = words.map((word) => {
        if (/\S/.test(word)) {  // Only apply to non-space sections
          if (wordIndex < highlightWordCount) {
            wordIndex++;
            return `<span class="highlighted">${word}</span>`;
          }
        }
        return word;  // Return spaces or unhighlighted words
      }).join('');
      break;

    case 'whitespace':
      const highlightWhitespaceCount = parseInt(document.getElementById('highlightWhitespaceCount').value, 10) || 0;
      highlightedText = highlightSpaces(text, highlightWhitespaceCount);
      break;

    case 'sentence':
      const sentences = text.match(/[^.!?]+[.!?]+(\s|$)/g) || [];
      const highlightSentenceCount = parseInt(document.getElementById('highlightSentenceCount').value, 10) || 0;
      highlightedText = sentences.map((sentence, index) => index < highlightSentenceCount ? `<span class="highlighted">${sentence}</span>` : sentence).join(' ');
      break;

    case 'paragraph':
      const paragraphs = text.split(/\n+/).filter(Boolean);
      const highlightParagraphCount = parseInt(document.getElementById('highlightParagraphCount').value, 10) || 0;
      highlightedText = paragraphs.map((paragraph, index) => index < highlightParagraphCount ? `<span class="highlighted">${paragraph}</span>` : paragraph).join('\n');
      break;

    case 'number':
      const numbers = text.match(/\d+/g) || [];
      const highlightNumberCount = parseInt(document.getElementById('highlightNumberCount').value, 10) || 0;
      let numberIndex = 0;
      highlightedText = text.replace(/\d+/g, (num) => {
        if (numberIndex < highlightNumberCount) {
          numberIndex++;
          return `<span class="highlighted">${num}</span>`;
        }
        return num;
      });
      break;

    case 'specialChar':
      const specialChars = text.match(/[^a-zA-Z0-9\s]/g) || [];
      const highlightSpecialCharCount = parseInt(document.getElementById('highlightSpecialCharCount').value, 10) || 0;
      let specialCharIndex = 0;
      highlightedText = text.replace(/[^a-zA-Z0-9\s]/g, (char) => {
        if (specialCharIndex < highlightSpecialCharCount) {
          specialCharIndex++;
          return `<span class="highlighted">${char}</span>`;
        }
        return char;
      });
      break;

    default:
      highlightedText = text; // Default to no highlight
  }

  highlightedTextArea.innerHTML = highlightedText.replace(/\n/g, '<br>'); // Replace newlines for HTML rendering
}

// Helper function to highlight spaces properly
function highlightSpaces(text, count) {
  let highlightedText = '';
  let spaceCount = 0;
  for (let i = 0; i < text.length; i++) {
    if (text[i] === ' ' || text[i] === '\n') {
      if (spaceCount < count) {
        highlightedText += '<span class="highlighted">' + text[i] + '</span>';
        spaceCount++;
      } else {
        highlightedText += text[i];
      }
    } else {
      highlightedText += text[i];
    }
  }
  return highlightedText;
}

// Function to copy textarea styles to pre element for alignment
function copyTextareaStyle(source, target) {
  const style = window.getComputedStyle(source);
  target.style.width = style.width;
  target.style.height = style.height;
  target.style.fontSize = style.fontSize;
  target.style.fontFamily = style.fontFamily;
  target.style.lineHeight = style.lineHeight;
  target.style.padding = style.padding;
}
