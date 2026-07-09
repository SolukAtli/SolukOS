#!/data/data/com.termux/files/usr/bin/bash

TERMUX_DIR="$HOME/.termux"

mkdir -p "$TERMUX_DIR"

echo "=============================="
echo "      SolukOS Theme"
echo "=============================="
echo ""

cat > "$TERMUX_DIR/colors.properties" << EOF
background=#202020
foreground=#d0d0d0
cursor=#aaaaaa
EOF

cat > "$TERMUX_DIR/termux.properties" << EOF
bell-character=ignore
EOF

echo "[✓] Dark gray theme applied."
echo "[!] Restart Termux to apply changes."
