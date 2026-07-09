#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

while true
do
    clear

    echo "=============================="
    echo "      SolukOS Settings"
    echo "=============================="
    echo ""
    echo "[1] Change Banner"
    echo "[2] Reset Config"
    echo "[3] Back"
    echo ""

    read -p "Choice: " choice

    case $choice in

    1)
        bash "$BASE_DIR/scripts/settings/banner.sh"
        ;;

    2)
        bash "$BASE_DIR/scripts/settings/reset.sh"
        ;;

    3)
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter to continue..."

done
