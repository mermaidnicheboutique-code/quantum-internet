#!/bin/bash

echo "🔓 FIXING FIREWALL FOR PHONE ACCESS..."
echo ""

# Get Python path
PYTHON_PATH=$(which python3)
echo "Python location: $PYTHON_PATH"
echo ""

echo "This will ask for your password..."
echo ""

# Allow Python through firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$PYTHON_PATH"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp "$PYTHON_PATH"

echo ""
echo "✅ Python allowed through firewall!"
echo ""

# Restart quantum server
echo "Restarting quantum server..."
pkill -f quantum_wifi_simple
sleep 2
python3 quantum_wifi_simple.py > /tmp/quantum_wifi.log 2>&1 &

sleep 3

echo ""
echo "✅ DONE! Server restarted."
echo ""
echo "📱 NOW TRY ON YOUR PHONE:"
echo ""
echo "   http://192.168.40.165:8765"
echo ""
echo "Or:"
echo "   http://Nicholes-MacBook-Pro.local:8765"
echo ""
