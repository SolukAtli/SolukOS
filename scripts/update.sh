#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

clear

echo "=============================="
echo "      Updating SolukOS"
echo "=============================="
echo ""

if [ -z "$BASE_DIR" ]; then
    echo "[!] SolukOS path not found."
    exit 1
fi

cd "$BASE_DIR" || exit 1

echo "[*] Checking updates..."

git pull

echo ""
echo "[+] Update process completed."
