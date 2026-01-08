#!/usr/bin/env bash
set -euo pipefail

# ===============================
# LUXBIN Live Mirror System
# Starts both Hermetic mirror and immune integration
# ===============================

CHAIN="${1:-optimism}"
MODE="${2:-continuous}"

echo "✨════════════════════════════════════════════════════════════✨"
echo "║                                                            ║"
echo "║       LUXBIN LIVE MIRROR SYSTEM                           ║"
echo "║       Hermetic blockchain mirroring + Immune response     ║"
echo "║                                                            ║"
echo "✨════════════════════════════════════════════════════════════✨"
echo ""
echo "Chain: $CHAIN"
echo "Mode: $MODE"
echo ""
echo "Starting components..."
echo ""

# Make scripts executable
chmod +x hermetic_mirror_live.sh
chmod +x python-implementation/mirror_immune_integration.py

# Start Hermetic mirror in background
echo "[1/2] Starting Hermetic mirror..."
./hermetic_mirror_live.sh "$CHAIN" "$MODE" &
MIRROR_PID=$!
echo "   ✓ Hermetic mirror running (PID: $MIRROR_PID)"

# Wait for mirror to create initial data
sleep 3

# Start immune integration
echo "[2/2] Starting immune integration..."
cd python-implementation
python3 mirror_immune_integration.py --chain "$CHAIN" --interval 2 &
IMMUNE_PID=$!
cd ..
echo "   ✓ Immune integration running (PID: $IMMUNE_PID)"

echo ""
echo "✨════════════════════════════════════════════════════════════✨"
echo "║                                                            ║"
echo "║  LUXBIN LIVE MIRROR ACTIVE                                ║"
echo "║                                                            ║"
echo "║  Hermetic mirror PID: $MIRROR_PID"
echo "║  Immune system PID: $IMMUNE_PID"
echo "║                                                            ║"
echo "║  Press Ctrl+C to stop both processes                      ║"
echo "║                                                            ║"
echo "✨════════════════════════════════════════════════════════════✨"
echo ""

# Trap Ctrl+C to kill both processes
trap "echo ''; echo 'Stopping LUXBIN...'; kill $MIRROR_PID $IMMUNE_PID 2>/dev/null; exit" INT TERM

# Wait for both processes
wait
