#!/data/data/com.termux/files/usr/bin/bash

PLUGIN_DIR="$HOME/SolukOS/plugins"
INSTALLED_DIR="$PLUGIN_DIR/installed"

mkdir -p "$INSTALLED_DIR"

while true
do
    clear

    echo "=============================="
    echo "       Plugin Manager"
    echo "=============================="
    echo ""

    echo "[1] List Plugins"
    echo "[2] Plugin Info"
    echo "[3] Run Plugin"
    echo "[4] Install Plugin"
    echo "[5] Remove Plugin"
    echo "[6] Back"
    echo ""

    read -p "Choice: " choice

    case $choice in

    1)
        clear
        echo "Installed Plugins:"
        echo ""

        for PLUGIN in "$INSTALLED_DIR"/*
        do
            if [ -d "$PLUGIN" ]; then
                NAME=$(basename "$PLUGIN")

                echo "$NAME"

                if [ -f "$PLUGIN/info" ]; then
                    grep "Description=" "$PLUGIN/info"
                fi

                echo ""
            fi
        done
        ;;


    2)
        read -p "Plugin name: " plugin

        if [ -f "$INSTALLED_DIR/$plugin/info" ]; then
            echo ""
            cat "$INSTALLED_DIR/$plugin/info"
        else
            echo "[!] Plugin info not found."
        fi
        ;;


    3)
        read -p "Plugin name: " plugin

        if [ -f "$INSTALLED_DIR/$plugin/plugin.sh" ]; then

            echo ""
            echo "Plugin information:"
            echo ""

            if [ -f "$INSTALLED_DIR/$plugin/info" ]; then
                cat "$INSTALLED_DIR/$plugin/info"
            fi

            echo ""

            read -p "Run plugin? (y/n): " confirm

            if [ "$confirm" = "y" ]; then
                bash "$INSTALLED_DIR/$plugin/plugin.sh"
            else
                echo "Cancelled."
            fi

        else
            echo "[!] Plugin not found."
        fi
        ;;


    4)
        echo "Available plugins:"
        echo ""

        ls "$PLUGIN_DIR"

        echo ""

        read -p "Plugin name: " plugin

        if [ -d "$PLUGIN_DIR/$plugin" ]; then
            cp -r "$PLUGIN_DIR/$plugin" "$INSTALLED_DIR/"
            echo "[+] Plugin installed."
        else
            echo "[!] Plugin not found."
        fi
        ;;


    5)
        read -p "Plugin name: " plugin

        if [ -d "$INSTALLED_DIR/$plugin" ]; then
            rm -rf "$INSTALLED_DIR/$plugin"
            echo "[+] Plugin removed."
        else
            echo "[!] Plugin not found."
        fi
        ;;


    6)
        break
        ;;


    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter to continue..."

done
