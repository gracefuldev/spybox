#!/bin/bash

# Install mitmproxy certificates
/usr/local/bin/install-mitm-certs.sh

# Set up transparent proxy
/usr/local/bin/setup-transparent-proxy.sh

# Execute the main command
exec "$@"