#!/data/data/com.termux/files/usr/bin/bash

SOLUK_DIR="$HOME/.solukos"
THEME_FILE="$SOLUK_DIR/theme"

mkdir -p "$SOLUK_DIR"

echo "[+] Applying SolukOS theme..."

if [ ! -f "$THEME_FILE" ]; then
    echo "default" > "$THEME_FILE"
fi

THEME=$(cat "$THEME_FILE")

echo "[+] Theme set to: $THEME"
