#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Applying SolukOS theme..."

mkdir -p ~/.termux

cat > ~/.termux/colors.properties << 'EOF'
background=#232323
foreground=#bdbdbd
cursor=#d0d0d0
EOF

echo "[+] Theme applied."
echo "[+] Restart Termux to see changes."
