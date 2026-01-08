#!/bin/bash
# LUXBIN Native Blockchain Explorer Launcher

echo "🚀 Starting LUXBIN Native Blockchain Explorer..."
echo ""

# Kill any existing processes on port 8000
lsof -ti:8000 | xargs kill -9 2>/dev/null

cd /Users/nicholechristie/LUXBIN_Project/luxbin-chain/python-implementation

# Check if fastapi and uvicorn are installed
pip3 install -q fastapi uvicorn 2>/dev/null

# Start the explorer
python3 luxbin_native_explorer.py &

# Wait a moment for server to start
sleep 3

# Open in browser
python3 -c "import webbrowser; webbrowser.open('http://localhost:8000')"

echo ""
echo "✅ LUXBIN Native Explorer opened in browser!"
echo "   🌐 URL: http://localhost:8000"
echo "   📚 API Docs: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C in this terminal to stop the explorer"
echo ""

wait
