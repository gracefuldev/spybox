FROM ubuntu:22.04

# Install WireGuard and basic tools
RUN apt-get update && apt-get install -y \
    curl \
    wireguard-tools \
    iproute2 \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*