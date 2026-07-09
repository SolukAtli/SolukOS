#!/data/data/com.termux/files/usr/bin/bash

LOG_DIR="$HOME/.solukos/logs"

while true
do
    clear

    echo "=============================="
    echo "        Log Manager"
    echo "=============================="
    echo ""

    echo "[1] View System Log"
    echo "[2] View Backup Log"
    echo "[3] View Update Log"
    echo "[4] View Install Log"
    echo "[5] Clear Logs"
    echo "[6] Export Logs"
    echo "[7] Back"
    echo ""

    read -p "Choice: " choice

    case $choice in

    1)
        clear
        cat "$LOG_DIR/system.log" 2>/dev/null || echo "No system logs."
        ;;

    2)
        clear
        cat "$LOG_DIR/backup.log" 2>/dev/null || echo "No backup logs."
        ;;

    3)
        clear
        cat "$LOG_DIR/update.log" 2>/dev/null || echo "No update logs."
        ;;

    4)
        clear
        cat "$LOG_DIR/install.log" 2>/dev/null || echo "No install logs."
        ;;

    5)
        rm -f "$LOG_DIR"/*.log
        echo "[+] Logs cleared."
        ;;

    6)
        mkdir -p "$HOME/.solukos/exports"

        FILE="$HOME/.solukos/exports/solukos-logs-$(date +%Y-%m-%d_%H-%M-%S).txt"

        echo "==============================" > "$FILE"
        echo "        SolukOS Logs" >> "$FILE"
        echo "==============================" >> "$FILE"
        echo "" >> "$FILE"

        for LOG in "$LOG_DIR"/*.log
        do
            echo "===== $(basename "$LOG") =====" >> "$FILE"
            cat "$LOG" >> "$FILE" 2>/dev/null
            echo "" >> "$FILE"
        done

        echo "[+] Logs exported:"
        echo "$FILE"
        ;;

    7)
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter to continue..."

done
