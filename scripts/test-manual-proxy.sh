#!/bin/bash

echo "Testing manual proxy configuration..."

# Test with curl using explicit proxy
echo "=== Testing curl with manual proxy ==="
curl -v --proxy http://mitmproxy:8080 http://httpbin.org/get

echo -e "\n=== Testing curl with HTTPS and manual proxy ==="
curl -v --proxy http://mitmproxy:8080 --cacert /usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.pem https://httpbin.org/get

# Test Python with manual proxy
echo -e "\n=== Testing Python with manual proxy ==="
python3 -c "
import requests
import os

# Set proxy manually
proxies = {
    'http': 'http://mitmproxy:8080',
    'https': 'http://mitmproxy:8080'
}

# Set certificate path
os.environ['REQUESTS_CA_BUNDLE'] = '/usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.pem'

try:
    response = requests.get('https://httpbin.org/get', proxies=proxies)
    print(f'Status: {response.status_code}')
    print(f'Response: {response.text[:100]}...')
except Exception as e:
    print(f'Error: {e}')
"