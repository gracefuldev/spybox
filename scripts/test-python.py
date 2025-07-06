#!/usr/bin/env python3

import requests
import json

print("Testing HTTP requests with Python...")

print("=== HTTP Request ===")
try:
    response = requests.get('http://httpbin.org/get')
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text[:200]}...")
except Exception as e:
    print(f"Error: {e}")

print("\n=== HTTPS Request ===")
try:
    response = requests.get('https://httpbin.org/get')
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text[:200]}...")
except Exception as e:
    print(f"Error: {e}")

print("\n=== POST Request ===")
try:
    data = {"test": "data", "python": True}
    response = requests.post('https://httpbin.org/post', json=data)
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text[:200]}...")
except Exception as e:
    print(f"Error: {e}")