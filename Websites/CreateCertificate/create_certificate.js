document.addEventListener('DOMContentLoaded', function() {
  populateCountryList();
});

function populateCountryList() {
  const countrySelect = document.getElementById('country');

  fetch('https://restcountries.com/v3.1/all')
      .then(response => response.json())
      .then(countries => {
          countries.sort((a, b) => a.name.common.localeCompare(b.name.common)); // Sort countries alphabetically
          countrySelect.innerHTML = ''; // Clear the initial loading option
          countries.forEach(country => {
              const option = document.createElement('option');
              option.value = escapeHtml(country.cca2); // ISO 3166-1 alpha-2 code
              option.text = escapeHtml(country.name.common); // Country name
              countrySelect.add(option);
          });
      })
      .catch(error => {
          console.error('Error fetching country list:', error);
          countrySelect.innerHTML = '<option value="">Error loading countries</option>';
      });
}

function adjustOptions() {
  const certType = document.getElementById('certType').value;
  const certSettings = document.getElementById('certSettings');
  const validityLabel = document.getElementById('validityLabel');
  const validityPeriod = document.getElementById('validityPeriod');
  const sanSection = document.getElementById('sanSection');

  if (certType === 'rsa') {
      certSettings.style.display = 'none';
  } else {
      certSettings.style.display = 'block';
  }

  if (certType === 'csr') {
      validityLabel.style.display = 'none';
      validityPeriod.style.display = 'none';
      sanSection.style.display = 'block';
  } else {
      validityLabel.style.display = 'block';
      validityPeriod.style.display = 'block';
      sanSection.style.display = 'none';
  }
}

function generateCertificate() {
  const certType = document.getElementById('certType').value;
  const keySize = parseInt(document.getElementById('keySize').value);
  const signatureAlg = document.getElementById('signatureAlg').value;
  const validityPeriod = parseInt(document.getElementById('validityPeriod').value);
  const commonName = escapeHtml(document.getElementById('commonName').value);
  const organization = escapeHtml(document.getElementById('organization').value);
  const organizationalUnit = escapeHtml(document.getElementById('organizationalUnit').value);
  const city = escapeHtml(document.getElementById('city').value);
  const state = escapeHtml(document.getElementById('state').value);
  const country = escapeHtml(document.getElementById('country').value);
  const altNames = document.getElementById('altNames').value.split(',').map(name => escapeHtml(name.trim()));

  let output = '';
  const keys = forge.pki.rsa.generateKeyPair(keySize);

  if (certType === 'rsa') {
      // Generate RSA Key Pair
      output += generateOutputBlock('Private Key', forge.pki.privateKeyToPem(keys.privateKey), `${commonName || 'rsa'}-rsa-${getCurrentDate()}.key`);
      output += generateOutputBlock('Public Key', forge.pki.publicKeyToPem(keys.publicKey), `${commonName || 'rsa'}-rsa-${getCurrentDate()}.pub`);
  } else if (certType === 'csr') {
      // Generate CSR (Certificate Signing Request)
      const csr = forge.pki.createCertificationRequest();
      csr.publicKey = keys.publicKey;
      csr.setSubject([
          { name: 'commonName', value: commonName },
          { name: 'countryName', value: country },
          { name: 'stateOrProvinceName', value: state },
          { name: 'localityName', value: city },
          { name: 'organizationName', value: organization },
          { name: 'organizationalUnitName', value: organizationalUnit }
      ]);

      // Add Subject Alternative Names (SANs) if provided
      if (altNames.length > 0 && altNames[0] !== "") {
          const altNameExt = altNames.map(name => ({ type: 2, value: name }));
          csr.setAttributes([{
              name: 'extensionRequest',
              extensions: [{
                  name: 'subjectAltName',
                  altNames: altNameExt
              }]
          }]);
      }

      csr.sign(keys.privateKey, forge.md[signatureAlg.replace('withRSA', '').toLowerCase()].create());
      output += generateOutputBlock('CSR', forge.pki.certificationRequestToPem(csr), `${commonName || 'csr'}-csr-${getCurrentDate()}.csr`);
      output += generateOutputBlock('Private Key', forge.pki.privateKeyToPem(keys.privateKey), `${commonName || 'csr'}-csr-${getCurrentDate()}.key`);
  } else {
      // Generate Certificate (Code Signing or Self-Signed)
      const cert = forge.pki.createCertificate();
      cert.publicKey = keys.publicKey;
      cert.serialNumber = '01';
      cert.validity.notBefore = new Date();
      cert.validity.notAfter = new Date();
      cert.validity.notAfter.setFullYear(cert.validity.notBefore.getFullYear() + validityPeriod);

      const attrs = [
          { name: 'commonName', value: commonName },
          { name: 'countryName', value: country },
          { name: 'stateOrProvinceName', value: state },
          { name: 'localityName', value: city },
          { name: 'organizationName', value: organization },
          { name: 'organizationalUnitName', value: organizationalUnit }
      ];

      cert.setSubject(attrs);

      if (certType === 'selfSigned') {
          cert.setIssuer(attrs); // Self-Signed: Issuer and Subject are the same
      } else {
          cert.setIssuer([
              { name: 'commonName', value: 'Your Issuing CA' },
              { name: 'countryName', value: 'US' }
          ]); // Example issuer for Code Signing Cert
      }

      cert.sign(keys.privateKey, forge.md[signatureAlg.replace('withRSA', '').toLowerCase()].create());

      output += generateOutputBlock('Private Key', forge.pki.privateKeyToPem(keys.privateKey), `${commonName || 'certificate'}-${certType}-${getCurrentDate()}.key`);
      output += generateOutputBlock('Certificate', forge.pki.certificateToPem(cert), `${commonName || 'certificate'}-${certType}-${getCurrentDate()}.crt`);
  }

  document.getElementById('output').innerHTML = output;  // Render the HTML directly
  document.getElementById('resultBlock').style.display = 'block';

  // Generate the local OpenSSL command
  const localCommand = generateLocalCommand(certType, keySize, commonName, organization, organizationalUnit, city, state, country, altNames, validityPeriod);
  document.getElementById('localCodeBlock').textContent = localCommand;
}

