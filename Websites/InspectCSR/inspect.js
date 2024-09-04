function inspectCsr() {
    const csrPem = document.getElementById('csrInput').value.trim();

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
