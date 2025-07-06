#!/bin/bash

echo "Testing HTTP requests with curl..."

echo "=== HTTP Request ==="
curl -v http://httpbin.org/get

echo -e "\n=== HTTPS Request ==="
curl -v https://httpbin.org/get

echo -e "\n=== POST Request ==="
curl -v -X POST -H "Content-Type: application/json" -d '{"test": "data"}' https://httpbin.org/post