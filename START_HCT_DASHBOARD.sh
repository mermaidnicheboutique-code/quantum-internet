#!/bin/bash
set -e

cd "$(dirname "$0")/hct-app"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║       LUXBIN HCT Dashboard                                ║"
echo "║       Harmonic Convergence Theory Monitor                 ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check dependencies
if ! python3 -c "import flask" 2>/dev/null; then
    echo "📦 Installing dependencies..."
    pip3 install -r requirements.txt
fi

echo "🚀 Starting HCT Dashboard..."
echo ""
echo "   Open browser to: http://localhost:5000"
echo ""
echo "   Press Ctrl+C to stop"
echo ""

python3 app.py
