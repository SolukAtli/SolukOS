#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"
BANNER_FILE="$HOME/.solukos/banner.txt"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "Change Banner"

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
soluk_ok "Banner updated."
