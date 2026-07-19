#!/usr/bin/env bash
# Applies a SolukOS terminal theme by writing a real Konsole color scheme +
# profile (~/.local/share/konsole/) and setting it as the default profile in
# konsolerc. This replaced the old Termux colors.properties approach when
# SolukOS moved to KDE Plasma / Konsole (Faz 3).

SOLUK_DIR="$HOME/.solukos"
THEME_FILE="$SOLUK_DIR/theme"
KONSOLE_DATA_DIR="$HOME/.local/share/konsole"
KONSOLE_CONFIG="$HOME/.config/konsolerc"

SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -f "$SELF_DIR/logger.sh" ] && source "$SELF_DIR/logger.sh"

mkdir -p "$SOLUK_DIR"
mkdir -p "$KONSOLE_DATA_DIR"
mkdir -p "$(dirname "$KONSOLE_CONFIG")"

echo "[+] Applying SolukOS theme..."

if [ ! -f "$THEME_FILE" ]; then
    echo "soluk" > "$THEME_FILE"
fi

THEME=$(cat "$THEME_FILE")

case "$THEME" in

matrix)
THEME_NAME="Matrix"
# Classic black/green hacker terminal.
cat > "$KONSOLE_DATA_DIR/Matrix.colorscheme" << 'COLORSCHEME'
[Background]
Color=10,14,10

[BackgroundFaint]
Color=10,14,10

[BackgroundIntense]
Color=18,48,24

[Color0]
Color=10,14,10

[Color0Faint]
Color=10,14,10

[Color0Intense]
Color=18,48,24

[Color1]
Color=31,122,63

[Color1Faint]
Color=31,122,63

[Color1Intense]
Color=46,153,80

[Color2]
Color=51,204,85

[Color2Faint]
Color=51,204,85

[Color2Intense]
Color=77,224,119

[Color3]
Color=94,232,122

[Color3Faint]
Color=94,232,122

[Color3Intense]
Color=123,255,160

[Color4]
Color=38,138,74

[Color4Faint]
Color=38,138,74

[Color4Intense]
Color=55,168,96

[Color5]
Color=47,179,92

[Color5Faint]
Color=47,179,92

[Color5Intense]
Color=67,194,111

[Color6]
Color=57,212,102

[Color6Faint]
Color=57,212,102

[Color6Intense]
Color=77,232,138

[Color7]
Color=168,247,187

[Color7Faint]
Color=168,247,187

[Color7Intense]
Color=216,255,228

[Foreground]
Color=51,255,102

[ForegroundFaint]
Color=51,255,102

[ForegroundIntense]
Color=216,255,228

[General]
Anchor=Automatic
Blur=false
ColorRandomization=false
Description=Matrix
FillStyle=1
Opacity=1
Wallpaper=
COLORSCHEME
    ;;

nord)
THEME_NAME="Nord"
# Cool blue-gray, based on the popular Nord palette.
cat > "$KONSOLE_DATA_DIR/Nord.colorscheme" << 'COLORSCHEME'
[Background]
Color=46,52,64

[BackgroundFaint]
Color=46,52,64

[BackgroundIntense]
Color=76,86,106

[Color0]
Color=59,66,82

[Color0Faint]
Color=59,66,82

[Color0Intense]
Color=76,86,106

[Color1]
Color=191,97,106

[Color1Faint]
Color=191,97,106

[Color1Intense]
Color=191,97,106

[Color2]
Color=163,190,140

[Color2Faint]
Color=163,190,140

[Color2Intense]
Color=163,190,140

[Color3]
Color=235,203,139

[Color3Faint]
Color=235,203,139

[Color3Intense]
Color=235,203,139

[Color4]
Color=129,161,193

[Color4Faint]
Color=129,161,193

[Color4Intense]
Color=129,161,193

[Color5]
Color=180,142,173

[Color5Faint]
Color=180,142,173

[Color5Intense]
Color=180,142,173

