#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"

source "$BASE_DIR/scripts/lib/ui.sh"

soluk_header "SolukOS System Plugin"

echo "User: $(whoami)"
echo "Shell: $SHELL"
echo "Home: $HOME"

echo ""

echo "Storage:"
df -h "$HOME"
