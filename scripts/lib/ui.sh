#!/data/data/com.termux/files/usr/bin/bash
# SolukOS - shared UI helpers (colors, headers, fzf-based menus)
#
# Usage:
#   source "$BASE_DIR/scripts/lib/ui.sh"
#   soluk_header "Title"
#   choice=$(soluk_menu "Label" "Option 1" "Option 2" "Back")
#   soluk_banner "$BASE_DIR"

SOLUK_RESET="\033[0m"
SOLUK_BOLD="\033[1m"
SOLUK_CYAN="\033[36m"
SOLUK_BCYAN="\033[96m"
SOLUK_GREEN="\033[32m"
SOLUK_RED="\033[31m"
SOLUK_YELLOW="\033[33m"
SOLUK_GRAY="\033[90m"

soluk_header()
{
    local title="$1"
    echo -e "${SOLUK_CYAN}══════════════════════════════${SOLUK_RESET}"
    echo -e "${SOLUK_BOLD}${SOLUK_BCYAN}  ${title}${SOLUK_RESET}"
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

# Prints assets/banner.txt with a cyan/blue "mist" gradient (matches
# the "Soluk" = pale/misty branding).
soluk_banner()
{
    local base_dir="$1"
    local banner_file="${base_dir}/assets/banner.txt"
    [ -f "$banner_file" ] || banner_file="$HOME/.solukos/banner.txt"
    [ -f "$banner_file" ] || return 0

    awk '{
        c[0]=96; c[1]=36; c[2]=94; c[3]=34; c[4]=39; c[5]=97
        idx = (NR-1) % 6
        printf "\033[1;%sm%s\033[0m\n", c[idx], $0
    }' "$banner_file"
}

# Returns 0 if the installed fzf supports the pos() bind action (>=0.35.0).
_soluk_fzf_supports_pos()
{
    local ver major minor
    ver=$(fzf --version 2>/dev/null | awk '{print $1}')
    major=$(echo "$ver" | cut -d. -f1)
    minor=$(echo "$ver" | cut -d. -f2)
    [ -z "$major" ] && return 1
    [ "$major" -gt 0 ] && return 0
    [ -n "$minor" ] && [ "$minor" -ge 35 ] && return 0
    return 1
}

# soluk_menu <label (kept for API compatibility, not shown)> <option1> <option2> ...
# Prints the chosen option text on stdout (empty string if cancelled).
# Arrow keys navigate; number keys 1-9 jump straight to that option.
soluk_menu()
{
    shift
    local options=("$@")
    local n=${#options[@]}

    if command -v fzf >/dev/null 2>&1
    then
        local numbered=()
        local i
        for ((i=0; i<n; i++)); do
            numbered+=("$((i+1))) ${options[$i]}")
        done

        local binds=""
        if _soluk_fzf_supports_pos; then
            for ((i=1; i<=n && i<=9; i++)); do
                binds+="${i}:pos(${i})+accept,"
            done
            binds="${binds%,}"
        fi

        local result
        if [ -n "$binds" ]; then
            result=$(printf '%s\n' "${numbered[@]}" | fzf \
                --prompt="❯ " \
                --height="~70%" \
                --border=rounded \
                --reverse \
                --color="fg+:white,bg+:24,hl:51,hl+:51,pointer:39,prompt:39,border:39,header:39" \
                --bind "$binds")
        else
            result=$(printf '%s\n' "${numbered[@]}" | fzf \
                --prompt="❯ " \
                --height="~70%" \
                --border=rounded \
                --reverse \
                --color="fg+:white,bg+:24,hl:51,hl+:51,pointer:39,prompt:39,border:39,header:39")
        fi

        echo "${result#*) }"
    else
        echo -e "${SOLUK_GRAY}(fzf bulunamadi - 'pkg install fzf' ile modern menu acilir, simdilik klasik menu)${SOLUK_RESET}"
        echo ""

        local opt
        i=1
        for opt in "${options[@]}"
        do
            echo "[$i] $opt"
            i=$((i+1))
        done

        echo ""
        read -p "Choice: " num

        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$n" ]
        then
            echo "${options[$((num-1))]}"
        else
            echo ""
        fi
    fi
}
