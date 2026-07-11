#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "About"

VERSION=$(cat ~/.solukos/version 2>/dev/null)

echo "SolukOS"
echo "Privacy-focused"
echo "Learning-friendly"
echo "Open source"
echo "Version: $VERSION"
