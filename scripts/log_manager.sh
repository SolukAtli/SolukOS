#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
LOG_DIR="$HOME/.solukos/logs"

source "$BASE_DIR/scripts/lib/ui.sh"

while true
do
    clear
    soluk_header "Log Manager"

    choice=$(soluk_menu "Log Manager" \
        "View System Log" \
        "View Backup Log" \
        "View Update Log" \
        "View Install Log" \
        "Clear Logs" \
        "Export Logs" \
        "Back")

    case "$choice" in

    "View System Log")
        clear
        soluk_header "System Log"
        cat "$LOG_DIR/system.log" 2>/dev/null || soluk_warn "No system logs."
        ;;

    "View Backup Log")
        clear
        soluk_header "Backup Log"
        cat "$LOG_DIR/backup.log" 2>/dev/null || soluk_warn "No backup logs."
        ;;

    "View Update Log")
        clear
        soluk_header "Update Log"
        cat "$LOG_DIR/update.log" 2>/dev/null || soluk_warn "No update logs."
        ;;

    "View Install Log")
        clear
        soluk_header "Install Log"
        cat "$LOG_DIR/install.log" 2>/dev/null || soluk_warn "No install logs."
        ;;

    "Clear Logs")
        rm -f "$LOG_DIR"/*.log
        soluk_ok "Logs cleared."
        ;;

    "Export Logs")
        mkdir -p "$HOME/.solukos/exports"

        FILE="$HOME/.solukos/exports/solukos-logs-$(date +%Y-%m-%d_%H-%M-%S).txt"

        {
            echo "=============================="
            echo "        SolukOS Logs"
            echo "=============================="
            echo ""

            for LOG in "$LOG_DIR"/*.log
            do
                echo "===== $(basename "$LOG") ====="
                cat "$LOG" 2>/dev/null
                echo ""
            done
        } > "$FILE"

        soluk_ok "Logs exported"
        soluk_row "File" "$FILE"
        ;;

    "Back"|"")
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter to continue..."

done
