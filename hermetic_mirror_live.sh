#!/usr/bin/env bash
set -euo pipefail

# ===============================
# LUXBIN Hermetic Mirror System
# Live Blockchain Mirroring with 7 Hermetic Principles
# ===============================

# Config
SOURCE_CHAIN="${1:-optimism}"
MIRROR_ROOT="./luxbin_mirror"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BLOCK_HEIGHT_FILE="$MIRROR_ROOT/$SOURCE_CHAIN/last_block.txt"
MIRROR_MODE="${2:-single}" # single or continuous

# RPC endpoints
declare -A RPC_ENDPOINTS=(
    ["optimism"]="https://mainnet.optimism.io"
    ["ethereum"]="https://eth.llamarpc.com"
    ["arbitrum"]="https://arb1.arbitrum.io/rpc"
    ["polygon"]="https://polygon-rpc.com"
    ["base"]="https://mainnet.base.org"
)

RPC_URL="${RPC_ENDPOINTS[$SOURCE_CHAIN]:-https://mainnet.optimism.io}"

mkdir -p "$MIRROR_ROOT/$SOURCE_CHAIN"/{raw,normalized,hashed,logs,quantum,immune}

echo "✨════════════════════════════════════════════════════════════✨"
echo "║                                                            ║"
echo "║       LUXBIN HERMETIC MIRROR - LIVE SYNC                  ║"
echo "║       As above, so below. As within, so without.          ║"
echo "║                                                            ║"
echo "✨════════════════════════════════════════════════════════════✨"
echo ""
echo "[LUXBIN] Hermetic Mirror Init"
echo "[TIME]   $TIMESTAMP"
echo "[CHAIN]  $SOURCE_CHAIN"
echo "[MODE]   $MIRROR_MODE"
echo "[RPC]    $RPC_URL"
echo ""

# -------------------------------
# Helper Functions
# -------------------------------

log() {
    echo "[$(date -u +"%H:%M:%S")] $1"
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $1" >> "$MIRROR_ROOT/$SOURCE_CHAIN/logs/mirror.log"
}

calculate_frequency() {
    local tx_count=$1
    # Map tx count to Hermetic frequency (432-852 Hz range)
    # More txs = higher frequency (more vibration)
    local base_freq=432
    local freq=$(echo "$base_freq + ($tx_count * 2)" | bc -l)
    # Cap at 852 Hz
    if (( $(echo "$freq > 852" | bc -l) )); then
        freq=852
    fi
    echo "$freq"
}

quantum_scan() {
    local block_file=$1
    local threat_score=0

    # Simple threat heuristics (will integrate with Python quantum scanner)
    local tx_count=$(jq '.tx_count' "$block_file")
    local gas_used=$(jq -r '.gas_used' "$block_file" | sed 's/^0x//' | echo "ibase=16; $(cat)" | bc)

    # High gas usage = potential attack
    if (( gas_used > 15000000 )); then
        threat_score=$((threat_score + 30))
    fi

    # Very high tx count = potential spam
    if (( tx_count > 200 )); then
        threat_score=$((threat_score + 20))
    fi

    echo "$threat_score"
}

spawn_immune_cells() {
    local threat_score=$1
    local block_num=$2

    # Determine cell type based on threat
    if (( threat_score > 50 )); then
        cell_type="DEFENDER"
        count=3
    elif (( threat_score > 30 )); then
        cell_type="DETECTOR"
        count=2
    else
        cell_type="MEMORY"
        count=1
    fi

    log "🦠 Spawning $count $cell_type cells for block $block_num (threat: $threat_score)"

    echo "{\"block\": \"$block_num\", \"cell_type\": \"$cell_type\", \"count\": $count, \"threat_score\": $threat_score, \"timestamp\": \"$TIMESTAMP\"}" \
        >> "$MIRROR_ROOT/$SOURCE_CHAIN/immune/cells_spawned.jsonl"
}

