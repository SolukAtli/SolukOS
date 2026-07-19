#!/usr/bin/env bash

BASE_DIR="$1"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "System Information"

VERSION=$(cat ~/.solukos/version 2>/dev/null)
[ -z "$VERSION" ] && VERSION=$(cat "$BASE_DIR/VERSION" 2>/dev/null)

soluk_row "Version" "v$VERSION"
soluk_row "Shell"   "$SHELL"
soluk_row "User"    "$(id -un)"
soluk_row "Install" "$BASE_DIR"
echo ""
