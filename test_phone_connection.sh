#!/bin/bash

echo "🔍 Testing Phone Connection to Quantum Internet..."
echo ""

# Get local IP
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

echo "Your Mac's IP: $LOCAL_IP"
echo ""

# Check if server is running
if lsof -Pi :8765 -sTCP:LISTEN -t >/dev/null ; then
    echo "✅ Quantum WiFi server is running on port 8765"
else
    echo "❌ Server is NOT running!"
    exit 1
fi

echo ""
echo "Testing from Mac itself..."
if curl -s http://localhost:8765/status > /dev/null; then
    echo "✅ Localhost works"
else
    echo "❌ Localhost failed"
fi

echo ""
echo "Testing from network IP..."
if curl -s "http://$LOCAL_IP:8765/status" > /dev/null; then
    echo "✅ Network IP works"
else
    echo "❌ Network IP failed - FIREWALL BLOCKING"
fi

echo ""
echo "📱 For your phone, make sure:"
echo "   1. Phone is on the SAME WiFi network"
echo "   2. Phone is NOT using cellular data"
echo "   3. Try: http://$LOCAL_IP:8765"
echo ""
echo "🌐 Alternative: Use a tunnel (bypasses firewall):"
echo "   Install ngrok: brew install ngrok"
echo "   Run: ngrok http 8765"
echo "   Use the ngrok URL on your phone"
