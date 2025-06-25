#!/bin/bash

set -e

# Install client-gen dependencies directly without editable install
uv pip install "openapi-generator-cli>=7.4.0"

# Make sure the scripts are executable
chmod +x scripts/generate_clients.sh

# Generate clients
python scripts/generate_clients.py

echo "Build completed successfully!"
