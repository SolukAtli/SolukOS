#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "System Information"

VERSION=$(cat ~/.solukos/version 2>/dev/null)
echo "Version : $VERSION"
echo "Shell   : $SHELL"
echo "User    : $(id -un)"
echo "Install : $BASE_DIR"
