#!/usr/bin/env bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"

source "$BASE_DIR/scripts/lib/ui.sh"

clear

while true
do
    soluk_header "SolukOS Tools"

    choice=$(soluk_menu "Tools" "System Info" "Storage Info" "Network Info" "OS Release Info" "Exit")

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

    "OS Release Info")
        clear
        soluk_header "OS Release Info"
        cat /etc/os-release 2>/dev/null
        echo ""
        command -v hostnamectl >/dev/null 2>&1 && hostnamectl
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
