function validateRSAKey() {
  const fileInput = document.getElementById('rsaKeyFile');
  const file = fileInput.files[0];

  if (file) {
      const reader = new FileReader();
      reader.onload = function(event) {
          const keyContent = event.target.result.trim();
          processRSAKey(keyContent);
      };
      reader.readAsText(file);
  } else {
      alert('Please upload an RSA key file.');
  }
}

function processRSAKey(keyContent) {
  try {
      // Try to parse the RSA key
      const privateKey = forge.pki.privateKeyFromPem(keyContent);
      
      // If no exception, it's a valid RSA private key
      document.getElementById('validationResult').innerText = 'RSA Private Key is valid!';
  } catch (e) {
      try {
          // Try to parse as RSA public key
          const publicKey = forge.pki.publicKeyFromPem(keyContent);

          // If no exception, it's a valid RSA public key
          document.getElementById('validationResult').innerText = 'RSA Public Key is valid!';
      } catch (err) {
          // If both parsing attempts fail, it's not a valid RSA key
          document.getElementById('validationResult').innerText = 'Invalid RSA Key format. Please check the file.';
      }
  }

  document.getElementById('resultBlock').style.display = 'block';
}

function copyToClipboard(elementId) {
  const content = document.getElementById(elementId).innerText;
  navigator.clipboard.writeText(content).then(() => {
      alert('Copied to clipboard');
  });
}

function downloadContent(filename, content) {
  const blob = new Blob([content], { type: 'text/plain' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = filename;
  link.click();
  URL.revokeObjectURL(link.href); // Clean up the URL object
}
