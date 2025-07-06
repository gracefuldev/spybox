#!/usr/bin/env ruby

require 'httparty'
require 'json'

puts "Testing HTTP requests with Ruby..."

begin
  puts "=== HTTP Request ==="
  response = HTTParty.get('http://httpbin.org/get')
  puts "Status: #{response.code}"
  puts "Response: #{response.body[0..199]}..."
rescue => e
  puts "Error: #{e.message}"
end

begin
  puts "\n=== HTTPS Request ==="
  response = HTTParty.get('https://httpbin.org/get')
  puts "Status: #{response.code}"
  puts "Response: #{response.body[0..199]}..."
rescue => e
  puts "Error: #{e.message}"
end

begin
  puts "\n=== POST Request ==="
  data = {test: "data", ruby: true}
  response = HTTParty.post('https://httpbin.org/post', 
    body: data.to_json,
    headers: {'Content-Type' => 'application/json'}
  )
  puts "Status: #{response.code}"
  puts "Response: #{response.body[0..199]}..."
rescue => e
  puts "Error: #{e.message}"
end