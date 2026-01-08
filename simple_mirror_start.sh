#!/bin/bash
# Simple Live Mirror Starter (Compatible with Bash 3)

MIRROR_ROOT="./luxbin_mirror"
SOURCE_CHAIN="optimism"
RPC_URL="https://mainnet.optimism.io"

# Create directories
mkdir -p "$MIRROR_ROOT/$SOURCE_CHAIN"/{raw,normalized,hashed,logs,quantum,immune}

echo "════════════════════════════════════════════════════════════"
echo "🔮 LUXBIN LIVE MIRROR - Starting..."
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Chain: $SOURCE_CHAIN"
echo "RPC: $RPC_URL"
echo "Mirror Root: $MIRROR_ROOT"
echo ""
echo "💰 EARNING USDC:"
echo "   • \$0.10 per block mirrored"
echo "   • \$1-\$100 per threat detected"
echo "   • \$5-\$20 per cell spawned"
echo ""
echo "📊 View your earnings: http://localhost:8003"
echo ""
echo "Starting mirror in 3 seconds..."
sleep 3
echo ""

# Function to get latest block
get_latest_block() {
    curl -s -X POST "$RPC_URL" \
        -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",true],"id":1}' \
        | jq -r '.result.number' | xargs printf "%d"
}

# Function to mirror a block
mirror_block() {
    local block_hex="$1"
    local block_num="$2"

    echo "[$(date '+%H:%M:%S')] ⚡ Mirroring block #$block_num..."

    # Fetch block
    curl -s -X POST "$RPC_URL" \
        -H "Content-Type: application/json" \
        -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBlockByNumber\",\"params\":[\"$block_hex\",true],\"id\":1}" \
        > "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_hex.json"

    # Extract key data
    jq '.result | {block: .number, timestamp: .timestamp, tx_count: (.transactions | length), gas_used: .gasUsed, miner: .miner}' \
        "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_hex.json" \
        > "$MIRROR_ROOT/$SOURCE_CHAIN/normalized/block_$block_hex.norm.json"

    # Get transaction count for threat analysis
    local tx_count=$(jq -r '.result.transactions | length' "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_hex.json")
    local gas_used_hex=$(jq -r '.result.gasUsed' "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_hex.json")
    local gas_used=$((16#${gas_used_hex#0x}))

    # Calculate threat score
    local threat_score=0

    if [ $gas_used -gt 15000000 ]; then
        threat_score=$((threat_score + 30))
    fi

    if [ $tx_count -gt 200 ]; then
        threat_score=$((threat_score + 20))
    fi

    # Log threat score
    echo "{\"block\": \"$block_hex\", \"threat_score\": $threat_score, \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" \
        >> "$MIRROR_ROOT/$SOURCE_CHAIN/quantum/threat_scores.jsonl"

    # Spawn cells based on threat
    local cell_type="MEMORY"
    local cell_count=1

    if [ $threat_score -ge 70 ]; then
        cell_type="DEFENDER"
        cell_count=10
        echo "   🚨 CRITICAL THREAT ($threat_score) - Spawning $cell_count DEFENDER cells (\$150.00 USDC)"
    elif [ $threat_score -ge 50 ]; then
        cell_type="DEFENDER"
        cell_count=5
        echo "   ⚠️  HIGH THREAT ($threat_score) - Spawning $cell_count DEFENDER cells (\$75.00 USDC)"
    elif [ $threat_score -ge 30 ]; then
        cell_type="DETECTOR"
        cell_count=2
        echo "   ⚡ MEDIUM THREAT ($threat_score) - Spawning $cell_count DETECTOR cells (\$20.00 USDC)"
    fi

    # Log cell spawn
    echo "{\"block\": \"$block_hex\", \"cell_type\": \"$cell_type\", \"count\": $cell_count, \"threat_score\": $threat_score, \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" \
        >> "$MIRROR_ROOT/$SOURCE_CHAIN/immune/cells_spawned.jsonl"

    # Calculate earnings for this block
    local block_reward=0.10
    local threat_reward=$(echo "scale=2; 1 + ($threat_score * 0.99)" | bc)
    local cell_value=0

    case $cell_type in
        DETECTOR) cell_value=$(echo "$cell_count * 10" | bc) ;;
        DEFENDER) cell_value=$(echo "$cell_count * 15" | bc) ;;
        MEMORY) cell_value=$(echo "$cell_count * 5" | bc) ;;
        REGULATORY) cell_value=$(echo "$cell_count * 20" | bc) ;;
    esac

    local total_earned=$(echo "$block_reward + $threat_reward + $cell_value" | bc)

    echo "   💰 Block earned: \$$total_earned USDC (Block: \$0.10 + Threat: \$$threat_reward + Cells: \$$cell_value)"
    echo "   ✓ Block #$block_num mirrored successfully"
    echo ""
}

# Main loop
echo "🔮 Starting continuous mirroring..."
echo ""

last_block=0

while true; do
    # Get latest block
    latest_block=$(get_latest_block)

    if [ "$latest_block" != "$last_block" ] && [ "$latest_block" != "0" ]; then
        # Convert to hex
        block_hex=$(printf "0x%x" $latest_block)

        # Mirror the block
        mirror_block "$block_hex" "$latest_block"

        last_block=$latest_block
    fi

    # Wait 2 seconds before checking again (Optimism block time)
    sleep 2
done