# -------------------------------
# Mirror Single Block
# -------------------------------
mirror_block() {
    local block_to_fetch=$1

    log "⚡ [1/7] MENTALISM: Capturing external state"

    # Fetch block data
    if ! curl -s "$RPC_URL" \
      -H "Content-Type: application/json" \
      -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBlockByNumber\",\"params\":[\"$block_to_fetch\",true],\"id\":1}" \
      > "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_to_fetch.json"; then
        log "❌ Failed to fetch block $block_to_fetch"
        return 1
    fi

    # Check if block exists
    if ! jq -e '.result' "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_to_fetch.json" > /dev/null; then
        log "⚠️  Block $block_to_fetch not yet available"
        return 1
    fi

    log "✓ Block $block_to_fetch captured"

    # -------------------------------
    # 2. Correspondence — Normalize
    # -------------------------------
    log "⚡ [2/7] CORRESPONDENCE: Normalizing to fractal pattern"

    jq '{
      block: .result.number,
      timestamp: .result.timestamp,
      tx_count: (.result.transactions | length),
      gas_used: .result.gasUsed,
      gas_limit: .result.gasLimit,
      miner: .result.miner,
      difficulty: .result.difficulty,
      hash: .result.hash,
      parent_hash: .result.parentHash,
      size: .result.size,
      base_fee: .result.baseFeePerGas
    }' "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_to_fetch.json" \
    > "$MIRROR_ROOT/$SOURCE_CHAIN/normalized/block_$block_to_fetch.norm.json"

    log "✓ State normalized (as above, so below)"

    # -------------------------------
    # 3. Vibration — Temporal Signal
    # -------------------------------
    log "⚡ [3/7] VIBRATION: Measuring frequency"

    local tx_count=$(jq '.tx_count' "$MIRROR_ROOT/$SOURCE_CHAIN/normalized/block_$block_to_fetch.norm.json")
    local frequency=$(calculate_frequency "$tx_count")

    echo "{\"block\": \"$block_to_fetch\", \"tx_count\": $tx_count, \"frequency_hz\": $frequency, \"timestamp\": \"$TIMESTAMP\"}" \
        >> "$MIRROR_ROOT/$SOURCE_CHAIN/logs/vibration.jsonl"

    log "✓ Frequency: $frequency Hz (tx: $tx_count)"

    # -------------------------------
    # 4. Polarity — Dual Encoding
    # -------------------------------
    log "⚡ [4/7] POLARITY: Creating dual representations"

    # Raw hash (chaos/unprocessed)
    sha256sum "$MIRROR_ROOT/$SOURCE_CHAIN/raw/block_$block_to_fetch.json" | awk '{print $1}' \
    > "$MIRROR_ROOT/$SOURCE_CHAIN/hashed/block_$block_to_fetch.raw.sha"

    # Normalized hash (order/processed)
    sha256sum "$MIRROR_ROOT/$SOURCE_CHAIN/normalized/block_$block_to_fetch.norm.json" | awk '{print $1}' \
    > "$MIRROR_ROOT/$SOURCE_CHAIN/hashed/block_$block_to_fetch.norm.sha"

    local raw_hash=$(cat "$MIRROR_ROOT/$SOURCE_CHAIN/hashed/block_$block_to_fetch.raw.sha")
    local norm_hash=$(cat "$MIRROR_ROOT/$SOURCE_CHAIN/hashed/block_$block_to_fetch.norm.sha")

    log "✓ Polarity established (raw: ${raw_hash:0:8}... | norm: ${norm_hash:0:8}...)"

    # -------------------------------
    # 5. Rhythm — Drift Detection
    # -------------------------------
    log "⚡ [5/7] RHYTHM: Analyzing temporal flow"

    if [ -f "$BLOCK_HEIGHT_FILE" ]; then
        local last_block=$(cat "$BLOCK_HEIGHT_FILE")
        local last_timestamp=$(jq -r '.timestamp' "$MIRROR_ROOT/$SOURCE_CHAIN/normalized/block_$last_block.norm.json" 2>/dev/null || echo "0x0")
        local current_timestamp=$(jq -r '.timestamp' "$MIRROR_ROOT/$SOURCE_CHAIN/normalized/block_$block_to_fetch.norm.json")

        # Convert hex to decimal
        last_timestamp=$(printf "%d" "$last_timestamp")
        current_timestamp=$(printf "%d" "$current_timestamp")

        if (( last_timestamp > 0 )); then
            local block_time=$((current_timestamp - last_timestamp))
            echo "{\"from_block\": \"$last_block\", \"to_block\": \"$block_to_fetch\", \"block_time\": $block_time, \"timestamp\": \"$TIMESTAMP\"}" \
                >> "$MIRROR_ROOT/$SOURCE_CHAIN/logs/rhythm.jsonl"
            log "✓ Block time: ${block_time}s (rhythm maintained)"
        fi
    fi

    # -------------------------------
    # 6. Cause & Effect — Quantum Scan
    # -------------------------------
    log "⚡ [6/7] CAUSE & EFFECT: Quantum threat analysis"

    local threat_score=$(quantum_scan "$MIRROR_ROOT/$SOURCE_CHAIN/normalized/block_$block_to_fetch.norm.json")

    echo "{\"block\": \"$block_to_fetch\", \"threat_score\": $threat_score, \"timestamp\": \"$TIMESTAMP\"}" \
        >> "$MIRROR_ROOT/$SOURCE_CHAIN/quantum/threat_scores.jsonl"

    if (( threat_score > 50 )); then
        log "⚠️  HIGH THREAT detected: $threat_score/100"
    else
        log "✓ Threat score: $threat_score/100 (normal)"
    fi

    # -------------------------------
    # 7. Gender — Cell Spawning
    # -------------------------------
    log "⚡ [7/7] GENDER: Active/Receptive immune response"

    spawn_immune_cells "$threat_score" "$block_to_fetch"

    # Update generative/regulatory flags
    if (( threat_score > 30 )); then
        echo "GENERATIVE_ACTIVE" > "$MIRROR_ROOT/$SOURCE_CHAIN/logs/generative.flag"
        echo "REGULATORY_ACTIVE" > "$MIRROR_ROOT/$SOURCE_CHAIN/logs/regulatory.flag"
        log "✓ Both active/receptive forces engaged"
    else
        echo "GENERATIVE_OK" > "$MIRROR_ROOT/$SOURCE_CHAIN/logs/generative.flag"
        echo "REGULATORY_IDLE" > "$MIRROR_ROOT/$SOURCE_CHAIN/logs/regulatory.flag"
        log "✓ Receptive force dormant (peaceful)"
    fi

    # Replay index
    echo "$block_to_fetch $TIMESTAMP" >> "$MIRROR_ROOT/$SOURCE_CHAIN/logs/replay_index.log"

    # Save as last processed block
    echo "$block_to_fetch" > "$BLOCK_HEIGHT_FILE"

    log "✨ Mirror complete for block $block_to_fetch"
    echo ""
}

