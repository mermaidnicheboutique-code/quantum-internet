#!/bin/bash

echo "🚀 LUXBIN FULLY AUTOMATED DEPLOYMENT"
echo "===================================="

# Check if required environment variables are set
if [ -z "$PRIVATE_KEY" ]; then
    echo "❌ Error: PRIVATE_KEY environment variable not set"
    echo "Run: export PRIVATE_KEY=your_private_key_without_0x"
    exit 1
fi

if [ -z "$NETWORK" ]; then
    echo "📋 Using default network: optimisticSepolia"
    export NETWORK="optimisticSepolia"
fi

if [ -z "$ETHERSCAN_API_KEY" ]; then
    echo "⚠️  ETHERSCAN_API_KEY not set - verification will be skipped"
fi

echo "🌐 Network: $NETWORK"
echo "🔑 Private Key: ${PRIVATE_KEY:0:10}...${PRIVATE_KEY: -10}"
echo ""

# Run the automated deployment
echo "🤖 Starting automated deployment..."
npx hardhat run scripts/FullAutoDeploy.js --network $NETWORK

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 DEPLOYMENT SUCCESSFUL!"
    echo "📄 Check deployment.json for contract addresses"
    echo "🌐 Your Luxbin ecosystem is now live!"
else
    echo ""
    echo "❌ DEPLOYMENT FAILED"
    echo "Check the error messages above"
    exit 1
fi