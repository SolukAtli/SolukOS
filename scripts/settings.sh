#!/usr/bin/env bash

BASE_DIR="$1"

source "$BASE_DIR/scripts/lib/ui.sh"

while true
do
    clear
    soluk_header "SolukOS Settings"

    choice=$(soluk_menu "Settings" \
        "Theme Manager" \
        "Change Banner" \
        "Reset Config" \
        "Back")

    case "$choice" in

    "Theme Manager")
        bash "$BASE_DIR/scripts/settings/theme.sh" "$BASE_DIR"
        ;;

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
