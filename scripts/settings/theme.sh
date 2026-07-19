#!/usr/bin/env bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
SOLUK_DIR="$HOME/.solukos"
THEME_FILE="$SOLUK_DIR/theme"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "Theme Manager"

CURRENT=$(cat "$THEME_FILE" 2>/dev/null)
[ -z "$CURRENT" ] && CURRENT="soluk"

soluk_row "Current" "$CURRENT"
echo ""

choice=$(soluk_menu "Theme" "Soluk (default)" "Matrix" "Nord" "Back")

case "$choice" in

"Soluk (default)") NEW="soluk" ;;
"Matrix")           NEW="matrix" ;;
"Nord")              NEW="nord" ;;
"Back"|"")
    exit 0
    ;;
*)
    echo "Invalid option."
    exit 0
    ;;

esac

mkdir -p "$SOLUK_DIR"
echo "$NEW" > "$THEME_FILE"

bash "$BASE_DIR/scripts/theme.sh"

echo ""
soluk_ok "Theme set to: $NEW"
soluk_warn "Renklerin tam yansimasi icin yeni bir Konsole penceresi/sekmesi acman gerekebilir."
