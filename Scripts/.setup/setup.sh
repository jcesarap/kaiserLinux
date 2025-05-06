#!/bin/bash

# --- --- --- --- --- --- --- --- --- --- --- --- Intro

set -e
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

if [ "$EUID" -ne 0 ]; then
    echo "Error - You must run this script with sudo (sudo ./script.sh)."
    exit 1
fi

read -p "Begin copying songs from Litill, Disable auto-suspend... and remember Wayland sucks"

# --- --- --- --- --- --- --- --- --- --- --- --- Arch
# From Installation media - Same as before, but ID the ventoy drive
sudo chown -R magn ~ # Fix permissions problems by giving user permissions over home directory - fixing all sorts of problems

# --- --- --- --- --- --- --- --- --- --- --- --- Install Dropbox (Arch)

echo "Press (d) to set default kernel on Systemd boot"
read -p " Setup Dropbox (y or n)? " option
read -p "Have you synced all files?"
read -p "Are you sure?"

if [ "$option" = "y" ]; then
        sudo pacman -S git base-devel
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin # If you try it on your .compiled dir, it causes problems with permissions, likely solveable by changing the dir's permissions
        makepkg -si
        sudo rm -r yay-bin/ # Removes left overs without removing installation
        cd ..
        yay -S dropbox
	elif [ "$option" = "n" ]; then
		echo "Dropbox setup script"
	else
		echo "Invalid option"
fi

# --- --- --- --- --- --- --- --- --- --- --- --- Permissions

chmod +x ~/Dropbox/Kaiser-Linux/Scripts/setup/ *
chmod +x ~/Dropbox/Kaiser-Linux/Scripts/rofi/ *
chmod +x ~/Dropbox/Kaiser-Linux/Configs/Public/xrandr/ *

# If you're ever changing paths of your scripts (1-scripts), remember to update on:
# Use VSCodium on whole Muninn to search and change all entries

# --- --- --- --- --- --- --- --- --- --- --- --- Scripts

bash "~/Dropbox/Kaiser-Linux/Scripts/setup/packages.sh"
bash "~/Dropbox/Kaiser-Linux/Scripts/setup/tweaks.sh"
bash "~/Dropbox/Kaiser-Linux/Scripts/setup/configs.sh"

# --- --- --- --- --- --- --- --- --- --- --- --- Ending

# Variable for multi-use
pending=$(cat <<EOL

# Pending Manual Setup
> Songs from Litill finished copying?
- Setup Syncthing
- LXAppearance - Apply themes.
- VM/Gnome-Boxes - Setup for torrenting (don't install transmission), testing of files and in general.

EOL
)
printf "%s\n" "$pending" >> "~/Dropbox/Notes/— Eisenhower/— Eisenhower.md" # Appending Pending Manual Changes to Eisenhower
printf "%s\n" "$pending" # Print the text to the terminal
