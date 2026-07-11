#!/data/data/com.termux/files/usr/bin/bash
# Prints assets/banner.txt centered, framed and colored in the muted
# "Soluk" (pale/misty) palette.
#
# BANNER_WIDTH is the banner's fixed visual width (42 chars for the
# current SOLUK block-letter art - all 6 lines are already equal width).
# If assets/banner.txt is ever replaced with different art, update this
# number to match its longest line's visual character count.

BASE_DIR="${1:-$HOME/SolukOS}"
BANNER_FILE="$BASE_DIR/assets/banner.txt"
[ -f "$BANNER_FILE" ] || BANNER_FILE="$HOME/.solukos/banner.txt"
[ -f "$BANNER_FILE" ] || exit 0

BANNER_WIDTH=42

COLS=$(tput cols 2>/dev/null)
[ -z "$COLS" ] && COLS=50

PAD=$(( (COLS - BANNER_WIDTH - 4) / 2 ))
[ "$PAD" -lt 0 ] && PAD=0
INDENT=$(printf '%*s' "$PAD" "")

BORDER=$(printf '─%.0s' $(seq 1 $((BANNER_WIDTH + 2))))

echo -e "${INDENT}\033[1;90m╭${BORDER}╮\033[0m"

awk -v indent="$INDENT" '
{
    colors[0]=96; colors[1]=36; colors[2]=94; colors[3]=34; colors[4]=90; colors[5]=97
    c = colors[(NR-1) % 6]
    printf "%s\033[1;90m│\033[0m \033[1;%sm%s\033[0m \033[1;90m│\033[0m\n", indent, c, $0
}' "$BANNER_FILE"

echo -e "${INDENT}\033[1;90m╰${BORDER}╯\033[0m"
