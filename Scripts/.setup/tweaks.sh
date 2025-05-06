#!/bin/bash
set -e
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
# --- --- --- --- --- --- --- --- --- --- --- --- Redundancy
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

# CREATE DIRECTORIES
dirs=(
    "~/.trash"
    "~/Snapshots/"
    "~/.temp/"
    "~/.Snapshots/.stfolder" # So Syncthing works
    "~/.Snapshots/Manual"
    "~/.Snapshots/Automated"
    "~/.Snapshots/Automated/Dropbox"
    "~/.Snapshots/Automated/Music"
    "~/.Snapshots/Automated/Notes"
    "~/.Snapshots/Automated/Glyphi"
    "~/.compiled"
    "~/Sync"
    "~/.minecraft/saves"
    "~/.config/systemd/user"
    # Redundancy for cursors
    "~/.icons/default"
    "/usr/share/cursors/xorg-x11"
    "/root/.config/"
)
# Create directories - must be run as non-root to avoid permission issues
for dir in "${dirs[@]}"; do
    sudo -u magn mkdir -p "$dir" || :
done
# Remove directories
rm -r ~/Videos || :
rm -r ~/Pictures || :
rm -r ~/Public || :
rm -r ~/Templates || :
rm -r ~/Snapshots || :
rm -r ~/Sync || :
# Update shortcuts
rm "~/—— Morphographia" || :
ln -s "~/Dropbox/Notes/Ark/Ágna/Enchanting/—— Morphographia" "~/" || :


# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
# --- --- --- --- --- --- --- --- --- --- --- --- Compiling
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

# ONLY STEP THAT CAN NOT BE REPEATED WITHOUT BEING UNDONE
# Prompt
echo "Wanna do manual compiles - first time running the script (y or n): "
read input
# Control flow
if [ "$input" == "y" ]; then
    # Old compiling commands for auto-cpufreq (Helps with battery, but it also seems to be helping with stable temperature keeping) and micro, hidden in archive directory
	printf "\n In another shell, with (yay -S pkgname): \n"
	printf "\n - envycontrol auto-cpufreq python-pywal \n"
    read -p "Are you done?"
    # (hyprland-scanner-git,"
elif [ "$input" == "n" ]; then
    echo "Manual Compilations skipped"
    printf "%s\n" "- Manual Compiling of programs" >> "~/Dropbox/Notes/— Eisenhower/— Eisenhower.md"
else
    echo "Invalid input: $input"
fi

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
# --- --- --- --- --- --- --- --- --- --- --- --- Services
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

sudo auto-cpufreq --install ||:
# --- --- Systemd
sudo systemctl enable thermald.service
sudo systemctl enable ufw.service # For autostart firewall
sudo systemctl enable fstrim.timer # SSD Trim
sudo systemctl enable haveged # To speed boot-decryption
sudo systemctl enable NetworkManager.service
sudo systemctl enable iwd.service # So wifi works when you boot
sudo systemctl enable power-profiles-daemon.service
systemctl --user enable clipmenud.service
# User
cp -r "~/Dropbox/Kaiser-Linux/Configs/Public/systemd/" "~/.config"
sudo systemctl daemon-reload

# sudo systemctl enable cron.service # Needed only on Arch

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
# --- --- --- --- --- --- --- --- --- --- --- --- Text Editting
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

#
# --- --- --- --- --- Short
#

# Systemd Power settings
sudo cp "~/Dropbox/Kaiser-Linux/Assets/DE/logind.conf" "/usr/lib/systemd/logind.conf" # Copy file to the location, if it doesn't exist
sudo sed -i 's/^#HandleLidSwitch=.*$/HandleLidSwitch=ignore/' /etc/systemd/logind.conf # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
sudo sed -i 's/^#HandleLidSwitchExternalPower=.*$/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
sudo sed -i 's/^#HandleLidSwitchDocked=.*$/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
sudo sed -i 's/^#IdleAction=.*$/IdleAction=ignore/' /etc/systemd/logind.conf # Disable automatic suspension
sudo sed -i 's/^#HandlePowerKey=.*$/HandlePowerKey=suspend/' /etc/systemd/logind.conf # Suspend with power butto
# For brightnessctl to work without root
sudo sed -i '$a magn ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl' /etc/sudoers
# For power
sudo usermod -aG power $USER
