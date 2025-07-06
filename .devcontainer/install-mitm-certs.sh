#!/bin/bash

echo "Installing mitmproxy certificates..."

# Wait for mitmproxy certificates to be available
while [ ! -f /usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.pem ]; do
    echo "Waiting for mitmproxy certificates..."
    sleep 2
done

# Copy the mitmproxy CA certificate to the system certificate store
cp /usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.pem /usr/local/share/ca-certificates/mitmproxy-ca-cert.crt

# Update the certificate store
update-ca-certificates

# Set up Python certificate handling
export SSL_CERT_FILE=/usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.pem
export REQUESTS_CA_BUNDLE=/usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.pem

# Set up Node.js certificate handling
export NODE_EXTRA_CA_CERTS=/usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.pem

# Set up Ruby certificate handling
export SSL_CERT_DIR=/usr/local/share/ca-certificates

echo "Certificates installed successfully"