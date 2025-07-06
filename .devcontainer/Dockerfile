FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    ca-certificates \
    iptables \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    ruby \
    ruby-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python requests library
RUN pip3 install requests

# Install Ruby HTTP gem
RUN gem install httparty

# Create scripts directory
RUN mkdir -p /workspace/scripts

# Create a script to set up transparent proxy
COPY setup-transparent-proxy.sh /usr/local/bin/setup-transparent-proxy.sh
RUN chmod +x /usr/local/bin/setup-transparent-proxy.sh

# Create a script to install mitmproxy certificates
COPY install-mitm-certs.sh /usr/local/bin/install-mitm-certs.sh
RUN chmod +x /usr/local/bin/install-mitm-certs.sh

# Create entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set up the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sleep", "infinity"]