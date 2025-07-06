#!/bin/bash

echo "Tailing mitmproxy request logs..."
echo "Press Ctrl+C to stop"

# Check if log file exists
if [ ! -f /var/log/mitmproxy/requests.log ]; then
    echo "Log file not found. Creating it..."
    touch /var/log/mitmproxy/requests.log
fi

# Tail the log file
tail -f /var/log/mitmproxy/requests.log