#!/bin/bash

echo "🌐 Starting Quantum Internet Over WiFi..."

# Kill any old instances
pkill -f quantum_wifi 2>/dev/null

# Start the quantum WiFi bridge
cd "$(dirname "$0")"
python3 quantum_wifi_simple.py
