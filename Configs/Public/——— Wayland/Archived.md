# Forewords

- Nvidia sucks. Wayland does not support it.
- Avoul - Minimalistic, efficient software. Hacker like.

# Setup

- Packages (yay)
    - rofi-wayland
    - hyprland-scanner-git
    - hyprwayland-scanner
    - hyprland

- Packages
    - python-pyqt5
    - hyprlock
    - wev
    - slurp
    - grim
    - hyprpaper
    - cliphist
    - wl-clipboard
    - waybar
    - xdg-desktop-portal-hyprland

- Configs.sh

- Tweaks
    - Hyprland
        - udo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
        - sudo sed -i '/^MODULES=(/ s/\(.*\))$/\1nvidia_modeset nvidia_uvm)/' /etc/mkinitcpio.conf
        - sudo cp ~/Dropbox/Kaiser-Linux/Assets/DE/nvidia.conf /etc/modprobe.d/
        - sudo mkinitcpio -P
    - Sway - Switch to open-source graphics

- Startup - Should be finally executed by its own file/format, not a shell script
	- pkill -f -e 'i3|Xorg|xinit|xsession' || : # f = all (partial) matching packages; -e = (extended) multiple patterns
	- pkill 'clipnotify|clipmenu|parcellite|xorg-xclipboard' || :
	- cd ~
	- # --- Required Env Var
	- export _JAVA_AWT_WM_NONREPARENTING=1
	- export XCURSOR_SIZE=24
	- export LIBVA_DRIVER_NAME=nvidia
	- export XDG_SESSION_TYPE=wayland
	- export GBM_BACKEND=nvidia-drm
	- export __GLX_VENDOR_LIBRARY_NAME=nvidia
	- export NVD_BACKEND=direct
	- export WLR_NO_HARDWARE_CURSORS=1
	- export QT_QPA_PLATFORMTHEME=qt5ct
