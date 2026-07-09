#!/data/data/com.termux/files/usr/bin/bash

while true
do
    clear

    echo "=============================="
    echo "   SolukOS Security Toolkit"
    echo "=============================="
    echo ""

    echo "[1] Check Tools"
    echo "[2] Network Information"
    echo "[3] System Information"
    echo "[4] Installed Packages"
    echo "[5] Back"
    echo ""

    read -p "Choice: " choice

    case $choice in

    1)
        echo ""
        echo "Checking tools..."
        echo ""

        for TOOL in nmap curl openssl netcat
        do
            if command -v $TOOL >/dev/null 2>&1
            then
                echo "[✓] $TOOL installed"
            else
                echo "[ ] $TOOL missing"
            fi
        done
        ;;

    2)
        echo ""
        echo "Network Information:"
        ip addr
        ;;

    3)
        echo ""
        uname -a
        ;;

    4)
        echo ""
        pkg list-installed
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

done
