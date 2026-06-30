#!/bin/bash
# Script to build and run Deutschtiger Flutter Web locally

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================================="
echo "      DeutschTiger - Local Web Build & Server"
echo "=========================================================="
echo ""

# 1. Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: 'flutter' command could not be found. Please ensure Flutter SDK is installed and in your PATH."
    exit 1
fi

# 2. Get dependencies
echo "----> 1. Fetching Flutter dependencies..."
flutter pub get

# 3. Build the web app
echo "----> 2. Building Flutter Web (Release Mode)..."
flutter build web --release

# 4. Serve the build directory
echo "----> 3. Starting local server for testing..."
echo ""
echo "=========================================================="
echo "  Success! Your app is built."
echo "  Serving http://localhost:8000"
echo "  Open http://localhost:8000 in your browser to check."
echo "  Press [Ctrl + C] to stop the server."
echo "=========================================================="
echo ""

cd build/web
python3 -m http.server 8000
