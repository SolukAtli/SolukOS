#!/data/data/com.termux/files/usr/bin/bash

SOLUK_DIR="$HOME/.solukos"
THEME_FILE="$SOLUK_DIR/theme"
TERMUX_DIR="$HOME/.termux"

mkdir -p "$SOLUK_DIR"
mkdir -p "$TERMUX_DIR"

echo "[+] Applying SolukOS theme..."

if [ ! -f "$THEME_FILE" ]; then
    echo "default" > "$THEME_FILE"
fi

THEME=$(cat "$THEME_FILE")

# Muted / pale ("soluk") palette for the Termux app itself: grays and
# desaturated blue/gold tones rather than vivid neon colors.
cat > "$TERMUX_DIR/colors.properties" << 'COLORS'
background=#1c1f24
foreground=#c0c8d0
cursor=#c0c8d0

color0=#2b2f36
color1=#a56b6b
color2=#7f9f7f
color3=#bfae7f
color4=#7f9fbf
color5=#9f8fbf
color6=#7fb0af
color7=#c0c8d0
color8=#4a4f58
color9=#c58f8f
color10=#a3c2a3
color11=#d8c79a
color12=#a3c2e0
color13=#c2aee0
color14=#a3d6d4
color15=#eef1f5
COLORS

if command -v termux-reload-settings >/dev/null 2>&1
then
    termux-reload-settings
    echo "[+] Termux renkleri uygulandi."
else
    echo "[!] termux-reload-settings bulunamadi - renkler bir sonraki Termux acilisinda uygulanacak."
fi

echo "[+] Theme set to: $THEME"
