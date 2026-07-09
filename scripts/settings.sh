#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

while true
do
    clear

    echo "=============================="
    echo "          Settings"
    echo "=============================="
    echo ""
    echo "[1] Show Install Path"
    echo "[2] Show Version"
    echo "[3] Back"
    echo ""

    read -p "Choice: " choice

    case $choice in

    1)
        clear
        echo "=============================="
        echo "       Install Path"
        echo "=============================="
        echo ""
        echo "$BASE_DIR"
        ;;

    2)
        clear
        echo "=============================="
        echo "          Version"
        echo "=============================="
        echo ""
        echo "SolukOS v0.4-dev"
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
