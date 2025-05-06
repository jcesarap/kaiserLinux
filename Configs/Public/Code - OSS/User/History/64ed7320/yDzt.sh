#!/bin/bash

#
#
# | To quickly navigate: search,esc
# | ...so setup can be re-ran after a snapshot restoration, ensuring everything is synced (as long as changes are documented to them)
# | ...If anything goes wrong by fault of home config, with the script so well integrated... you can find the faulty stack (E.g., Configs, tweaks, Packages)... and from it, find the faulty unit (E.g., Command, Package).
#
#
#
# --- -- Sections of script
# s-forewords (You're here)
# s-var
# s-programs
#   s-p-others
# s-flatpaks
# s-tweaks
# s-copies
# --- --- Bash

set -e
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

if [ "$EUID" -ne 0 ]; then
    echo "Error - You must run this script with sudo (sudo ./script.sh)."
    exit 1
fi

# --- --- Warnings

echo "— Remember Wayland doesn't support current hardware"
echo "— Re-run this when recovering from a snapshot"

cat << EOF

  # ——— Before anything
  # Fix Permissions - sudo chown -R magn ~
  # Install flatpak - sudo pacman -S flatpak
  # Copy songs from Litill
  # Compile yay and packages
		# sudo pacman -S git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && sudo rm -r yay-bin && yay -S dropbox # For Installing yay and Dropbox
		# yay -S envycontrol auto-cpufreq python-pywal i3lock-color
  # Setup Nvidia - sudo envycontrol -s hybrid --force-comp
  # Install Nixpkgs - to further ability to install apps without updating, distro/package-management freedom
		# sh <(curl -L https://nixos.org/nix/install) --no-daemon
  # Reboot & Finally run

EOF
read -p "Enter to Continue"

# --- --- Redundancies

