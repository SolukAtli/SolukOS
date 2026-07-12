#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"

source "$BASE_DIR/scripts/lib/ui.sh"

clear

while true
do
    soluk_header "SolukOS Tools"

    choice=$(soluk_menu "Tools" "System Info" "Storage Info" "Network Info" "Termux Info" "Exit")

    case "$choice" in

    "System Info")
        clear
        soluk_header "System Info"
        uname -a
        ;;

    "Storage Info")
        clear
        soluk_header "Storage Info"
        df -h "$HOME"
        ;;

    "Network Info")
        clear
        soluk_header "Network Info"
        ip addr
        ;;

    "Termux Info")
        clear
        soluk_header "Termux Info"
        termux-info
        ;;

    "Exit"|"")
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter..."
    clear

done
