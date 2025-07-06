#!/bin/bash

# WireGuard + mitmweb transparent proxy test
echo "=== WireGuard + mitmweb Transparent Proxy Test ==="

cd .devcontainer

# Function to run a test step
run_step() {
    local step_name="$1"
    local step_description="$2"
    echo -e "\n=== STEP: $step_name ==="
    echo "$step_description"
    echo "Press Enter to continue or Ctrl+C to abort..."
    read -r
}

# Step 1: Start containers and verify mitmweb
run_step "1" "Starting containers and verifying mitmweb WireGuard mode"

echo "Building and starting containers..."
docker compose build --no-cache
docker compose up -d

echo "Waiting for mitmweb to start..."
sleep 10

echo "Checking if mitmweb is running..."
docker compose logs mitmweb | tail -10

echo "Checking if WireGuard port is listening..."
docker compose exec -T mitmweb netstat -ulnp | grep 51820 || echo "WireGuard port not found"

# Step 2: Get WireGuard config
run_step "2" "Getting WireGuard configuration from mitmproxy"

echo "Getting WireGuard config from mitmproxy container..."
docker compose exec -T mitmweb cat /home/mitmproxy/.mitmproxy/wireguard.conf || echo "Config file not found"

# Step 3: Set up WireGuard client in main container
run_step "3" "Setting up WireGuard client in main container"

echo "Getting mitmweb container IP..."
MITMWEB_IP=$(docker compose exec -T mitmweb hostname -i | tr -d '\r')
echo "Mitmweb IP: $MITMWEB_IP"

echo "Extracting WireGuard server public key from mitmproxy..."
SERVER_PUBLIC_KEY=$(docker compose exec -T mitmweb python3 -c "import json; f=open('/home/mitmproxy/.mitmproxy/wireguard.conf','r'); print(json.load(f)['server_key'])" 2>/dev/null || echo "")
echo "Server Public Key: $SERVER_PUBLIC_KEY"

echo "Setting up WireGuard client configuration..."
docker compose exec -T main bash -c "
    mkdir -p /etc/wireguard
    
    # Generate client keys
    CLIENT_PRIVATE_KEY=\$(wg genkey)
    CLIENT_PUBLIC_KEY=\$(echo \$CLIENT_PRIVATE_KEY | wg pubkey)
    
    cat > /etc/wireguard/wg0.conf << EOF
[Interface]
PrivateKey = \$CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = ${MITMWEB_IP}:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
    echo 'WireGuard config created:'
    cat /etc/wireguard/wg0.conf
"

# Step 4: Test WireGuard connection
run_step "4" "Testing WireGuard connection"

echo "Starting WireGuard interface..."
docker compose exec -T main bash -c "
    wg-quick up wg0 || echo 'WireGuard failed to start'
    wg show || echo 'No WireGuard interfaces'
    ip route show || echo 'Failed to show routes'
"

# Step 5: Test HTTP traffic through WireGuard
run_step "5" "Testing HTTP traffic through WireGuard proxy"

echo "Testing HTTP request through WireGuard..."
docker compose exec -T main bash -c "
    echo 'Testing connectivity...'
    ping -c 2 8.8.8.8 || echo 'Ping failed'
    
    echo 'Testing HTTP request...'
    curl -v --connect-timeout 10 --max-time 15 http://httpbin.org/get || echo 'HTTP request failed'
"

echo "Checking mitmweb logs for intercepted traffic..."
docker compose logs mitmweb | tail -20

# Step 6: Check mitmweb interface
run_step "6" "Checking mitmweb interface"

echo "mitmweb should be accessible at http://localhost:8081"
echo "Check if you can see the web interface and any captured flows"

# Cleanup
echo -e "\n=== CLEANUP ==="
echo "Stopping WireGuard..."
docker compose exec -T main wg-quick down wg0 2>/dev/null || true

echo "Stopping containers..."
docker compose down

echo "Test complete!"