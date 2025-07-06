# Spybox - HTTP Request Monitoring with mitmproxy

A VSCode devcontainer setup for monitoring HTTP requests using mitmproxy with transparent and manual proxy configurations.

## Features

- **Transparent Proxy**: Automatically intercepts HTTP/HTTPS traffic using iptables
- **Manual Proxy**: Fallback configuration with explicit proxy settings
- **Multi-language Support**: Demo scripts for curl, Python, JavaScript, and Ruby
- **SSL Interception**: Automatic certificate handling for HTTPS traffic
- **Log Monitoring**: Shared volume for accessing mitmproxy logs from the main container
- **Web UI**: Access mitmproxy web interface at http://localhost:8081

## Quick Start

1. Open this directory in VSCode
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and start
4. Access the mitmproxy web UI at http://localhost:8081

## Testing HTTP Requests

### Using Demo Scripts

Run the included demo scripts to test HTTP request interception:

```bash
# Test with curl
./scripts/test-curl.sh

# Test with Python
python3 scripts/test-python.py

# Test with JavaScript/Node.js
node scripts/test-javascript.js

# Test with Ruby
ruby scripts/test-ruby.rb
```

### Manual Proxy Testing

Test explicit proxy configuration:

```bash
./scripts/test-manual-proxy.sh
```

## Monitoring Requests

### View Logs in Terminal

```bash
# Tail the request logs
./scripts/tail-logs.sh
```

### Web Interface

Access the mitmproxy web interface at http://localhost:8081 to view requests in real-time.

## How It Works

### Transparent Proxy

- iptables rules redirect HTTP (port 80) and HTTPS (port 443) traffic to mitmproxy
- mitmproxy runs in transparent mode on port 8080
- SSL certificates are automatically installed for HTTPS interception

### Manual Proxy

Environment variables are set for proxy configuration:
- `HTTP_PROXY=http://mitmproxy:8080`
- `HTTPS_PROXY=http://mitmproxy:8080`
- Certificate paths are configured for SSL verification

### Certificate Handling

- mitmproxy generates its own CA certificate
- The certificate is installed in the system trust store
- Language-specific certificate paths are configured

## Container Architecture

- **main**: Project container with development tools and languages
- **mitmproxy**: Proxy service with web UI and logging
- **Shared volumes**: For logs and certificates
- **Network**: Bridge network for service communication

## Files

- `.devcontainer/devcontainer.json`: VSCode devcontainer configuration
- `.devcontainer/docker-compose.yml`: Service definitions
- `.devcontainer/Dockerfile`: Main container image
- `scripts/`: Demo scripts and utilities
- `scripts/log_requests.py`: mitmproxy logging script