function generateOutputBlock(title, content, filename) {
  return `
      <div class="output-section">
        <h4>${escapeHtml(title)}</h4>
        <pre>${content}</pre>  <!-- No escaping here for certificate content -->
        <div class="action-buttons">
            <button onclick="copyToClipboard(this.closest('.output-section').querySelector('pre'))">Copy ${escapeHtml(title)}</button>
            <button onclick="downloadContent('${escapeHtml(filename)}', ${JSON.stringify(content)})">Download ${escapeHtml(title)}</button>
        </div>
      </div>
  `;
}

function generateLocalCommand(certType, keySize, commonName, organization, organizationalUnit, city, state, country, altNames, validityPeriod) {
  let command = '';
  const subj = `/CN=${commonName}/O=${organization}/OU=${organizationalUnit}/L=${city}/ST=${state}/C=${country}`;

  if (certType === 'csr') {
      command = `openssl req -new -newkey rsa:${keySize} -nodes -keyout ${commonName || 'key'}.key -out ${commonName || 'csr'}.csr \\\n`;
      command += `-subj "${subj}" \\\n`;

      if (altNames.length > 0 && altNames[0] !== "") {
          command += `-reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\\nsubjectAltName=${altNames.map((name, i) => `DNS.${i + 1}=${name}`).join(', ')}"))\n`;
      }
  } else if (certType === 'selfSigned') {
      command = `openssl req -x509 -new -newkey rsa:${keySize} -nodes -keyout ${commonName || 'key'}.key -out ${commonName || 'crt'}.crt \\\n`;
      command += `-days ${validityPeriod * 365} -subj "${subj}"`;
  } else if (certType === 'rsa') {
      command = `openssl genpkey -algorithm RSA -out ${commonName || 'key'}.key -pkeyopt rsa_keygen_bits:${keySize}\n`;
      command += `openssl rsa -in ${commonName || 'key'}.key -pubout -out ${commonName || 'key'}.pub\n`;
  } else if (certType === 'codeSigning') {
      command = `openssl req -new -newkey rsa:${keySize} -nodes -keyout ${commonName || 'key'}.key -out ${commonName || 'csr'}.csr -subj "${subj}"\n`;
      command += `openssl x509 -req -in ${commonName || 'csr'}.csr -signkey ${commonName || 'key'}.key -out ${commonName || 'crt'}.crt -days ${validityPeriod * 365}`;
  }

  return command || 'No local command available for this type.';
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

function getCurrentDate() {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

function escapeHtml(unsafe) {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}
