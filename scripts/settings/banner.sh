#!/data/data/com.termux/files/usr/bin/bash

BANNER_FILE="$HOME/.solukos/banner.txt"

clear

echo "=============================="
echo "       Change Banner"
echo "=============================="
echo ""

echo "Current banner:"
echo "----------------"

if [ -f "$BANNER_FILE" ]; then
    cat "$BANNER_FILE"
else
    echo "No banner found."
fi

echo ""
echo "----------------"
echo "Enter new banner."
echo "Finish with CTRL+D"
echo ""

cat > "$BANNER_FILE"

echo ""
echo "[+] Banner updated."

