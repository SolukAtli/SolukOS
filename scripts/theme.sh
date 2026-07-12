#!/data/data/com.termux/files/usr/bin/bash

SOLUK_DIR="$HOME/.solukos"
THEME_FILE="$SOLUK_DIR/theme"
TERMUX_DIR="$HOME/.termux"

mkdir -p "$SOLUK_DIR"
mkdir -p "$TERMUX_DIR"

echo "[+] Applying SolukOS theme..."

if [ ! -f "$THEME_FILE" ]; then
    echo "soluk" > "$THEME_FILE"
fi

THEME=$(cat "$THEME_FILE")

case "$THEME" in

matrix)
# Classic black/green hacker terminal.
cat > "$TERMUX_DIR/colors.properties" << 'COLORS'
background=#0a0e0a
foreground=#33ff66
cursor=#33ff66

color0=#0a0e0a
color1=#1f7a3f
color2=#33cc55
color3=#5ee87a
color4=#268a4a
color5=#2fb35c
color6=#39d466
color7=#a8f7bb
color8=#123018
color9=#2e9950
color10=#4de077
color11=#7bffa0
color12=#37a860
color13=#43c26f
color14=#4de88a
color15=#d8ffe4
COLORS
    ;;

nord)
# Cool blue-gray, based on the popular Nord palette.
cat > "$TERMUX_DIR/colors.properties" << 'COLORS'
background=#2e3440
foreground=#d8dee9
cursor=#d8dee9

color0=#3b4252
color1=#bf616a
color2=#a3be8c
color3=#ebcb8b
color4=#81a1c1
color5=#b48ead
color6=#88c0d0
color7=#e5e9f0
color8=#4c566a
color9=#bf616a
color10=#a3be8c
color11=#ebcb8b
color12=#81a1c1
color13=#b48ead
color14=#8fbcbb
color15=#eceff4
COLORS
    ;;

soluk|default|*)
# Muted / pale ("soluk") palette: grays and desaturated blue/gold tones.
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
    ;;

esac

if command -v termux-reload-settings >/dev/null 2>&1
then
    termux-reload-settings
    echo "[+] Termux renkleri uygulandi."
else
    echo "[!] termux-reload-settings bulunamadi - renkler bir sonraki Termux acilisinda uygulanacak."
fi

echo "[+] Theme set to: $THEME"
