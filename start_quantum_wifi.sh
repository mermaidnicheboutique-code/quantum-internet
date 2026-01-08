#!/bin/bash

echo "📡 Starting Quantum Internet Over WiFi..."
echo ""
echo "This will:"
echo "  ✅ Use your WiFi for quantum coordination"
echo "  ✅ Connect to 3 IBM quantum computers"
echo "  ✅ Create entangled network over WiFi"
echo "  ✅ Enable quantum teleportation via WiFi"
echo ""

# Install dependencies
pip3 install aiohttp netifaces 2>/dev/null

# Start the quantum-WiFi bridge
python3 quantum_wifi_bridge.py
