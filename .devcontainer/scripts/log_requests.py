#!/usr/bin/env python3

import logging
import os
from mitmproxy import http
from datetime import datetime

# Set up logging to file
log_dir = '/var/log/mitmproxy'
os.makedirs(log_dir, exist_ok=True)

# Try to create log file with appropriate permissions
try:
    log_file = f'{log_dir}/requests.log'
    with open(log_file, 'a') as f:
        pass  # Just create the file
    os.chmod(log_file, 0o666)
except (PermissionError, OSError):
    # Fall back to home directory if /var/log is not writable
    log_dir = '/home/mitmproxy'
    os.makedirs(log_dir, exist_ok=True)
    log_file = f'{log_dir}/requests.log'

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(message)s',
    handlers=[
        logging.FileHandler(log_file),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

def request(flow: http.HTTPFlow) -> None:
    """Log HTTP requests"""
    timestamp = datetime.now().isoformat()
    
    log_entry = {
        'timestamp': timestamp,
        'method': flow.request.method,
        'url': flow.request.pretty_url,
        'headers': dict(flow.request.headers),
        'content_length': len(flow.request.content) if flow.request.content else 0
    }
    
    if flow.request.content:
        try:
            content_str = flow.request.content.decode('utf-8')
            if len(content_str) > 1000:
                content_str = content_str[:1000] + '...'
            log_entry['content'] = content_str
        except UnicodeDecodeError:
            log_entry['content'] = f'<binary data: {len(flow.request.content)} bytes>'
    
    logger.info(f"REQUEST: {log_entry}")

def response(flow: http.HTTPFlow) -> None:
    """Log HTTP responses"""
    timestamp = datetime.now().isoformat()
    
    log_entry = {
        'timestamp': timestamp,
        'method': flow.request.method,
        'url': flow.request.pretty_url,
        'status_code': flow.response.status_code,
        'response_headers': dict(flow.response.headers),
        'content_length': len(flow.response.content) if flow.response.content else 0
    }
    
    logger.info(f"RESPONSE: {log_entry}")