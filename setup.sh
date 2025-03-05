#!/bin/bash

echo "Creating necessary directories..."
mkdir -p logs/caddy

echo "Checking for existing Visual DB container..."
if [ "$(docker ps -q -f name=visualdb)" ]; then
    echo "Stopping existing Visual DB container..."
    docker stop visualdb
    docker rm visualdb
fi

echo "Starting Visual DB with Caddy SSL termination..."
docker-compose up -d

echo ""
echo "Services started. Status:"
docker-compose ps

echo ""
echo "Access your Visual DB instance at: https://visualdb.local"
echo "NOTE: You may need to add 'visualdb.local' to your hosts file pointing to 127.0.0.1"
echo "e.g., Add this line to /etc/hosts (requires sudo access):"
echo "127.0.0.1 visualdb.local"
echo ""
echo "To edit your hosts file on macOS:"
echo "1. Open Terminal"
echo "2. Run: sudo nano /etc/hosts"
echo "3. Add the line: 127.0.0.1 visualdb.local"
echo "4. Press Ctrl+O then Enter to save, and Ctrl+X to exit"
