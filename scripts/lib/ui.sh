#!/usr/bin/env bash
# SolukOS - shared UI helpers (colors, headers, fzf-based menus)
#
# Usage:
#   source "$BASE_DIR/scripts/lib/ui.sh"
#   soluk_header "Title"
#   choice=$(soluk_menu "Label" "Option 1" "Option 2" "Back")
#   soluk_banner "$BASE_DIR"
#
# Colors here are the *basic* ANSI slots (0-15). On the desktop, Konsole
# remaps those 16 slots via the color scheme written by scripts/theme.sh
# (~/.local/share/konsole/*.colorscheme), so the actual on-screen tones
# follow whatever palette is applied there - by default a muted / pale
# ("soluk") blue-gray theme.

SOLUK_RESET="\033[0m"
SOLUK_BOLD="\033[1m"
SOLUK_CYAN="\033[36m"
SOLUK_BCYAN="\033[96m"
SOLUK_BLUE="\033[34m"
SOLUK_GREEN="\033[32m"
SOLUK_RED="\033[31m"
SOLUK_YELLOW="\033[33m"
SOLUK_GRAY="\033[90m"

# Centered, bordered title box (a small "banner" for menu screens).
soluk_header()
{
    local title="$1"
    local cols
    cols=$(tput cols 2>/dev/null)
    [ -z "$cols" ] && cols=50

    local text=" ${title} "
    local len=${#text}
    local pad=$(( (cols - len - 2) / 2 ))
    [ "$pad" -lt 0 ] && pad=0
    local indent
    indent=$(printf '%*s' "$pad" "")

    local border
    border=$(printf '─%.0s' $(seq 1 "$len"))

    echo -e "${indent}${SOLUK_GRAY}╭${border}╮${SOLUK_RESET}"
    echo -e "${indent}${SOLUK_GRAY}│${SOLUK_RESET}${SOLUK_BOLD}${SOLUK_BCYAN}${text}${SOLUK_RESET}${SOLUK_GRAY}│${SOLUK_RESET}"
    echo -e "${indent}${SOLUK_GRAY}╰${border}╯${SOLUK_RESET}"
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

# Neutral info line, e.g. "[i] '<name>' is a plugin".
soluk_info()
{
    echo -e "${SOLUK_CYAN}[i]${SOLUK_RESET} $1"
}

# A single "  Label   value" row, label bold/cyan, value plain.
# Usage: soluk_row "Label" "value"
soluk_row()
{
    printf "  ${SOLUK_BOLD}${SOLUK_BCYAN}%-10s${SOLUK_RESET} %s\n" "$1" "$2"
}

# Prints assets/banner.txt centered and framed (delegates to print_banner.sh
# so zshrc and ui.sh always render it identically).
soluk_banner()
{
    local base_dir="${1:-$BASE_DIR}"
    bash "${base_dir}/scripts/lib/print_banner.sh" "$base_dir"
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

        # Muted palette: uses basic slots 4 (blue), 6 (cyan), 8 (gray), 15 (pale white)
        local result
        if [ -n "$binds" ]; then
            result=$(printf '%s\n' "${numbered[@]}" | fzf \
                --prompt="❯ " \
                --height="~70%" \
                --border=rounded \
                --reverse \
                --color="fg+:15,bg+:8,hl:6,hl+:6,pointer:4,prompt:4,border:4,header:4" \
                --bind "$binds")
        else
            result=$(printf '%s\n' "${numbered[@]}" | fzf \
                --prompt="❯ " \
                --height="~70%" \
                --border=rounded \
                --reverse \
                --color="fg+:15,bg+:8,hl:6,hl+:6,pointer:4,prompt:4,border:4,header:4")
        fi

        echo "${result#*) }"
    else
        echo -e "${SOLUK_GRAY}(fzf bulunamadi - 'sudo pacman -S fzf' ile modern menu acilir, simdilik klasik menu)${SOLUK_RESET}" >&2
        echo "" >&2

        local opt
        i=1
        for opt in "${options[@]}"
        do
            echo "[$i] $opt" >&2
            i=$((i+1))
        done

        echo "" >&2
        read -p "Choice: " num

        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$n" ]
        then
            echo "${options[$((num-1))]}"
        else
            echo ""
        fi
    fi
}
