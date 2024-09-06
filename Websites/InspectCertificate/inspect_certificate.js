let certificateContent = '';

function handleFileUpload() {
    const fileInput = document.getElementById('certificateFile');
    const file = fileInput.files[0];

    if (file) {
        const reader = new FileReader();
        reader.onload = function(event) {
            certificateContent = event.target.result.trim();

            // Check if the file is binary (DER or PFX) or text (PEM)
            const fileType = file.name.split('.').pop().toLowerCase();
            if (fileType === 'der' || fileType === 'pfx') {
                certificateContent = binaryToPem(certificateContent);
            }

            document.getElementById('inputData').value = certificateContent;
            inspectCertificate(); // Automatically inspect the certificate after upload
        };

        // Determine whether to read as text or binary
        const fileType = file.name.split('.').pop().toLowerCase();
        if (fileType === 'der' || fileType === 'pfx') {
            reader.readAsBinaryString(file);
        } else {
            reader.readAsText(file);
        }
    }
}

function inspectCertificate() {
    const inputFieldContent = document.getElementById('inputData').value.trim();
    let certPem = certificateContent || inputFieldContent;

    try {
        // If the certificate does not include PEM markers, convert it or throw an error
        if (!certPem.includes('-----BEGIN CERTIFICATE-----')) {
            if (isBinary(certPem)) {
                certPem = binaryToPem(certPem); // Convert binary to PEM for inspection
            } else {
                throw new Error('Invalid certificate format'); // Cannot process non-PEM format
            }
        }

        const cert = forge.pki.certificateFromPem(certPem);

        // Detect Certificate Type
        const certType = detectCertificateType(certPem);

        // Check if the certificate is expired
        const now = new Date();
        const isExpired = now > cert.validity.notAfter;

        const isValid = !isExpired;

        // Basic Information
        const basicInfo = `
            <strong>Common Name (CN):</strong> ${cert.subject.getField('CN').value}<br>
            <strong>Subject Alternative Names:</strong> ${getSubjectAltNames(cert)}<br>
            <strong>Hex Serial Number:</strong> ${cert.serialNumber}<br>
            <strong>Decimal Serial Number:</strong> ${BigInt('0x' + cert.serialNumber).toString()}<br>
            <strong>Thumbprint:</strong> ${getThumbprint(cert)}<br>
            <strong>Date Issued:</strong> ${cert.validity.notBefore}<br>
            <strong>Date of Expiration:</strong> ${cert.validity.notAfter}<br>
            <strong>Certificate is Valid:</strong> ${isValid ? '<span style="color: green;">True</span>' : '<span style="color: red;">False</span>'}<br>
            <strong>Certificate Type:</strong> ${certType}<br>
        `;

        // Certificate Information (Subject)
        const certInfo = getCertificateFields(cert.subject);

        // Issuer Information
        const issuerInfo = getCertificateFields(cert.issuer);

        // Other Information
        const otherInfo = `
            <strong>Version:</strong> ${cert.version + 1}<br>
            <strong>Signature Algorithm:</strong> ${cert.siginfo.algorithmOid}<br>
            <strong>Key Usage:</strong> ${getKeyUsage(cert)}<br>
            <strong>Extended Key Usage:</strong> ${getExtendedKeyUsage(cert)}<br>
        `;

        // Populate the fields
        document.getElementById('basicInfo').innerHTML = basicInfo;
        document.getElementById('certInfo').innerHTML = certInfo;
        document.getElementById('issuerInfo').innerHTML = issuerInfo;
        document.getElementById('otherInfo').innerHTML = otherInfo;

        // Generate and display the OpenSSL command
        const opensslCommand = generateOpenSSLCommand(cert);
        document.getElementById('opensslCommand').textContent = opensslCommand;

        document.getElementById('inspectionResult').style.display = 'block';
    } catch (e) {
        alert('Invalid certificate format. Please check the input.');
        document.getElementById('inspectionResult').style.display = 'none';
    }
}

// Helper function to detect if the input is binary
function isBinary(content) {
    return /[\x00-\x08\x0E-\x1F\x80-\xFF]/.test(content);
}

// Convert binary DER/PFX to PEM
function binaryToPem(binary) {
    const base64 = forge.util.encode64(binary);
    return `-----BEGIN CERTIFICATE-----\n${base64.match(/.{1,64}/g).join('\n')}\n-----END CERTIFICATE-----`;
}

// Function to detect the type of certificate (e.g., PEM, DER, PKCS12)
function detectCertificateType(certPem) {
    if (certPem.includes('-----BEGIN CERTIFICATE-----')) {
        return 'PEM';
    }
    if (certPem.includes('-----BEGIN PKCS12-----')) {
        return 'PKCS12';
    }
    return 'UNKNOWN';
}

// Function to get Subject Alternative Names
function getSubjectAltNames(cert) {
    const altNames = cert.getExtension('subjectAltName');
    if (altNames) {
        return altNames.altNames.map(name => name.value).join(', ');
    }
    return 'N/A';
}

// Function to get the thumbprint of the certificate
function getThumbprint(cert) {
    const md = forge.md.sha1.create();
    md.update(forge.asn1.toDer(forge.pki.certificateToAsn1(cert)).getBytes());
    return md.digest().toHex();
}

// Function to get key usage
function getKeyUsage(cert) {
    const keyUsage = cert.getExtension('keyUsage');
    if (keyUsage) {
        return Object.keys(keyUsage)
            .filter(key => keyUsage[key])
            .join(', ');
    }
    return 'N/A';
}

// Function to get extended key usage
function getExtendedKeyUsage(cert) {
    const extKeyUsage = cert.getExtension('extKeyUsage');
    if (extKeyUsage) {
        return Object.keys(extKeyUsage)
            .filter(key => extKeyUsage[key])
            .join(', ');
    }
    return 'N/A';
}

// Function to extract fields from the certificate
function getCertificateFields(entity) {
    return entity.attributes.map(attr => `
        <strong>${attr.name}:</strong> ${attr.value}<br>
    `).join('');
}

// Function to generate the OpenSSL command for local inspection
function generateOpenSSLCommand(cert) {
    const certType = detectCertificateType(certificateContent);

    let command = '';
    switch (certType) {
        case 'PEM':
            command = `openssl x509 -in certificate.pem -text -noout`;
            break;
        case 'DER':
            command = `openssl x509 -inform der -in certificate.der -text -noout`;
            break;
        case 'PKCS12':
            command = `openssl pkcs12 -in certificate.pfx -nodes -info`;
            break;
        default:
            command = `# Unknown certificate type. Please check the format.`;
            break;
    }

    return command;
}

// Function to copy content to clipboard
function copyToClipboard(element) {
    const text = element.textContent;
    navigator.clipboard.writeText(text).then(() => {
        alert('Copied to clipboard');
    });
}

// Function to download content as a file
function downloadContent(filename, content) {
    const blob = new Blob([content], { type: 'text/plain' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename;
    link.click();
    URL.revokeObjectURL(link.href);  // Clean up the URL object
}
