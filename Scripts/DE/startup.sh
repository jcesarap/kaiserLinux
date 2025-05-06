#!/bin/bash
# You have a more stable system by having multiple WMs - on Hyprland and on Xorg. Keep them both.

cat << EOF

    1. i3wm
    2. Hyprland - Use Hybrid Graphics, no official Nvidia support

EOF

read -p "Choose DE:  " choice

# Systemd Services - Dropbox, Syncthing, Dunst - No need starting them up here, as they're core services, systemd should run them

# --- --- --- --- --- --- Functions

function hyprland() {
	# --- --- Kill (conflicting) others --- ---  
	# f = all (partial) matching packages; -e = (extended) multiple patterns
	# pkill -f -e 'i3|Xorg|xinit|xsession' || :
	pkill 'clipnotify|clipmenu|parcellite|xorg-xclipboard' || :
	# --- --- Init --- --- 
	# --- Fore-steps
	cd ~
	# --- Required Env Var
	export _JAVA_AWT_WM_NONREPARENTING=1
	export XCURSOR_SIZE=24
	export LIBVA_DRIVER_NAME=nvidia
	export XDG_SESSION_TYPE=wayland
	export GBM_BACKEND=nvidia-drm
	export __GLX_VENDOR_LIBRARY_NAME=nvidia
	export NVD_BACKEND=direct
	export WLR_NO_HARDWARE_CURSORS=1
	export QT_QPA_PLATFORMTHEME=qt5ct
	# --- Exec
	exec Hyprland
}

function i3() {
	# --- --- Kill (conflicting) others --- --- 
	# f = all (partial) matching packages; -e = (extended) multiple patterns
	pkill -f -e 'wayland|hyprland|pkill|hyprlock' || :
	pkill -e 'swaybg|wl-clipboard|xdg-desktop-portal-hyprland|cliphist' || :
	# --- --- Init --- --- 
	# --- Fore-steps
	cd ~
	systemctl --user import-environment DISPLAY # For clipmenud
	# --- Required Env Var
	export GSK_RENDERER=gl # To solve GTK problems on X11/Nvidia
	# export XDG_SESSION_TYPE=x11 # To solve Wayland problem on ranger, on X11
	export XDG_CURRENT_DESKTOP=i3
	# export SESSION_MANAGER=local/$(hostname):@/tmp/.ICE-unix/$(pidof i3)
	export DESKTOP_SESSION=i3
	# --- Exec
	exec dbus-run-session -- i3 # exec i3 # dbus problems solved in the following line
	# --- Services
	picom -b # Can't wait for this to finish, will run on background
	bash "~/.config/xrandr/internal.sh" # Monitor base config
	setxkbmap br # Input
	polybar mybar_internal & # Polybar
	parcellite &
}

# --- --- --- --- --- --- Control Flow

# --- --- Env Var
export DBUS_SESSION_BUS_ADDRESS
export XDG_RUNTIME_DIR=/run/user/$UID
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export XCURSOR_THEME=GoogleDot-Black
export GTK_THEME=Layan-Dark-Solid
export CM_LAUNCHER=rofi # For Clipboard manager
# Setting default text editor
export VISUAL=micro
export EDITOR=micro
# --- --- Options
force_color_prompt=yes

if [ "$choice" == "1" ]; then
    i3
elif [ "$choice" == "2" ]; then
	hyprland
else
    echo "Invalid argument"
	exit 0
fi
