#!/bin/bash
# Script para instalação de programas e sincronização de configurações via Dropbox - facilitando a configuração em novos computadores, pós formatação, e tornando viável um sistema altamente customizável, cujas customizações e funções não sejam eventualmente perdidas
# --- -- Seções do script
# Considerações iniciais (você está aqui)
# s-var # Variáveis
# s-programs # Programas que devem ser instalados
#   s-p-others # Outros pacotes
# s-tweaks # Algumas configurações manuais
# s-config # Sincronização de arquivos
# s-copies # Cópiando configurações da nuvem para o PC

# Verificando permisões necessárias e providenciando mensagens de erro
set -e
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
if [ "$EUID" -ne 0 ]; then
	echo "Error - You must run this script with sudo (sudo ./script.sh)."
	exit 1
fi

# --- --- Options
echo "=== === ===  SCRIPT DE INSTALAÇÃO E CONFIGURAÇÃO === === ==="
echo "   [ Para descobrir nome de usuário, abra outra janela do terminal e digite: whoami ]"
read -p "  Informe o nome do seu usuário: " user_name
read -p "  Quer fazer tudo (aperte [e], então [Enter]), ou só algumas coisas (aperte [s], então [Enter])  " option_skip
if [ "$option_skip" = "s" ]; then
	#
	read -p "  Instalar configurações do sistema? (y or n)?  " option_config # Sub-options: Flatpaks
	read -p "  Fazer ajustes? (y or n)?  " option_tweaks                     # Sub-options: None
	read -p "  Instalar programas? (y or n)?  " option_pkgs                  # Sub-options: None
	#
	read -p " Tem certeza? "
elif [ "$option_skip" = "e" ]; then
	read -p " Tem certeza que quer fazer tudo? "
else
	echo "Invalid Choice"
	exit 0
fi

# --- --- Redundancies
sudo chown -R bianca /home/bianca/
sudo chown -R bianca /home/bianca/.trash

# --- -- s-var (Variables)
BASE_DIR="/home/$user_name/Dropbox/Kaiser-Linux/Configs/Public"
CONFIG_DIR="/home/$user_name/.config"
SUDO_CONFIG_DIR="/etc"
FLATPAK_DIR="/home/$user_name/.var/app"

