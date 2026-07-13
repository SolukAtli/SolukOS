#!/data/data/com.termux/files/usr/bin/bash
# Installs/removes external security tools that aren't real Termux packages
# (they're not in the Termux repos, so `pkg install` can't get them).
# Clones the upstream repo and drops a wrapper command in $PREFIX/bin so
# the tool works like any other installed command afterwards.
#
# Usage: external_install.sh <install|remove> <tool-name>

BASE_DIR="$(cat ~/.solukos/install_path 2>/dev/null)"
source "$BASE_DIR/scripts/lib/ui.sh"

ACTION="$1"
NAME="$2"

TOOLS_DIR="$HOME/.solukos/tools"
BIN_DIR="/data/data/com.termux/files/usr/bin"

install_git_tool()
{
    local name="$1" url="$2" runtime="$3" entry="$4" modules="$5"

    if ! command -v git >/dev/null 2>&1; then
        soluk_warn "git bulunamadi. 'pkg install git' ile kurup tekrar dene."
        return 1
    fi

    if ! command -v "$runtime" >/dev/null 2>&1; then
        soluk_info "$runtime kuruluyor..."
        pkg install "$runtime" -y
    fi

    mkdir -p "$TOOLS_DIR"

    if [ -d "$TOOLS_DIR/$name" ]; then
        soluk_warn "$name zaten kurulu ($TOOLS_DIR/$name)."
        if [ "$runtime" = "perl" ] && [ -n "$modules" ]; then
            install_perl_modules "$modules"
        fi
        return 0
    fi

    soluk_info "Cloning $name..."

    if git clone --depth 1 "$url" "$TOOLS_DIR/$name" >/dev/null 2>&1; then
        cat > "$BIN_DIR/$name" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
$runtime "$TOOLS_DIR/$name/$entry" "\$@"
WRAPPER
        chmod +x "$BIN_DIR/$name"
        soluk_ok "$name installed."

        if [ "$runtime" = "perl" ] && [ -n "$modules" ]; then
            install_perl_modules "$modules"
        fi

        soluk_ok "Type '$name' to run it."
    else
        soluk_warn "Clone failed. Check the URL and your internet connection."
        rm -rf "$TOOLS_DIR/$name"
    fi
}

# Installs any CPAN modules a tool needs that Termux doesn't package natively
# (e.g. nikto needs JSON and XML::Writer). Runs cpan non-interactively.
install_perl_modules()
{
    local modules="$1" mod missing=""

    for mod in $modules; do
        perl -M"$mod" -e1 >/dev/null 2>&1 || missing="$missing $mod"
    done

    [ -z "$missing" ] && return 0

    soluk_info "Installing Perl modules:$missing"
    soluk_warn "Bu birkac dakika surebilir, ilk kurulumda cpan kendini yapilandirir."

    for mod in $missing; do
        yes '' | PERL_MM_USE_DEFAULT=1 cpan -T "$mod" >/dev/null 2>&1
        if perl -M"$mod" -e1 >/dev/null 2>&1; then
            soluk_ok "$mod installed."
        else
            soluk_warn "$mod otomatik kurulamadi. Manuel dene: cpan $mod"
        fi
    done
}

remove_git_tool()
{
    local name="$1"
    rm -rf "$TOOLS_DIR/$name"
    rm -f "$BIN_DIR/$name"
    soluk_ok "$name removed."
}

case "$NAME" in

sqlmap)
    URL="https://github.com/sqlmapproject/sqlmap.git"
    RUNTIME="python3"
    ENTRY="sqlmap.py"
    MODULES=""
    ;;

nikto)
    URL="https://github.com/sullo/nikto.git"
    RUNTIME="perl"
    ENTRY="program/nikto.pl"
    MODULES="JSON XML::Writer"
    ;;

*)
    soluk_warn "'$NAME' icin otomatik kurulum tanimli degil. Manuel kurulum gerekli."
    exit 1
    ;;

esac

case "$ACTION" in
install) install_git_tool "$NAME" "$URL" "$RUNTIME" "$ENTRY" "$MODULES" ;;
remove)  remove_git_tool "$NAME" ;;
*)       soluk_warn "Bilinmeyen islem: $ACTION" ;;
esac
