#!/bin/bash

echo "🔓 Allowing Quantum WiFi through macOS Firewall..."
echo ""

# Find Python path
PYTHON_PATH=$(which python3)

echo "Python path: $PYTHON_PATH"
echo ""

echo "Adding firewall rule..."
echo "This requires your password:"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$PYTHON_PATH"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp "$PYTHON_PATH"

echo ""
echo "✅ Done! Python is now allowed through the firewall."
echo ""
echo "📱 Now try connecting from your phone to:"
echo "   http://192.168.40.165:8765"
echo ""
echo "Or use your computer name:"
echo "   http://Nicholes-MacBook-Pro.local:8765"
