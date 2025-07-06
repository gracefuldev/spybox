#!/usr/bin/env python3

import logging
import os
from mitmproxy import http
from datetime import datetime

# Set up logging to file
log_dir = '/var/log/mitmproxy'
os.makedirs(log_dir, exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(message)s',
    handlers=[
        logging.FileHandler(f'{log_dir}/requests.log'),
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