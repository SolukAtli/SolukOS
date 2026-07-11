#!/data/data/com.termux/files/usr/bin/bash
# SolukOS - shared UI helpers (colors, headers, fzf-based menus)
#
# Usage:
#   source "$BASE_DIR/scripts/lib/ui.sh"
#   soluk_header "Title"
#   choice=$(soluk_menu "Prompt" "Option 1" "Option 2" "Back")

SOLUK_RESET="\033[0m"
SOLUK_BOLD="\033[1m"
SOLUK_CYAN="\033[36m"
SOLUK_GREEN="\033[32m"
SOLUK_RED="\033[31m"
SOLUK_YELLOW="\033[33m"
SOLUK_GRAY="\033[90m"

soluk_header()
{
    local title="$1"
    echo -e "${SOLUK_CYAN}══════════════════════════════${SOLUK_RESET}"
    echo -e "${SOLUK_BOLD}${SOLUK_CYAN}  ${title}${SOLUK_RESET}"
    echo -e "${SOLUK_CYAN}══════════════════════════════${SOLUK_RESET}"
    echo ""
}

soluk_ok()
{
    echo -e "${SOLUK_GREEN}[✓]${SOLUK_RESET} $1"
}

soluk_fail()
{
    echo -e "${SOLUK_RED}[ ]${SOLUK_RESET} $1"
}

soluk_warn()
{
    echo -e "${SOLUK_YELLOW}[!]${SOLUK_RESET} $1"
}

# soluk_menu <prompt label> <option1> <option2> ...
# Prints the chosen option text on stdout (empty string if cancelled).
soluk_menu()
{
    local title="$1"
    shift
    local options=("$@")

    if command -v fzf >/dev/null 2>&1
    then
        printf '%s\n' "${options[@]}" | fzf \
            --prompt="${title} › " \
            --height="~70%" \
            --border=rounded \
            --reverse \
            --color="prompt:cyan,pointer:cyan,border:cyan,header:cyan"
    else
        echo -e "${SOLUK_GRAY}(fzf bulunamadi - 'pkg install fzf' ile modern menu acilir, simdilik klasik menu)${SOLUK_RESET}"
        echo ""

        local i=1
        local opt
        for opt in "${options[@]}"
        do
            echo "[$i] $opt"
            i=$((i+1))
        done

        echo ""
        read -p "Choice: " num

        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#options[@]}" ]
        then
            echo "${options[$((num-1))]}"
        else
            echo ""
        fi
    fi
}
