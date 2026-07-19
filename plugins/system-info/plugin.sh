#!/usr/bin/env bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "SolukOS System Plugin"

soluk_row "User"  "$(whoami)"
soluk_row "Shell" "$SHELL"
soluk_row "Home"  "$HOME"
echo ""

echo -e "${SOLUK_BOLD}${SOLUK_CYAN}Storage${SOLUK_RESET}"
df -h "$HOME"
