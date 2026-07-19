#!/usr/bin/env bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"

source "$BASE_DIR/scripts/lib/ui.sh"

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
            soluk_ok "$TOOL installed"
        else
            soluk_fail "$TOOL missing"
        fi
    done
}


install_profile()
{
    for TOOL in $1
    do
        if command -v "$TOOL" >/dev/null 2>&1
        then
            soluk_ok "$TOOL already installed"
        else
            case "$TOOL" in
            sqlmap|nikto)
                bash "$BASE_DIR/scripts/package/external_install.sh" install "$TOOL"
                ;;
            *)
                soluk_info "Installing $TOOL"
                sudo pacman -S --noconfirm "$TOOL"
                ;;
            esac
        fi
    done
}


while true
do
    clear
    soluk_header "SolukOS Security Toolkit"

    choice=$(soluk_menu "Security Toolkit" \
        "Network Tools" \
        "Web Analysis Tools" \
        "Information Tools" \
        "System Tools" \
        "Check All Tools" \
        "Install Missing Tools" \
        "Install All Tools" \
        "Security Setup" \
        "Back")

    case "$choice" in

    "Network Tools")
        clear
        soluk_header "Network Tools"
        check_tools "$NETWORK_TOOLS"
        ;;

    "Web Analysis Tools")
        clear
        soluk_header "Web Analysis Tools"
        check_tools "$WEB_TOOLS"
        ;;

    "Information Tools")
        clear
        soluk_header "Information Tools"
        check_tools "$INFO_TOOLS"
        ;;

    "System Tools")
        clear
        soluk_header "System Tools"
        check_tools "$SYSTEM_TOOLS"
        ;;

    "Check All Tools")
        clear
        soluk_header "Checking All Tools"
        check_tools "$ALL_TOOLS"
        ;;

    "Install Missing Tools")
        clear
        soluk_header "Installing Missing Tools"
        install_profile "$ALL_TOOLS"
        ;;

    "Install All Tools")
        clear
        soluk_header "Installing Full Toolkit"
        install_profile "$FULL_TOOLS"
        ;;

    "Security Setup")
        clear
        soluk_header "Security Setup"

        setup=$(soluk_menu "Security Setup" "Minimal Install" "Standard Install" "Full Install" "Back")

        case "$setup" in
            "Minimal Install")  clear; soluk_header "Minimal Install";  install_profile "$MINIMAL_TOOLS" ;;
            "Standard Install") clear; soluk_header "Standard Install"; install_profile "$STANDARD_TOOLS" ;;
            "Full Install")     clear; soluk_header "Full Install";     install_profile "$FULL_TOOLS" ;;
        esac
        ;;

    "Back"|"")
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter..."

done
