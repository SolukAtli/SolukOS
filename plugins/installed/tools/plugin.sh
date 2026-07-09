#!/data/data/com.termux/files/usr/bin/bash

clear

while true
do
    echo "=============================="
    echo "       SolukOS Tools"
    echo "=============================="
    echo ""

    echo "[1] System Info"
    echo "[2] Storage Info"
    echo "[3] Network Info"
    echo "[4] Termux Info"
    echo "[5] Exit"
    echo ""

    read -p "Choice: " choice

    case $choice in

    1)
        uname -a
        ;;

    2)
        df -h "$HOME"
        ;;

    3)
        ip addr
        ;;

    4)
        termux-info
        ;;

    5)
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