sudo chmod +x ~/Dropbox/Kaiser-Linux/Scripts/rofi/*
sudo chmod +x ~/Dropbox/Kaiser-Linux/Configs/Public/xrandr/*

# --- -- s-var (Variables) 
BASE_DIR="~/Dropbox/Kaiser-Linux/Configs/Public"
CONFIG_DIR="~/.config"
SUDO_CONFIG_DIR="/etc"
FLATPAK_DIR="~/.var/app"

# --- --- Options

read -p "  Want to run everything - or separate sections? (e or s) " option_skip
if [ "$option_skip" = "s" ]; then
	#
	read -p "  Run CONFIGS? (y or n)?  " option_config # Sub-options: Flatpaks
	if [ "$option_config" = "y" ]; then
		# Only way to set them up should be through here, they only run with y - and don't with empty value
		read -p "      Setup flatpak configs (Inkscape, FreeTube, Typora)? (y or n)  " option_flatpak_configs
	else
		printf " "
	fi
	#
	read -p "  Run TWEAKS? (y or n)?  " option_tweaks # Sub-options: None
	read -p "  Run PKGS? (y or n)?  " option_pkgs # Sub-options: None
	#
	read -p " Are you sure? "
elif [ "$option_skip" = "e" ]; then
	read -p " Are you sure you want to run everything? "
else
	echo "Invalid Choice"
	exit 0
fi

# --- --- Functions

function pkgs_pacman() { 
    # Prompts
    read -p "Do you want to install Gnome (y/n)? " install_gnome
    # read -p "Do you want to install Nvidia (y/n)? " install_nvidia
    # Commands
    sudo pacman -S --noconfirm util-linux linux linux-headers haveged dbus wget zsh timeshift # Base
    sudo pacman -S --noconfirm xorg xorg-server xorg-apps xorg-xinit xorg-xhost xorg-xev i3-wm ly polybar dmenu xorg-server i2c-tools # Xorg & i3
    if [[ $install_gnome == "y" ]]; then
        sudo pacman -S --noconfirm mutter gnome-shell gnome-tweaks gnome-backgrounds baobab gnome-control-center gnome-menus gnome-session gnome-settings-daemon gnome-shell-extensions rygel sushi # Gnome
    fi
    sudo pacman -S --noconfirm xorg-xset xorg-xrandr arandr picom # Display
    sudo pacman -S --noconfirm xorg-xbacklight clipnotify xorg-xclipboard xclip parcellite clipmenu xdotool feh xf86-input-wacom xf86-input-synaptics xarchiver atool unzip # Tools
    sudo pacman -S --noconfirm postgresql bc python-pip python-pylatexenc git github-cli gcc cmake automake npm nodejs ripgrep pandoc cargo bison rsync mediainfo meson python3 json-c cairo glib2 go libnm openssh ueberzug python-pyqt5 # Development / Compiling
    sudo pacman -S --noconfirm libx11 libxrandr libxi libxcursor libxinerama # For raylib
    sudo pacman -S --noconfirm iwd ufw firewalld networkmanager yt-dlp # Network
    sudo pacman -S --noconfirm brightnessctl rofi dunst playerctl alsa-utils alsa-tools alsa-lib pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol # Xorg & Wayland Inter-Compatible
    sudo pacman -S --noconfirm thermald acpid acpi_call powertop glances upower lm_sensors cpupower procps-ng # POWER OPTIMISATION
    sudo pacman -S --noconfirm protonmail-bridge pass code pacman-contrib firefox bluez bluez-utils blueman unzip htop ranger w3m fzf findutils mlocate alacritty kitty keepassxc flameshot evince gnome-system-monitor id3v2 gnome-disk-utility clamtk calibre gnome-boxes nautilus arc-gtk-theme arc-icon-theme android-tools lazygit micro neovim vlc cmus speedcrunch clonezilla # Packages
    if [[ $install_nvidia == "y" ]]; then
        sudo pacman -S --noconfirm libva-mesa-driver mesa mesa-utils vulkan-intel xf86-video-nouveau nvidia-open nvidia-open-lts libglvnd lib32-virtualgl # Video Drivers (Don't install any drivers via archinstall, but these)
    fi
    sudo pacman -S --noconfirm xf86-video-intel intel-media-driver libva-intel-driver # General drivers
    sudo pacman -S --noconfirm nvidia-prime nvidia-utils lib32-nvidia-utils nvidia-settings # GPU Utils
    sudo pacman -S --noconfirm xdg-utils flatpak-xdg-utils xdg-desktop-portal-gtk xdg-user-dirs-gtk # For file integration in different packages
    sudo pacman -S --noconfirm cups hplip gtk3-print-backends system-config-printer # Printer
    sudo pacman -S --noconfirm fwupd iucode-tool lxappearance intel-ucode amd-ucode # Package management
    sudo pacman -S --noconfirm dictd gstreamer mythes gvfs gvfs-mtp android-file-transfer power-profiles-daemon hunspell-en_gb 
    sudo pacman -S --noconfirm polkit lxqt-policykit imagemagick ffmpeg gtk3 gstreamer-vaapi gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-plugins-base
    sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-liberation ttf-dejavu ttf-roboto ttf-ubuntu-mono-nerd ttf-ubuntu-font-family ttf-nerd-fonts-symbols-mono # Others
}

# --- s-flatpaks

function pkgs_flatpaks() {
	flatpak install -y ar.com.tuxguitar.TuxGuitar io.typora.Typora com.protonvpn.www org.libreoffice.LibreOffice com.github.unrud.VideoDownloader  org.videolan.VLC org.inkscape.Inkscape org.darktable.Darktable com.icons8.Lunacy com.jgraph.drawio.desktop org.shotcut.Shotcut com.obsproject.Studio com.github.tchx84.Flatseal io.freetubeapp.FreeTube org.musescore.MuseScore com.github.johnfactotum.Foliate org.kde.kdenlive org.nickvision.tagger dev.mufeed.Wordbook com.github.xournalpp.xournalpp com.brave.Browser com.discordapp.Discord md.obsidian.Obsidian com.github.zocker_160.SyncThingy org.kde.elisa com.transmissionbt.Transmission org.prismlauncher.PrismLauncher # Install Syncthing via flatpak, as updates are more indenpendet, and often required
	flatpak run dev.mufeed.Wordbook &
}

# -- Others
#   s-p-others
function pkgs_others() {
    # General
    echo "Skipped"
	# NixPkgs 
    # NPM
    npm install -g vtop
}

# --- --- s-tweaks

function tweaks() {
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
        "~/Documents/——— Workspace-Magn"
        # Redundancy for cursors
        "~/.icons/default"
        "/usr/share/cursors/xorg-x11"
        "/root/.config/"
        "~/Litill'Avi"
	)
	# Create directories - must be run as non-root to avoid permission issues
	for dir in "${dirs[@]}"; do
	    sudo -u magn mkdir -p "$dir" || :
	done
	root_dirs=(
        # Redundancy for cursors
        "~/.icons/default"
        "/usr/share/cursors/xorg-x11"
        "/root/.config/"
	)
	# Create directories - must be run as non-root to avoid permission issues
	for root_dir in "${root_dirs[@]}"; do
	    sudo mkdir -p "$root_dir" || :
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
    # Change Shell
    sudo sed -i 's|/usr/bin/bash$|/usr/bin/zsh|' /etc/passwd
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
	# --- --- --- --- --- --- --- --- --- --- --- --- Services
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
	sudo auto-cpufreq --install ||:
    sudo systemctl unmask power-profiles-daemon.service
	sudo systemctl enable power-profiles-daemon.service ||:
	# --- --- Systemd
	sudo systemctl enable thermald.service
	sudo systemctl enable ufw.service # For autostart firewall
	sudo systemctl enable fstrim.timer # SSD Trim
	sudo systemctl enable haveged # To speed boot-decryption
	sudo systemctl enable NetworkManager.service
	sudo systemctl enable iwd.service # So wifi works when you boot
	sudo systemctl enable bluetooth
    sudo systemctl enable cups
    # --- --- Touchpad
    sudo systemctl daemon-reload
    sudo systemctl enable disable-touchpad-pm.service
    sudo systemctl start disable-touchpad-pm.service
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
	# --- --- --- --- --- --- --- --- --- --- --- --- Text Editting
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
	# Systemd Power settings
	sudo cp "~/Dropbox/Kaiser-Linux/Assets/DE/logind.conf" "/usr/lib/systemd/logind.conf" # Copy file to the location, if it doesn't exist
	sudo sed -i 's/^#HandleLidSwitch=.*$/HandleLidSwitch=ignore/' /etc/systemd/logind.conf # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
	sudo sed -i 's/^#HandleLidSwitchExternalPower=.*$/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
	sudo sed -i 's/^#HandleLidSwitchDocked=.*$/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
	sudo sed -i 's/^#IdleAction=.*$/IdleAction=ignore/' /etc/systemd/logind.conf # Disable automatic suspension
	sudo sed -i 's/^#HandlePowerKey=.*$/HandlePowerKey=suspend/' /etc/systemd/logind.conf # Suspend with power butto
	# For brightnessctl to work without root
	sudo sed -i '$a magn ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl' /etc/sudoers
    # Quiet Boot
    sudo sed -i '/^options/ {/quiet splash/! s/$/ quiet splash/}' /boot/loader/entries/*
	# For power
	sudo usermod -aG power $USER
	sudo usermod -aG video $USER
    # Basic git setup
	git config user.username "kaiser"
    git config user.email "jkaisermp@protonmail.com"
}

# --- --- s-configs

function configs() {
	# DELETES (LINKS, NOT FILES)
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
			"$CONFIG_DIR/Code - OSS"
			"$CONFIG_DIR/calibre"
			"$CONFIG_DIR/i3"
			"$CONFIG_DIR/picom"
			"$CONFIG_DIR/dconf"
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
			# Other locations
			"/etc/conky"
			"/root/.config/ranger"
			"/etc/timeshift"
			# Files
			"$CONFIG_DIR/monitors.xml"
			"$CONFIG_DIR/mimeapps.list"
			# Others
			"~/Dropbox/Notes/——— Workspace-Sulruna/"
			"~/——— Workspace-Magn"
			"~/.bash_profile"
			"~/.fonts"
			"~/.bashrc"
			"~/.bash_history"
            "~/.zshrc"
			"~/.Xresources"
			"/usr/share/X11/xkb/symbols/br"
			"~/.local/share/nvim"
	)
	#
	for i in "${!redundancy[@]}"; do
		sudo rm -r "${redundancy[i]}" || :
		sudo rm "${redundancy[i]}" || :
	done
	#
	# --- --- Linking
	# --- Config
	ln -s "~/Documents/——— Workspace-Magn" "~/——— Workspace-Magn"
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
	ln -s "$BASE_DIR/Code - OSS/" "$CONFIG_DIR/"
	ln -s "~/Dropbox/Kaiser-Linux/Glyphs/nvim/" "~/.local/share/"
	ln -s "$BASE_DIR/i3/" "$CONFIG_DIR/"
	ln -s "$BASE_DIR/picom/" "$CONFIG_DIR/"
	ln -s "$BASE_DIR/dconf/" "$CONFIG_DIR/" # GNOME SETTINGS - that which is not already handled and backed up by xorg
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
	ln -s "$BASE_DIR/zsh/.zshrc" "~/.zshrc"
	ln -s "$BASE_DIR/.fonts/" "~/"
    ln -s "~/Dropbox/Notes/——— Workspace-Sulruna" "~/"
    # --- s-copies
	# --- Root
	sudo ln -s "$BASE_DIR/timeshift/" "/etc/"
	# sudo ln -s "$BASE_DIR/ranger/" "/root/.config/"
	sudo ln -s "$BASE_DIR/conky/" "$SUDO_CONFIG_DIR/"
	sudo ln -s "$BASE_DIR/xkb/symbols/br" "/usr/share/X11/xkb/symbols/"
    sudo cp "~/Dropbox/Kaiser-Linux/Assets/DE/70-synaptics.conf" "/etc/X11/xorg.conf.d"
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
    # Touchpad Power management                     ---             Touchpad issues were caused when you added powertop to the system, which turned powersaving to touchpad
    sudo cp "~/Dropbox/Kaiser-Linux/Assets/DE/disable-touchpad-pm.service" "/etc/systemd/system/"
	# Minecraft
	rsync -avh --delete "~/Dropbox/Kaiser-Linux/Assets/minecraft-worlds/New World (1)" "~/.minecraft/saves"
	# Nvidia & Touchpad
	sudo cp ~/Dropbox/Kaiser-Linux/Assets/Xorg/* "/etc/X11/xorg.conf.d/"
	# ——— cp syncs the content or folder, rsync syncs folders
	#
	gsettings set org.gnome.desktop.interface cursor-theme GoogleDot-Black
}

function configs_flatpak() {
	# General
	read -p "Open (to generate configs): Typora, Freetube, Inkscape,"
	read -p "Have you opened and closed those apps? [Press Enter if you have]"
	# Redundancy
	rm -r "~/.var/app/io.typora.Typora/config/Typora" || :
	rm -r "~/.var/app/io.freetubeapp.FreeTube/config/FreeTube" || :
	rm -r "~/.var/app/org.inkscape.Inkscape/config/inkscape" || :
	rm -r "~/.var/app/com.github.xournalpp.xournalpp/config/xournalpp" || :
	rm -r "~/.var/app/md.obsidian.Obsidian/config/obsidian" || :
	rm -r "~/.var/app/org.musescore.MuseScore/config/MuseScore" || :
	# Linking
	ln -s "$BASE_DIR/——— Flatpak/Typora/" "$FLATPAK_DIR/io.typora.Typora/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/FreeTube/" "$FLATPAK_DIR/io.freetubeapp.FreeTube/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Inkscape/" "$FLATPAK_DIR/org.inkscape.Inkscape/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/xournalpp/" "$FLATPAK_DIR/com.github.xournalpp.xournalpp/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Obsidian/" "$FLATPAK_DIR/md.obsidian.Obsidian/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Musescore/" "$FLATPAK_DIR/org.musescore.MuseScore/config/" || :
}

# If Flatpak configs are ran, great indicative you're running this for the first time since reset
function post_first_install() {
	pending=$(printf " \n # Pending Manual Setup \n > Songs from Litill finished copying? \n - Setup Syncthing.")
	printf "%s\n" "$pending" >> "~/Dropbox/Mirror/——— Eisenhower/— Head.md" # Appending Pending Manual Changes to Eisenhower
	printf "%s\n" "$pending" # Print the text to the terminal
}

# --- --- Control Flow

if [ "$option_skip" = "e" ]; then
	pkgs_pacman
	pkgs_flatpaks
	pkgs_others
	tweaks
	configs
	configs_flatpak
	echo "—— All setup √"
elif [ "$option_skip" = "s" ]; then
	# Configs
	if [ "$option_config" = "y" ]; then
		configs
		echo "—— Configs √"
		if [ "$option_flatpak_configs" = "y" ]; then
			configs_flatpak
			post_first_install
			echo "—— Flatpak-configs √ "
		else
			echo "—— Flatpak-configs x"
		fi
	else
		echo "—— Configs x"
	fi
	# Tweaks
	if [ "$option_tweaks" = "y" ]; then
		tweaks
		echo "—— Tweaks √ "
	else
		echo "—— Tweaks x"
	fi
	# Pkgs
	if [ "$option_pkgs" = "y" ]; then
		pkgs_pacman
		pkgs_flatpaks
		pkgs_others
		echo "—— Packages √ "
	elif [ "$option_pkgs" = "n" ]; then
		echo "—— Pkgs x"
	else
		echo "Invalid option for Pkgs"
		exit 0
	fi
else
	echo "Invalid option..."
fi

post_first_install
