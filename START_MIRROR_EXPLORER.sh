#!/bin/bash
# LUXBIN Mirror Explorer with Live Data

echo "🔮 Starting LUXBIN Mirror Explorer (Live Data)..."
echo ""

# Check if mirror is running
if ! pgrep -f "hermetic_mirror_live.sh" > /dev/null; then
    echo "⚠️  WARNING: Live mirror is not running!"
    echo ""
    echo "The explorer will show live data from the blockchain mirror."
    echo "Please start the mirror first:"
    echo ""
    echo "  ./START_LIVE_MIRROR.sh"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Kill any existing processes on port 8002
lsof -ti:8002 | xargs kill -9 2>/dev/null

cd /Users/nicholechristie/LUXBIN_Project/luxbin-chain/python-implementation

# Check if fastapi and uvicorn are installed
pip3 install -q fastapi uvicorn 2>/dev/null

# Start the explorer
python3 mirror_explorer_integration.py &

# Wait a moment for server to start
sleep 3

# Open in browser
python3 -c "import webbrowser; webbrowser.open('http://localhost:8002')"

echo ""
echo "✅ LUXBIN Mirror Explorer opened in browser!"
echo "   🌐 URL: http://localhost:8002"
echo "   📚 API Docs: http://localhost:8002/docs"
echo ""
echo "This explorer shows LIVE data from:"
echo "   📡 Blockchain mirror: ./luxbin_mirror/"
echo "   ⛓️  Default chain: optimism"
echo ""
echo "Press Ctrl+C in this terminal to stop the explorer"
echo ""

wait
