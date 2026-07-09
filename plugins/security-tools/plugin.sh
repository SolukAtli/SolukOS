#!/data/data/com.termux/files/usr/bin/bash

NETWORK_TOOLS="nmap netcat traceroute"
WEB_TOOLS="sqlmap nikto curl"
INFO_TOOLS="whois dnsutils openssl"
SYSTEM_TOOLS="htop lsof procps"

ALL_TOOLS="$NETWORK_TOOLS $WEB_TOOLS $INFO_TOOLS $SYSTEM_TOOLS"

MINIMAL_TOOLS="curl openssl netcat whois"
STANDARD_TOOLS="curl openssl netcat whois nmap traceroute dnsutils htop"
FULL_TOOLS="curl openssl netcat whois nmap traceroute dnsutils htop sqlmap nikto lsof procps"


check_tools()
{
    for TOOL in $1
    do
        if command -v "$TOOL" >/dev/null 2>&1
        then
            echo "[✓] $TOOL installed"
        else
            echo "[ ] $TOOL missing"
        fi
    done
}


install_profile()
{
    for TOOL in $1
    do
        if command -v "$TOOL" >/dev/null 2>&1
        then
            echo "[✓] $TOOL already installed"
        else
            echo "[+] Installing $TOOL"
            pkg install "$TOOL" -y
        fi
    done
}


while true
do
    clear

    echo "=============================="
    echo "   SolukOS Security Toolkit"
    echo "=============================="
    echo ""

    echo "[1] Network Tools"
    echo "[2] Web Analysis Tools"
    echo "[3] Information Tools"
    echo "[4] System Tools"
    echo "[5] Check All Tools"
    echo "[6] Install Missing Tools"
    echo "[7] Install All Tools"
    echo "[8] Security Setup"
    echo "[9] Back"
    echo ""

    read -p "Choice: " choice


    case $choice in

    1)
        clear
        echo "Network Tools"
        echo ""
        check_tools "$NETWORK_TOOLS"
        ;;

    2)
        clear
        echo "Web Analysis Tools"
        echo ""
        check_tools "$WEB_TOOLS"
        ;;

    3)
        clear
        echo "Information Tools"
        echo ""
        check_tools "$INFO_TOOLS"
        ;;

    4)
        clear
        echo "System Tools"
        echo ""
        check_tools "$SYSTEM_TOOLS"
        ;;

    5)
        clear
        echo "Checking all tools..."
        echo ""
        check_tools "$ALL_TOOLS"
        ;;

    6)
        clear
        echo "Installing missing tools..."
        echo ""
        install_profile "$ALL_TOOLS"
        ;;

    7)
        clear
        echo "Installing Full Toolkit..."
        echo ""
        install_profile "$FULL_TOOLS"
        ;;

    8)
        clear

        echo "=============================="
        echo "     Security Setup"
        echo "=============================="
        echo ""

        echo "[1] Minimal Install"
        echo "[2] Standard Install"
        echo "[3] Full Install"
        echo "[4] Back"
        echo ""

        read -p "Choice: " setup

        case $setup in

        1)
            install_profile "$MINIMAL_TOOLS"
            ;;

        2)
            install_profile "$STANDARD_TOOLS"
            ;;

        3)
            install_profile "$FULL_TOOLS"
            ;;

        esac
        ;;


    9)
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter..."

done
