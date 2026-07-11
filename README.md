## 🌫️ SolukOS

A lightweight, modular and cybersecurity-focused environment built on Termux.

## 📌 About

SolukOS is a personal open-source project designed to provide a Linux-inspired experience on Android through Termux.

The project combines terminal customization, package management, plugin support and system utilities into a single environment for learning Linux, cybersecurity concepts and shell scripting.

## ✨ Features

- 🐧 Linux-style terminal experience
- 🌫️ Custom SolukOS branding
- 📦 Built-in package management
- 🧩 Plugin system
- ⚙️ SolukOS command-line interface
- 🔍 Package search and information tools
- 🩺 System diagnostics ("doctor")
- 📋 Package database support
- 🚀 Modular architecture
- 💡 fzf-powered menus and shell history/file search
- ⚡ Smart navigation with zoxide, modern `ls`/`cat` via eza and bat
- 🖼️ `soluk fetch` system summary screen

## 🚀 Installation

```git clone https://github.com/SolukAtli/SolukOS.git
cd SolukOS
chmod +x install.sh
./install.sh
```

## 💻 Available Commands

- soluk version
- soluk doctor
- soluk reload
- soluk fetch
- soluk help

- soluk pkg list
- soluk pkg search `<package>`
- soluk pkg info `<package>`
- soluk pkg install `<package>`
- soluk pkg remove `<package>`

## 🛠 Project Structure

- SolukOS/
- ├── scripts/
- ├── packages/
- ├── plugins/
- ├── docs/
- ├── assets/
- ├── config/
- └── install.sh

## 🗺️ Roadmap

v0.6.1

- [x] Package Manager
- [x] CLI Commands
- [x] Package Search
- [x] Package Information
- [x] Package Installation
- [x] Package Removal
- [x] Doctor Command
- [x] Version Command

v0.7.0

- [x] Help Command
- [x] Update Command
- [x] Improved Diagnostics
- [x] zsh-autosuggestions / zsh-syntax-highlighting
- [x] fzf history & file search (CTRL+R / CTRL+T / ALT+C)
- [x] zoxide, bat, eza
- [x] soluk fetch
- [ ] Plugin Enable/Disable

v0.8.0

- [ ] Repository System
- [ ] Automatic Updates
- [ ] Package Dependency Support

v1.0.0

- [ ] First Stable Release

## ⚠️ Disclaimer

SolukOS is intended for Linux learning, scripting practice, terminal customization and cybersecurity education.

Users are responsible for ensuring that all activities are lawful and authorized.

## 📜 Version

Current Version: v0.7.0
