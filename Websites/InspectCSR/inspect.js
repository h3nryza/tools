// Function to inspect CSR pasted into the textarea
function inspectCsr() {
  const csrPem = document.getElementById('csrInput').value.trim();
  processCsr(csrPem);
}

// Function to load CSR from file and inspect it
function loadCsrFromFile() {
  const fileInput = document.getElementById('csrFileInput');
  const file = fileInput.files[0];
  
  if (file) {
      const reader = new FileReader();
      reader.onload = function(event) {
          const csrPem = event.target.result.trim();
          document.getElementById('csrInput').value = csrPem; // Optional: populate textarea
          processCsr(csrPem);
      };
      reader.readAsText(file);
  } else {
      alert('Please select a CSR file to upload.');
  }
}

// Function to process CSR and display the results
function processCsr(csrPem) {
  try {
      const csr = forge.pki.certificationRequestFromPem(csrPem);

      let details = `Subject:\n`;
      csr.subject.attributes.forEach(attr => {
          details += `  ${attr.name}: ${attr.value}\n`;
      });

      details += `\nPublic Key:\n`;
      details += forge.pki.publicKeyToPem(csr.publicKey);

      if (csr.getAttribute({ name: 'extensionRequest' })) {
          details += `\nExtensions:\n`;
          const ext = csr.getAttribute({ name: 'extensionRequest' });
          if (ext.extensions) {
              ext.extensions.forEach(extension => {
                  details += `  ${extension.name}: ${extension.altNames ? extension.altNames.map(a => a.value).join(', ') : 'N/A'}\n`;
              });
          }
      }

      document.getElementById('csrDetails').innerText = details;
      document.getElementById('inspectionResult').style.display = 'block';

      // Generate and display the OpenSSL command
      const opensslCommand = generateOpenSSLCommand();
      document.getElementById('opensslCommand').textContent = opensslCommand;

  } catch (e) {
      alert('Invalid CSR format. Please check the input.');
      document.getElementById('inspectionResult').style.display = 'none';
  }
}

// Existing functions remain the same
function generateOpenSSLCommand() {
  const csrFileName = `csr.pem`; // Assume the CSR is saved as csr.pem
  return `openssl req -in ${csrFileName} -text -noout`;
}

function copyToClipboard(element) {
  navigator.clipboard.writeText(element.innerText).then(() => {
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
