#!/bin/bash
set -e
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

if [ "$EUID" -ne 0 ]; then
    echo "Error - You must run this script with sudo (sudo ./script.sh)."
    read -p "Press Enter to exit."
    exit 1
fi

# Prompt
echo "Want to install flatpak (y or n): "
read flatpak_input

read -p "Are you sure?"

# --- --- Redundancy - Flatpak
# DOING IT ON POP_OS CAUSES PROBLEMS, SO SKIP IT
if [ "$flatpak_input" == "y" ]; then
    sudo pacman -S flatpak
    read -p "Reboot once before continuing" && read -p "Reboot now or continue"
elif [ "$flatpak_input" == "n" ]; then
    echo "Flatpak install skipped"
else
    echo "Invalid input: $flatpak_input"
fi

# --- --- Flatpak
# DON'T INSTALL TRANSMISSION - USE THAT FUNCTION ON WM's ONLY (for safe torrrenting)
flatpak install -y ar.com.tuxguitar.TuxGuitar io.typora.Typora com.protonvpn.www com.github.taiko2k.tauonmb org.libreoffice.LibreOffice com.github.unrud.VideoDownloader  org.videolan.VLC org.inkscape.Inkscape org.darktable.Darktable com.icons8.Lunacy com.jgraph.drawio.desktop org.shotcut.Shotcut com.obsproject.Studio com.github.tchx84.Flatseal app.moosync.moosync io.freetubeapp.FreeTube org.musescore.MuseScore com.github.johnfactotum.Foliate org.kde.kdenlive org.nickvision.tagger dev.mufeed.Wordbook com.rtosta.zapzap
flatpak run dev.mufeed.Wordbook &
		
# --- --- Other packages
# --- Pip
# YouTube Downloader
cd "~/.compiled" && pip install yt-dlp && cd ~/

# --- --- Arrays
# --- Adapt between distros (script)
# Check for groups/packages
# List/Install packages in groups
# Isolate cognate packages from differently named
# Fuzzy search of incognito packages
pkgs=(
    #
    # Base
    #
    "util-linux" # SSD Trim
    "haveged" # Speed boot-decryption
    "dbus"
    "wget"
    "zsh"
    "timeshift" # Snapshots
    # 
    # Xorg
    #
	"xorg" # A group of packages
	"xorg-apps"
	"xorg-xinit"
    "xorg-xhost"
    "xorg-xev"
    "i3-wm"
    "i3lock"
    "i3status"
    "polybar"
    "dmenu"
	#
	# Display
	#
	"lightdm"
	"lightdm-gtk-greeter"
    "xorg-xset"
    "xorg-xrandr"
    "arandr" # Managed by sway on wayland
	"picom"
    #
    # Tools
    #
    "xorg-xbacklight"
    "clipnotify"
    "xorg-xclipboard" # It has proven required for this to work
    "xclip" # Required for clipboard-pins.sh
    "parcellite" # Clipboard sync & monitor
    "clipmenu" # Clipboard Manager on rofi
    "xdotool" # Required for a script 'startup_tweaks.sh'
    "feh"
    #
    # Development / Compiling
    #
    "bc"
    "python-pip"
    "git"
    "gcc" # C... compilers - includes gcc-c++/g++
    "cmake"
    "automake"
    "npm"
    "nodejs"
    "ripgrep"
    "cargo" # Rust
    "bison" # For rofi build
    "rsync" # For desktop scripts
    "mediainfo" # For desktop scripts
    "meson" 
    "python3" # Fedora: python
    "json-c" # Fedora: json-c
    "cairo" # Fedora: "cairo"
    "glib2" # Fedora: "glib"
    "go" # Fedora: "go"
    "libnm"
    "openssh"
	# 
    # Network
    #
    "iwd"
    "ufw"
    "firewalld"
    "networkmanager"
	#
    # Xorg & Wayland Inter-Compatible
    #
    "nvidia-settings"
    "brightnessctl"
    "rofi"
    "dunst"
    "playerctl"
    "alsa-utils" # Fedora: "alsa-firmware"
    "pipewire"
    "pipewire-pulse"
    "pipewire-alsa"
    "wireplumber"
    "pavucontrol"
    "xf86-input-synaptics" # To solve touchpad issues
    #
    # POWER OPTIMISATION
    #
    "thermald" # Thermal data gathering
    "acpid" # To manage power actions such as opening/closing the lid
    "acpi_call"
    "powertop"
    "glances" # Health monitor
    # "tlp" # Can not be coupled with auto-cpufreq
    "upower" # For scripts such as /DE/cycles.sh
    "lm_sensors"
    "cpupower"
    "procps-ng" # How top is called on arch
	#
    # Packages
    #
	"protonmail-bridge"
	"pass"
	"code"
    "pacman-contrib"
    "firefox"
    "cmus"
    # "qutebrowser" # Slow, no addons, hard to configure, small community and bad docs
    "bluez"
    "blueman" # Bluetooth GUI
    "unzip"
    "htop"
    "ranger"
	"loupe"
    "w3m" # Image previews
    "fzf" # Required for find/jump ranger functionality
    "findutils" # Required for find/jump ranger functionality
    "mlocate" # Required for find/jump ranger functionality
    "alacritty"
    "kitty"
    "keepassxc"
    "flameshot"
    "speedcrunch" # Calculator
    "evince" # PDF Reader
    "gnome-system-monitor"
    "id3v2" # For automatic genre tagging
    "gnome-disk-utility"
    "clamtk" # Antivirus
    "calibre"
    "syncthing"
    "gnome-boxes"
    "nautilus" # For usb and litill device file management (& adb)
    "android-tools"
    "lazygit"
    "micro"
    "neovim"
	#
	# Nvidia
	#
	# ——— All you need for Nvidia is this, and ENVYCONTROL
	"dkms"
	"nvidia-utils"
	"xorg-xinit"
	"xorg-server"
	"libva-nvidia-driver"
	#
    # Help packages with desktop integration / file-picker
    #
    "xdg-utils"
    "flatpak-xdg-utils"
    "xdg-desktop-portal-gtk"
    "xdg-user-dirs-gtk"
    #
    # Package management
    #
    "fwupd"
    "iucode-tool"
    "lxappearance" # For managing cursor and GTK Themes
    "intel-ucode"
    "amd-ucode"
    #
    # Spell-checking
    #
    "dictd" # Online use - has synonyms as well.
    "power-profiles-daemon"
    "gstreamer"
    "mythes"
    "gvfs" # Ensure -afc and -mpt (goes at the end of package name, are installed as well)
    "gvfs-mtp"
    "android-file-transfer"
    "power-profiles-daemon"
    "hunspell-en_gb"
    #
    # Others
    #
    "polkit"
    "imagemagick"
    "ffmpeg"
    "gtk3"
    "gstreamer-vaapi"
    "gst-plugins-good"
    "gst-plugins-bad"
    "gst-plugins-ugly"
    "gst-plugins-base"
    #
    # Fonts - Redundancy, but keep it here for a while
    #
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "ttf-liberation"
    "ttf-dejavu"
    "ttf-roboto"
    "ttf-ubuntu-mono-nerd"
    "ttf-ubuntu-font-family"
    "ttf-nerd-fonts-symbols-mono"
)


# Main package manager
for i in "${!pkgs[@]}"; do
    sudo pacman -S --noconfirm "${pkgs[i]}"
done