[Color6]
Color=136,192,208

[Color6Faint]
Color=136,192,208

[Color6Intense]
Color=143,188,187

[Color7]
Color=229,233,240

[Color7Faint]
Color=229,233,240

[Color7Intense]
Color=236,239,244

[Foreground]
Color=216,222,233

[ForegroundFaint]
Color=216,222,233

[ForegroundIntense]
Color=236,239,244

[General]
Anchor=Automatic
Blur=false
ColorRandomization=false
Description=Nord
FillStyle=1
Opacity=1
Wallpaper=
COLORSCHEME
    ;;

soluk|default|*)
THEME_NAME="Soluk"
THEME="soluk"
# Muted / pale ("soluk") palette: grays and desaturated blue/gold tones.
# Kept identical to iso/airootfs/usr/share/konsole/Soluk.colorscheme so the
# CLI and the desktop ship the exact same default.
cat > "$KONSOLE_DATA_DIR/Soluk.colorscheme" << 'COLORSCHEME'
[Background]
Color=28,31,36

[BackgroundFaint]
Color=28,31,36

[BackgroundIntense]
Color=43,47,54

[Color0]
Color=43,47,54

[Color0Faint]
Color=43,47,54

[Color0Intense]
Color=74,79,88

[Color1]
Color=165,107,107

[Color1Faint]
Color=165,107,107

[Color1Intense]
Color=197,143,143

[Color2]
Color=127,159,127

[Color2Faint]
Color=127,159,127

[Color2Intense]
Color=163,194,163

[Color3]
Color=191,174,127

[Color3Faint]
Color=191,174,127

[Color3Intense]
Color=216,199,154

[Color4]
Color=127,159,191

[Color4Faint]
Color=127,159,191

[Color4Intense]
Color=163,194,224

[Color5]
Color=159,143,191

[Color5Faint]
Color=159,143,191

[Color5Intense]
Color=194,174,224

[Color6]
Color=127,176,175

[Color6Faint]
Color=127,176,175

[Color6Intense]
Color=163,214,212

[Color7]
Color=192,200,208

[Color7Faint]
Color=192,200,208

[Color7Intense]
Color=238,241,245

[Foreground]
Color=192,200,208

[ForegroundFaint]
Color=192,200,208

[ForegroundIntense]
Color=238,241,245

[General]
Anchor=Automatic
Blur=false
ColorRandomization=false
Description=Soluk
FillStyle=1
Opacity=1
Wallpaper=
COLORSCHEME
    ;;

esac

# Write/refresh the matching Konsole profile so it points at the color
# scheme we just wrote.
cat > "$KONSOLE_DATA_DIR/$THEME_NAME.profile" << PROFILE
[Appearance]
ColorScheme=$THEME_NAME
Font=DejaVu Sans Mono,10,-1,5,50,0,0,0,0,0

[General]
Name=$THEME_NAME
Parent=FALLBACK/
PROFILE

# Make it the default profile for new Konsole windows/tabs, without
# clobbering any other settings that might already be in konsolerc.
if [ -f "$KONSOLE_CONFIG" ] && grep -q '^\[Desktop Entry\]' "$KONSOLE_CONFIG"; then
    if grep -q '^DefaultProfile=' "$KONSOLE_CONFIG"; then
        sed -i "s|^DefaultProfile=.*|DefaultProfile=$THEME_NAME.profile|" "$KONSOLE_CONFIG"
    else
        sed -i "/^\[Desktop Entry\]/a DefaultProfile=$THEME_NAME.profile" "$KONSOLE_CONFIG"
    fi
else
    printf '[Desktop Entry]\nDefaultProfile=%s.profile\n' "$THEME_NAME" >> "$KONSOLE_CONFIG"
fi

echo "[+] Konsole temasi guncellendi. Yeni acilan terminallerde aktif olacak."
echo "[+] Theme set to: $THEME"

command -v log >/dev/null 2>&1 && log "Theme set to: $THEME"
