#!/bin/bash

# Wait for mitmproxy to be available
echo "Waiting for mitmproxy to be available..."
while ! nc -z mitmproxy 8080; do
    sleep 1
done

echo "Setting up transparent proxy with iptables..."

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Get mitmproxy container IP
MITMPROXY_IP=$(getent hosts mitmproxy | awk '{ print $1 }')
echo "Mitmproxy IP: $MITMPROXY_IP"

# Redirect HTTP traffic to mitmproxy
iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination $MITMPROXY_IP:8080
iptables -t nat -A OUTPUT -p tcp --dport 443 -j DNAT --to-destination $MITMPROXY_IP:8080

# Allow loopback traffic
iptables -t nat -I OUTPUT -o lo -j RETURN

# Allow traffic to mitmproxy itself
iptables -t nat -I OUTPUT -d $MITMPROXY_IP -j RETURN

# Set up masquerading for outgoing traffic
iptables -t nat -A POSTROUTING -j MASQUERADE

echo "Transparent proxy setup complete"