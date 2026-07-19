#!/usr/bin/env bash

BASE_DIR="$1"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "About"

VERSION=$(cat ~/.solukos/version 2>/dev/null)
[ -z "$VERSION" ] && VERSION=$(cat "$BASE_DIR/VERSION" 2>/dev/null)

soluk_row "Name"    "SolukOS"
soluk_row "Focus"   "Privacy-focused"
soluk_row "Style"   "Learning-friendly"
soluk_row "License" "Open source"
soluk_row "Version" "v$VERSION"
echo ""
