package managerıda şöyle yapıcam

#!/data/data/com.termux/files/usr/bin/bash

DB_FILE="$HOME/SolukOS/packages/database.txt"

if [ ! -f "$DB_FILE" ]; then
echo "[!] Package database not found: $DB_FILE"
exit 1
fi

while true
do
clear

echo "=============================="  
echo "      Package Manager"  
echo "=============================="  
echo ""  
echo "[1] List Packages"  
echo "[2] Search Package"  
echo "[3] Package Info"  
echo "[4] Install Package"  
echo "[5] Remove Package"  
echo "[6] Check Installed Status"  
echo "[7] Back"  
echo ""  

read -p "Choice: " choice  

case $choice in  

1)  
    clear  
    echo "Available Packages:"  
    echo ""  
    cat "$DB_FILE"  
    ;;  

2)  
    read -p "Search term: " term  
    clear  
    echo "Results for '$term':"  
    echo ""  
    grep -i "$term" "$DB_FILE"  
    ;;  

3)  
    read -p "Package name: " pkgname  
    clear  
    INFO=$(grep "^$pkgname|" "$DB_FILE")  

    if [ -z "$INFO" ]; then  
        echo "[!] Package not found."  
    else  
        IFS="|" read -r NAME CATEGORY TYPE STATUS <<< "$INFO"  
        echo "Name: $NAME"  
        echo "Category: $CATEGORY"  
        echo "Type: $TYPE"  
        echo "Status: $STATUS"  
    fi  
    ;;  

4)  
    read -p "Package name: " pkgname  
    clear  
    INFO=$(grep "^$pkgname|" "$DB_FILE")  

    if [ -z "$INFO" ]; then  
        echo "[!] Package not found."  
    else  
        IFS="|" read -r NAME CATEGORY TYPE STATUS <<< "$INFO"  

        if [ "$TYPE" = "native" ]; then  
            pkg install "$NAME" -y  
        elif [ "$TYPE" = "plugin" ]; then  
            echo "[i] '$NAME' is a plugin. Use Plugin Manager (menu option 7) to install it."  
        else  
            echo "[!] '$NAME' is an external tool. Manual installation required."  
        fi  
    fi  
    ;;  

5)  
    read -p "Package name: " pkgname  
    clear  
    INFO=$(grep "^$pkgname|" "$DB_FILE")  

    if [ -z "$INFO" ]; then  
        echo "[!] Package not found."  
    else  
        IFS="|" read -r NAME CATEGORY TYPE STATUS <<< "$INFO"  

        if [ "$TYPE" = "native" ]; then  
            pkg uninstall "$NAME" -y  
        elif [ "$TYPE" = "plugin" ]; then  
            echo "[i] '$NAME' is a plugin. Use Plugin Manager (menu option 7) to remove it."  
        else  
            echo "[!] Manual removal required for '$NAME'."  
        fi  
    fi  
    ;;  

6)  
    clear  
    echo "Checking installed status..."  
    echo ""  

    while IFS="|" read -r NAME CATEGORY TYPE STATUS  
    do  
        [ -z "$NAME" ] && continue  

        if command -v "$NAME" >/dev/null 2>&1; then  
            echo "[✓] $NAME"  
        else  
            echo "[ ] $NAME"  
        fi  
    done < "$DB_FILE"  
    ;;  

7)  
    break  
    ;;  

*)  
    echo "Invalid option."  
    ;;  

esac  

echo ""  
read -p "Press Enter to continue..."

done