# --- --- Functions
# Adicione dentro dessa função, comandos de instalação de programas, e terá um "portable" setup (sempre que rodar esse script em novos computadores, terá seus programas nele)
function pkgs() {
	# Limpeza
	sudo dnf remove -y gnome-weather gnome-contacts gnome-maps yelp gnome-tour mediawriter libreoffice*
    sudo dnf autoremove
	# Nix
	sudo -u "$user_name" 'sh <(curl -L https://nixos.org/nix/install) --no-daemon && nix-env -iA nixpkgs.clipmenu && nix-env -iA nixpkgs.clipnotify && nix-env -iA nixpkgs.xclip && nix-env -iA nixpkgs.rofi-calc && nix-env -iA nixpkgs.ueberzug' &
	# Codium
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
	sudo dnf install -y code # or code-insiders
    # --- Compile
	sudo -u "$user_name" mkdir -p "/home/$user_name/.compiled" || :
    cd "/home/$user_name/.compiled"
	# i3color
	sudo dnf install -y codium autoconf automake cairo-devel fontconfig gcc libev-devel libjpeg-turbo-devel libXinerama libxkbcommon-devel libxkbcommon-x11-devel libXrandr pam-devel pkgconf xcb-util-image-devel xcb-util-xrm-devel
	git clone https://github.com/Raymo111/i3lock-color.git || :
	cd i3lock-color || :
	./install-i3lock-color.sh || :
    # pfetch
    wget https://github.com/dylanaraps/pfetch/archive/master.zip
    unzip master.zip
    sudo install pfetch-master/pfetch /usr/local/bin/
	# Pywal
	sudo dnf install python3-pip
	sudo pip3 install pywal
	# AutoCPUFreq
	git clone https://github.com/AdnanHodzic/auto-cpufreq.git || :
	cd auto-cpufreq && yes i | sudo ./auto-cpufreq-installer || :
	sudo dnf install -y mutter gnome-shell gnome-tweaks gnome-backgrounds baobab gnome-control-center gnome-menus gnome-session gnome-settings-daemon gdm # Gnome
    # Nerdfonts
    curl -o /tmp/Hack.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip
    unzip /tmp/Hack.zip -d "/home/$user_name/.local/share/fonts/"
    cd ~
    # AnyDesk
    sudo sh -c 'printf "[anydesk]\nname=AnyDesk Fedora - stable\nbaseurl=http://rpm.anydesk.com/fedora/\$basearch/\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY\n" > /etc/yum.repos.d/AnyDesk-Fedora.repo'
    sudo dnf install -y anydesk
    # --- Native package manager
    sudo dnf install -y luarocks syncthing nautilus fontawesome-fonts-all
	sudo dnf install -y haveged dbus wget zsh timeshift timeshift-gtk                                                                                                                                                                                            # Base
	sudo dnf install -y i3 i3status dmenu i3lock xbacklight feh
	sudo dnf install -y xss-lock picom network-manager-applet light maim xclip dunst polybar rofi
	sudo dnf install -y xorg-x11-server-Xorg xorg-x11-xinit i3 i3status i3lock ly polybar dmenu i2c-tools                                                                                                                                                        # Xorg & i3
	sudo dnf install -y xset xrandr arandr picom                                                                                                                                                                                                                 # Display
	sudo dnf install -y parcellite xdotool feh xarchiver atool unzip                                                                                                                                                                                             # Tools
	sudo dnf install -y postgresql bc python3-pip git gh gcc cmake automake npm nodejs ripgrep pandoc cargo bison rsync mediainfo meson python3 json-c cairo glib2 golang NetworkManager-libnm openssh                                                           # Development / Compiling
	sudo dnf install -y iwd ufw firewalld NetworkManager yt-dlp                                                                                                                                                                                                  # Network
	sudo dnf install -y brightnessctl rofi dunst playerctl alsa-utils alsa-tools alsa-lib pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol                                                                                                          # Xorg & Wayland Inter-Compatible
	sudo dnf install -y thermald acpid powertop glances upower lm_sensors cpupower procps-ng                                                                                                                                                                     # POWER OPTIMISATION
	sudo dnf install -y pass firefox bluez bluez-tools blueman unzip htop ranger w3m fzf findutils alacritty kitty keepassxc flameshot evince gnome-system-monitor id3v2 gnome-disk-utility clamtk calibre android-tools micro neovim vlc mpv socat jq mpv-mpris speedcrunch # Packages
	sudo dnf install -y xdg-utils flatpak-xdg-utils xdg-desktop-portal-gtk xdg-user-dirs-gtk                                                                                                                                                                     # For file integration in different packages
	sudo dnf install -y cups hplip system-config-printer                                                                                                                                                                                                         # Printer
	sudo dnf install -y dictd mythes gvfs gvfs-mtp android-file-transfer ncdu
	sudo dnf install -y gstreamer1 gstreamer1-plugins-base gstreamer1-plugins-base-tools gstreamer1-plugins-base-devel
	sudo dnf install \
		https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-42.noarch.rpm \
		https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-42.noarch.rpm
	sudo dnf install \
		gstreamer1-plugins-good \
		gstreamer1-plugins-bad-freeworld \
		gstreamer1-plugins-ugly-free \
		gstreamer1-vaapi
	sudo dnf install -y polkit lxqt-policykit ImageMagick gtk3
	flatpak install -y com.github.unrud.VideoDownloader org.videolan.VLC com.github.johnfactotum.Foliate com.brave.Browser com.discordapp.Discord md.obsidian.Obsidian io.github.shiftey.Desktop com.transmissionbt.Transmission
}

# --- --- s-tweaks

