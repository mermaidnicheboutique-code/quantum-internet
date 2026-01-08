#!/bin/bash
# LUXBIN USDC Explorer Launcher

echo "💰 Starting LUXBIN USDC Explorer..."
echo ""

# Kill any existing processes on port 8003
lsof -ti:8003 | xargs kill -9 2>/dev/null

cd /Users/nicholechristie/LUXBIN_Project/luxbin-chain/python-implementation

# Install dependencies
pip3 install -q fastapi uvicorn web3 2>/dev/null

# Start the explorer
python3 luxbin_usdc_explorer.py &

# Wait for server to start
sleep 3

# Open in browser
python3 -c "import webbrowser; webbrowser.open('http://localhost:8003')"

echo ""
echo "✅ LUXBIN USDC Explorer opened in browser!"
echo "   🌐 URL: http://localhost:8003"
echo "   💰 Shows real USDC value for all activities"
echo ""
echo "Press Ctrl+C to stop"
echo ""

wait