# -------------------------------
# Main Execution
# -------------------------------

if [ "$MIRROR_MODE" = "continuous" ]; then
    log "🔄 Starting continuous mirroring (Ctrl+C to stop)"
    echo ""

    while true; do
        # Get latest block
        LATEST_BLOCK=$(curl -s "$RPC_URL" \
          -H "Content-Type: application/json" \
          -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
          | jq -r '.result')

        # Convert hex to decimal
        LATEST_BLOCK_DEC=$(printf "%d" "$LATEST_BLOCK")

        # Get last processed block
        if [ -f "$BLOCK_HEIGHT_FILE" ]; then
            LAST_PROCESSED=$(cat "$BLOCK_HEIGHT_FILE")
            LAST_PROCESSED_DEC=$(printf "%d" "$LAST_PROCESSED")
        else
            LAST_PROCESSED_DEC=$((LATEST_BLOCK_DEC - 1))
        fi

        # Mirror any new blocks
        for ((block=LAST_PROCESSED_DEC+1; block<=LATEST_BLOCK_DEC; block++)); do
            block_hex=$(printf "0x%x" "$block")
            mirror_block "$block_hex"
        done

        # Wait for next block (adjust based on chain)
        case "$SOURCE_CHAIN" in
            "optimism"|"arbitrum"|"polygon"|"base")
                sleep 2  # Fast chains
                ;;
            "ethereum")
                sleep 12  # Ethereum mainnet
                ;;
            *)
                sleep 5  # Default
                ;;
        esac
    done
else
    # Single block mode
    LATEST_BLOCK=$(curl -s "$RPC_URL" \
      -H "Content-Type: application/json" \
      -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
      | jq -r '.result')

    mirror_block "$LATEST_BLOCK"
fi

echo "✨════════════════════════════════════════════════════════════✨"
echo "So mote it be."
echo "✨════════════════════════════════════════════════════════════✨"
