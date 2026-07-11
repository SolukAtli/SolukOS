#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

source "$BASE_DIR/scripts/lib/ui.sh"

while true
do
    clear
    soluk_header "SolukOS Settings"

    choice=$(soluk_menu "Settings" \
        "Change Banner" \
        "Reset Config" \
        "Back")

    case "$choice" in

    "Change Banner")
        bash "$BASE_DIR/scripts/settings/banner.sh" "$BASE_DIR"
        ;;

    "Reset Config")
        bash "$BASE_DIR/scripts/settings/reset.sh" "$BASE_DIR"
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
