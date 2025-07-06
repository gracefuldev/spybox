#!/usr/bin/env node

const https = require('https');
const http = require('http');

console.log("Testing HTTP requests with JavaScript...");

function makeRequest(url, method = 'GET', data = null) {
    return new Promise((resolve, reject) => {
        const urlObj = new URL(url);
        const options = {
            hostname: urlObj.hostname,
            port: urlObj.port || (urlObj.protocol === 'https:' ? 443 : 80),
            path: urlObj.pathname + urlObj.search,
            method: method,
            headers: {
                'User-Agent': 'Node.js Test Client'
            }
        };

        if (data) {
            options.headers['Content-Type'] = 'application/json';
            options.headers['Content-Length'] = Buffer.byteLength(data);
        }

        const client = urlObj.protocol === 'https:' ? https : http;
        
        const req = client.request(options, (res) => {
            let body = '';
            res.on('data', chunk => body += chunk);
            res.on('end', () => {
                resolve({
                    status: res.statusCode,
                    body: body
                });
            });
        });

        req.on('error', reject);
        
        if (data) {
            req.write(data);
        }
        
        req.end();
    });
}

async function runTests() {
    try {
        console.log("=== HTTP Request ===");
        const httpResponse = await makeRequest('http://httpbin.org/get');
        console.log(`Status: ${httpResponse.status}`);
        console.log(`Response: ${httpResponse.body.substring(0, 200)}...`);

        console.log("\n=== HTTPS Request ===");
        const httpsResponse = await makeRequest('https://httpbin.org/get');
        console.log(`Status: ${httpsResponse.status}`);
        console.log(`Response: ${httpsResponse.body.substring(0, 200)}...`);

        console.log("\n=== POST Request ===");
        const postData = JSON.stringify({test: "data", javascript: true});
        const postResponse = await makeRequest('https://httpbin.org/post', 'POST', postData);
        console.log(`Status: ${postResponse.status}`);
        console.log(`Response: ${postResponse.body.substring(0, 200)}...`);
    } catch (error) {
        console.error(`Error: ${error.message}`);
    }
}

runTests();