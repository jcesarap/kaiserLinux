#!/bin/bash
set -e
trap 'echo "$0: Error on line "$LINENO": $BASH_COMMAND"' EXIT
# ---
if [ "$EUID" -ne 0 ]; then
    echo "Error - You must run this script with sudo (sudo ./script.sh)."
    exit 1
fi
# ---
# Variables
BASE_DIR="~/Dropbox/Kaiser-Linux/Configs/Public"
CONFIG_DIR="~/.config"
SUDO_CONFIG_DIR="/etc"
FLATPAK_DIR="~/.var/app"
# --- 
redundancy=(
    # Configs
    "$CONFIG_DIR/xrandr"
    "$CONFIG_DIR/gtk-3.0"
    "$CONFIG_DIR/gtk-4.0"
    "$CONFIG_DIR/htop"
    "$CONFIG_DIR/cmus"
    "$CONFIG_DIR/dunst"
    "$CONFIG_DIR/micro"
    "$CONFIG_DIR/nvim"
    "$CONFIG_DIR/calibre"
    "$CONFIG_DIR/i3"
    "$CONFIG_DIR/picom"
    # "$CONFIG_DIR/sway"
    # "$CONFIG_DIR/hypr"
    # "$CONFIG_DIR/waybar"
    "$CONFIG_DIR/i3status"
    "$CONFIG_DIR/polybar"
    "$CONFIG_DIR/alacritty"
    "$CONFIG_DIR/kitty"
    "$CONFIG_DIR/ksnip"
    "$CONFIG_DIR/ranger"
    "$CONFIG_DIR/rofi"
    "$CONFIG_DIR/parcellite"
    "$CONFIG_DIR/qutebrowser"
    # Flatpak
    "~/.var/app/io.typora.Typora/config/Typora"
    "~/.var/app/io.freetubeapp.FreeTube/config/FreeTube"
    "~/.var/app/org.inkscape.Inkscape/config/inkscape"
    # Other locations
    "/etc/conky"
    "/root/.config/ranger"
    "/etc/timeshift"
    # Files
    "$CONFIG_DIR/monitors.xml"
    "$CONFIG_DIR/mimeapps.list"
    "~/.bash_profile"
    "~/.bashrc"
    "~/.bash_history"
    "~/.Xresources"
    "/usr/share/X11/xkb/symbols/br"
)
#
for i in "${!redundancy[@]}"; do
    sudo rm -r "${redundancy[i]}" || :
    sudo rm "${redundancy[i]}" || :
done
#
# --------------------------------- Flatpaks

# Prompt
echo "Sync flatpak configs - Typora, Freetybe, Inkscape (y or n): "
read flatpak_configs_input

# --- --- Cleaning up (Failed removals: gnome-system-monitor; gnome-disk-utility; gedit-common; orca)
# Control flow
if [ "$flatpak_configs_input" == "y" ]; then
    # General
    read -p "Open (to generate configs): Typora, Freetube, Inkscape,"
    read -p "Have you opened and closed those apps? [Press Enter if you have]"
    # Linking
    ln -s "$BASE_DIR/Typora/" "$FLATPAK_DIR/io.typora.Typora/config/"
    ln -s "$BASE_DIR/FreeTube/" "$FLATPAK_DIR/io.freetubeapp.FreeTube/config/"
    ln -s "$BASE_DIR/inkscape/" "$FLATPAK_DIR/org.inkscape.Inkscape/config/"
elif [ "$flatpak_configs_input" == "n" ]; then
    printf "%s\n" "- Setup Flatpak configs" >> "~/Dropbox/Notes/— Eisenhower/— Eisenhower.md"
else
    echo "Invalid input: $flatpak_configs_input"
fi
#
#
#
# --- --- Linking
# --- Config
ln -s "$BASE_DIR/xrandr/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/gtk-3.0/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/gtk-4.0/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/monitors.xml" "$CONFIG_DIR/monitors.xml"
ln -s "$BASE_DIR/mimeapps.list" "$CONFIG_DIR/mimeapps.list"
ln -s "$BASE_DIR/htop/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/cmus/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/dunst/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/micro/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/nvim/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/i3/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/picom/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/alacritty/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/kitty/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/rofi/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/calibre/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/i3status/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/polybar/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/ksnip/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/qutebrowser/" "$CONFIG_DIR/"
ln -s "$BASE_DIR/ranger/" "$CONFIG_DIR/" # Otherwise you don't get configs on non-root
ln -s "$BASE_DIR/parcellite/" "$CONFIG_DIR/" # Otherwise you don't get configs on non-root
# --- Wayland
# ln -s "$BASE_DIR/waybar/" "$CONFIG_DIR/"
# ln -s "$BASE_DIR/sway/" "$CONFIG_DIR/"
# ln -s "$BASE_DIR/hypr/" "$CONFIG_DIR/"
# --- Home
ln -s "$BASE_DIR/bash/.bash_profile" "~/.bash_profile"
ln -s "$BASE_DIR/bash/.bashrc" "~/.bashrc"
ln -s "$BASE_DIR/bash/.bash_history" "~/.bash_history"
ln -s "$BASE_DIR/.Xresources" "~/.Xresources"
# --- Root
sudo ln -s "$BASE_DIR/timeshift/" "/etc/"
# sudo ln -s "$BASE_DIR/ranger/" "/root/.config/"
sudo ln -s "$BASE_DIR/conky/" "$SUDO_CONFIG_DIR/"
sudo ln -s "$BASE_DIR/xkb/symbols/br" "/usr/share/X11/xkb/symbols/"
#
# --- Pasting to system
#
# Firefox - GET STATIC CONFIG (keep its Lara in case you need switching in the future)
local_dir_name=$(ls "~/.mozilla/firefox" | grep default-release) && echo $local_dir_name # Gets path of the working directory
cp -r ~/Dropbox/Kaiser-Linux/Configs/Public/firefox/* "~/.mozilla/firefox/$local_dir_name/" # It musn't use rsync, as it would delete other files
# Theme
sudo cp -r $BASE_DIR/themes/* "/usr/share/themes/" # Copies content of theme folder
# Cursors
sudo cp -r "$BASE_DIR/cursors" "/usr/share"
sudo cp -r $BASE_DIR/cursors/GoogleDot-Black/* "~/.icons/default/"
# Silencing NM
sudo cp "$BASE_DIR/networkmanager/NetworkManager.conf" "/etc/NetworkManager/"
# Minecraft
rsync -avh --delete "~/Dropbox/Kaiser-Linux/Assets/minecraft-worlds/New World (1)" "~/.minecraft/saves"
#
# ——— cp syncs the content or folder, rsync syncs folders
#
gsettings set org.gnome.desktop.interface cursor-theme GoogleDot-Black