function tweaks() {
	# CREATE DIRECTORIES
	dirs=(
		"/home/$user_name/.trash"
		"/home/$user_name/Snapshots/"
		"/home/$user_name/.Snapshots/.stfolder" # So Syncthing works
		"/home/$user_name/.Snapshots/Manual"
		"/home/$user_name/.Snapshots/Automated"
		"/home/$user_name/.Snapshots/Automated/Dropbox"
		"/home/$user_name/.Snapshots/Automated/Music"
		"/home/$user_name/.Snapshots/Automated/Notes"
		"/home/$user_name/.Snapshots/Automated/Glyphi"
		"/home/$user_name/.compiled"
		"/home/$user_name/Sync"
		"/home/$user_name/Documents/Workspace-Magn"
		# Redundancy for cursors
		"/home/$user_name/.icons/default"
		"/usr/share/cursors/xorg-x11"
		"/root/.config/"
	)
	# Create directories - must be run as non-root to avoid permission issues
	for dir in "${dirs[@]}"; do
		sudo -u $user_name mkdir -p "$dir" || :
	done
	root_dirs=(
		# Redundancy for cursors
		"/home/$user_name/.icons/default"
		"/usr/share/cursors/xorg-x11"
		"/root/.config/"
	)
	# Create directories - must be run as non-root to avoid permission issues
	for root_dir in "${root_dirs[@]}"; do
		sudo mkdir -p "$root_dir" || :
	done
	# Remove directories
	rm -r "/home/$user_name/Videos" || :
	rm -r "/home/$user_name/Pictures" || :
	rm -r "/home/$user_name/Public" || :
	rm -r "/home/$user_name/Templates" || :
	rm -r "/home/$user_name/Snapshots" || :
	rm -r "/home/$user_name/Sync" || :
	# Update shortcuts
	# Change Shell
	sudo sed -i 's|/usr/bin/bash$|/usr/bin/zsh|' /etc/passwd
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	# --- --- --- --- --- --- --- --- --- --- --- --- Services
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	# --- --- Systemd
	sudo systemctl enable gdm || :
	sudo systemctl enable thermald.service
	sudo systemctl enable ufw.service  # For autostart firewall
	sudo systemctl enable fstrim.timer # SSD Trim
	sudo systemctl enable haveged      # To speed boot-decryption
	sudo systemctl enable NetworkManager.service
	sudo systemctl enable iwd.service # So wifi works when you boot
	sudo systemctl enable bluetooth
	sudo systemctl enable cups
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	# --- --- --- --- --- --- --- --- --- --- --- --- Text Editting
	# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	# Systemd Power settings
	sudo cp "/home/$user_name/Dropbox/Kaiser-Linux/Assets/DE/logind.conf" "/usr/lib/systemd/logind.conf" || :                    # Copy file to the location, if it doesn't exist
	sudo sed -i 's/^#HandleLidSwitch=.*$/HandleLidSwitch=ignore/' /etc/systemd/logind.conf || :                           # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
	sudo sed -i 's/^#HandleLidSwitchExternalPower=.*$/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf || : # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
	sudo sed -i 's/^#HandleLidSwitchDocked=.*$/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf || :               # Do nothing when closing the lid ——— HANDLED BY SYSTEMD, NOTICE THE PATH
	sudo sed -i 's/^#IdleAction=.*$/IdleAction=ignore/' /etc/systemd/logind.conf || :                                     # Disable automatic suspension
	sudo sed -i 's/^#HandlePowerKey=.*$/HandlePowerKey=suspend/' /etc/systemd/logind.conf || :                            # Suspend with power button
	# For brightnessctl to work without root
	sudo sed -i '$a $user_name ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl' /etc/sudoers
	# Quiet Boot
	sudo sed -i '/^options/ {/quiet splash/! s/$/ quiet splash/}' /boot/loader/entries/*
	# For power
	sudo usermod -aG power $USER
	sudo usermod -aG video $USER
	# Basic git setup
	git config --global user.name "$user_name"
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
		"/usr/share/sddm"
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
		"/home/$user_name/Dropbox/Notes/Workspace-Sulruna/"
		"/home/$user_name/Workspace-Magn"
		"/home/$user_name/.bash_profile"
		"/home/$user_name/.fonts"
		"/home/$user_name/.bashrc"
		"/home/$user_name/.bash_history"
		"/home/$user_name/.zshrc"
		"/home/$user_name/.Xresources"
		"/usr/share/X11/xkb/symbols/br"
		"/home/$user_name/.local/share/nvim/lazy"
		"/home/$user_name/.local/share/nvim/lazy-rocks"
		"/home/$user_name/.p10k.zsh"
		"/usr/share/zsh-theme-powerlevel10k"
	)
	#
	for i in "${!redundancy[@]}"; do
		sudo rm -r "${redundancy[i]}" || :
		sudo rm "${redundancy[i]}" || :
	done
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
	ln -s "$BASE_DIR/Code - OSS/" "$CONFIG_DIR/"
	ln -s "$BASE_DIR/Code - OSS/" "$CONFIG_DIR/Code"
	# ---
	ln -s "/home/$user_name/Dropbox/Kaiser-Linux/Glyphs/nvim/lazy/" "/home/$user_name/.local/share/nvim/"
	ln -s "/home/$user_name/Dropbox/Kaiser-Linux/Glyphs/nvim/lazy-rocks/" "/home/$user_name/.local/share/nvim/"
	# --- Nvim's plugins without language servers
	ln -s "/home/$user_name/Dropbox/Kaiser-Linux/Configs/Public/sddm/" "/usr/share/"
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
	ln -s "$BASE_DIR/ranger/" "$CONFIG_DIR/"     # Otherwise you don't get configs on non-root
	ln -s "$BASE_DIR/parcellite/" "$CONFIG_DIR/" # Otherwise you don't get configs on non-root
	# --- Wayland
	# ln -s "$BASE_DIR/waybar/" "$CONFIG_DIR/"
	# ln -s "$BASE_DIR/sway/" "$CONFIG_DIR/"
	# ln -s "$BASE_DIR/hypr/" "$CONFIG_DIR/"
	# --- Home
	ln -s "$BASE_DIR/bash/.bash_profile" "/home/$user_name/.bash_profile"
	ln -s "$BASE_DIR/bash/.bashrc" "/home/$user_name/.bashrc"
	ln -s "$BASE_DIR/bash/.bash_history" "/home/$user_name/.bash_history"
	ln -s "$BASE_DIR/.Xresources" "/home/$user_name/.Xresources"
	ln -s "$BASE_DIR/zsh/.zshrc" "/home/$user_name/.zshrc"
	ln -s "$BASE_DIR/zsh/.p10k.zsh" "/home/$user_name/.p10k.zsh"
	ln -s "$BASE_DIR/.fonts/" "/home/$user_name/"
	# --- s-copies
	# --- Root
	sudo ln -s "$BASE_DIR/zsh/zsh-theme-powerlevel10k" "/usr/share/" # p10k configure # to change settings
	sudo ln -s "$BASE_DIR/timeshift/" "/etc/"
	# sudo ln -s "$BASE_DIR/ranger/" "/root/.config/"
	sudo ln -s "$BASE_DIR/conky/" "$SUDO_CONFIG_DIR/"
	sudo ln -s "$BASE_DIR/xkb/symbols/br" "/usr/share/X11/xkb/symbols/"
	#
	# --- Pasting to system
	#
	# Firefox - GET STATIC CONFIG (keep its Lara in case you need switching in the future)
	local_dir_name=$(ls "/home/$user_name/.mozilla/firefox" | grep default-release) && echo $local_dir_name                   # Gets path of the working directory
	cp -r "/home/$user_name/Dropbox/Kaiser-Linux/Configs/Public/firefox/"* "/home/$user_name/.mozilla/firefox/$local_dir_name/" # It musn't use rsync, as it would delete other files
	cp -r "/home/$user_name/Dropbox/Kaiser-Linux/Configs/Public/firefox/"* "/home/$user_name/.mozilla/firefox/$local_dir_name/"
	# Theme
	sudo cp -r $BASE_DIR/themes/* "/usr/share/themes/" # Copies content of theme folder
	# Cursors
	sudo cp -r "$BASE_DIR/cursors" "/usr/share"
	sudo cp -r $BASE_DIR/cursors/GoogleDot-Black/* "/home/$user_name/.icons/default/" ||:
	# Silencing NM
	sudo cp "$BASE_DIR/networkmanager/NetworkManager.conf" "/etc/NetworkManager/" ||:
	# ——— cp syncs the content or folder, rsync syncs folders
	#
	gsettings set org.gnome.desktop.interface cursor-theme GoogleDot-Black ||:
	# Flatpaks
	rm -r "/home/$user_name/.var/app/md.obsidian.Obsidian/config/obsidian" || :
	ln -s "$BASE_DIR/——— Flatpak/Obsidian/" "$FLATPAK_DIR/md.obsidian.Obsidian/config/" || :
}

# --- --- Control Flow

if [ "$option_skip" = "e" ]; then
	pkgs
	tweaks
	configs
	configs_flatpak
	echo "—— All setup √"
elif [ "$option_skip" = "s" ]; then
	# Configs
	if [ "$option_config" = "y" ]; then
		configs
		echo "—— Configs √"
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
		pkgs
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
