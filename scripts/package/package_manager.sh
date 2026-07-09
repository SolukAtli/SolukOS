#!/data/data/com.termux/files/usr/bin/bash

DB="$HOME/SolukOS/packages/database.txt"

search_package() {
read -p "Package: " QUERY
grep -i "$QUERY" "$DB" || echo "Not found"
}

install_package() {
read -p "Install: " PKG
INFO=$(grep "^$PKG|" "$DB")
[ -z "$INFO" ] && echo "Not found" && return
IFS="|" read -r NAME CATEGORY TYPE STATUS <<< "$INFO"

if [ "$TYPE" = "native" ]; then
pkg install "$NAME" -y
elif [ "$TYPE" = "plugin" ]; then
echo "Plugin install coming soon"
else
echo "Manual install required"
fi
}

while true
do
clear

echo "=== SolukOS Package Manager ==="
echo "[1] List"
echo "[2] Search"
echo "[3] Check"
echo "[4] Install"
echo "[5] Back"

read -p "Choice: " choice

case "$choice" in

1)
cat "$DB"
;;

2)
search_package
;;

3)
while IFS="|" read -r NAME CATEGORY TYPE STATUS
do
command -v "$NAME" >/dev/null 2>&1 &&
echo "[✓] $NAME" ||
echo "[ ] $NAME"
done < "$DB"
;;

4)
install_package
;;

5)
exit 0
;;

esac

read -p "Press Enter..."
done
