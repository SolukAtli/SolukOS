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
#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

LOG_FILE="$HOME/.solukos/logs/update.log"

mkdir -p "$(dirname "$LOG_FILE")"

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update started" >> "$LOG_FILE"

clear

echo "=============================="
echo "      Updating SolukOS"
echo "=============================="
echo ""

cd "$BASE_DIR" || exit 1

git pull

if [ $? -eq 0 ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update completed successfully" >> "$LOG_FILE"
    echo ""
    echo "[+] Update completed."
else
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update failed" >> "$LOG_FILE"
    echo ""
    echo "[!] Update failed."
fi
