#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

clear

echo "=============================="
echo "       System Information"
echo "=============================="
echo ""

VERSION=$(cat ~/.solukos/version 2>/dev/null)
echo "Version : $VERSION"
echo "Shell   : $SHELL"
echo "User    : $(id -un)"
echo "Install : $BASE_DIR"
