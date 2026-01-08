#!/bin/bash
# LUXBIN Ethereum Blockchain Explorer Launcher

echo "🚀 Starting LUXBIN Ethereum Blockchain Explorer..."
echo ""

# Kill any existing processes on port 5001
lsof -ti:5001 | xargs kill -9 2>/dev/null

cd /Users/nicholechristie/LUXBIN_Project/luxbin-chain/python-implementation

# Check if flask and web3 are installed
pip3 install -q flask web3 requests 2>/dev/null

# Start the explorer
python3 blockchain_explorer.py &

# Wait a moment for server to start
sleep 3

# Open in browser
python3 -c "import webbrowser; webbrowser.open('http://localhost:5001')"

echo ""
echo "✅ Ethereum Explorer opened in browser!"
echo "   🌐 URL: http://localhost:5001"
echo ""
echo "Press Ctrl+C in this terminal to stop the explorer"
echo ""

wait
