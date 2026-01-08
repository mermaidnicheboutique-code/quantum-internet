#!/bin/bash

echo "🌐 Starting LUXBIN Quantum Internet..."
echo ""
echo "Running on 3 IBM Quantum Computers:"
echo "  • ibm_fez (156 qubits)"
echo "  • ibm_torino (133 qubits)"
echo "  • ibm_marrakesh (156 qubits)"
echo ""
echo "Total: 445 qubits available"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed"
    exit 1
fi

# Check if required packages are installed
echo "📦 Checking dependencies..."
python3 -c "import qiskit" 2>/dev/null || {
    echo "⚠️  Qiskit not found. Installing..."
    pip3 install qiskit qiskit-ibm-runtime
}

echo ""
echo "✅ All dependencies installed"
echo ""

# Start the quantum internet service
python3 quantum_internet_service.py
