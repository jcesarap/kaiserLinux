#!/bin/bash

# --- --- Functions

function notify_power_profile() {
	output=$(powerprofilesctl get)
    graphics=$(envycontrol --query)
	#dunstify "Power Profile: ${output} / ${graphics}"
    monitor_setup=$(cat ~/.config/xrandr/display_config.txt)
    pkill polybar
    if [[ "$monitor_setup" == "dual" ]]; then # If multiple monitors
        polybar -r mybar_internal &
        polybar -r mybar_external &
    else
        polybar -r mybar_internal &
    fi
}

function change_wallpaper_way() {
    wallpaper_dir="~/Dropbox/Kaiser-Linux/Wallpapers"
    random_wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)
    wal -i "$random_wallpaper"
    hyprctl hyprpaper preload "$random_wallpaper"
    hyprctl hyprpaper wallpaper ",$random_wallpaper"
}

function change_wallpaper_xorg() {
    user=$(whoami)
    wallpaper_dir="/home/$user/Dropbox/Kaiser-Linux/Wallpapers"
    random_wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)
    wal -i "$random_wallpaper"
    feh --bg-fill "$random_wallpaper"
    bash "~/Dropbox/Kaiser-Linux/Configs/Public/alacritty/script.sh"
}

function snap_notepads() { # --- Size check
    REPO_PATH="~/Dropbox/Mirror/College"
    # Function to check folder size and emit a warning if it"s larger than 1GB
    check_folder_size() {
      local folder_size=$(du -sb "$REPO_PATH" | cut -f1)
      local max_size=$((1024 * 1024 * 1024)) # 1GB in bytes
      if [ "$folder_size" -gt "$max_size" ]; then
        echo "Snapshots have grown too big - cleanse git repo."
      fi
    }
    # --- Commit
    cd "~/Dropbox/Mirror/College"
    git checkout manual
    git add --all
    current_date=$(date "+%Y-%m-%d %H:%M:%S")
    git commit -m "Auto commit on $current_date"
    dunstify "GIT, Notepads - Successful commit"
}

function gpu_power_profile() {
    # Use proper regular expression for matching export lines
    if [[ "$1" == "nvidia" ]]; then
        ext_display="HDMI-0"
        int_display="eDP-1-1"
        alacritty -e sudo envycontrol -s nvidia --force-comp
    elif [[ "$1" == "hybrid" ]]; then
        ext_display="HDMI-1-0"
        int_display="eDP1"
        alacritty -e sudo envycontrol -s hybrid --force-comp
    else
        ext_display="HDMI-1-0"
        int_display="eDP1"
        alacritty -e sudo envycontrol -s integrated
    fi
    paths=(
        "~/Dropbox/Kaiser-Linux/Configs/Public/i3/config"
        "~/Dropbox/Kaiser-Linux/Configs/Public/polybar/config.ini"
        "~/.config/xrandr/dual.sh"
        "~/.config/xrandr/external.sh"
        "~/.config/xrandr/internal.sh"
    )
    for path in "${paths[@]}"; do
        # Replace external display configurations
        sed -i "s/HDMI-0/${ext_display}/g" "$path"
        sed -i "s/HDMI-1-0/${ext_display}/g" "$path"
        # Replace internal display configurations
        sed -i "s/eDP-1-1/${int_display}/g" "$path"
        sed -i "s/eDP1/${int_display}/g" "$path"
    done
}

# --- --- Array
# Declare, then Populate associative array
# Using Nerd fonts
declare -A main_options=(
    ["         Aplicativos"]="rofi -modi "drun" -show drun"
    ["         Buscador"]="bash ~/Dropbox/Kaiser-Linux/Scripts/rofi/finder.sh"
    ["         Música"]="bash ~/Dropbox/Kaiser-Linux/Scripts/rofi/rofi_music.sh"
    ["         Copiados Fixados"]="bash ~/Dropbox/Kaiser-Linux/Scripts/rofi/clipboard-pins.sh"
    ["         Copiados Anteriores"]="clipmenu"
	["         Wifi"]="/home/bianca/Dropbox/Kaiser-Linux/Scripts/rofi/rofi-wifi-menu.sh" # Switch command to nm-connection-editor if this fails
	["         Bluetooth"]="blueman-manager"
	["         Calculadora Rápida"]="rofi -show calc -modi calc -no-show-match -no-sort > /dev/null"
	["         Captura de Tela / Screenshot"]="flameshot gui"
    # --- DE

	["          Bloquear"]="exec ~/Dropbox/Kaiser-Linux/Scripts/DE/Commands/lock.sh"
	["          Suspender"]="exec ~/Dropbox/Kaiser-Linux/Scripts/DE/Commands/lock.sh && sleep 1 && systemctl suspend"
	["          Data de hoje"]="dunstify "$(date "+%b")" & dunstify "$(date "+%d %a")" & dunstify "$(date +"%H:%M")" "
    ["          Última Notificação"]="dunstctl history-pop"
    # ["          Processos"]="alacritty -e htop --tree"
    ["          Desligar"]="poweroff"
    ["          Reiniciar"]="reboot"
    ["          Log-out"]="i3-msg exit"
    # ["          Sair do Hypr"]="hyprctl dispatch exit"
    ["          Desativar Time-out"]="xset s off" # Only in current session, which is ideal
    # ["          Papel de Parede (Hyprland)"]="change_wallpaper_way"
    ["          Trocar Papel de Parede"]="change_wallpaper_xorg"
    # --- Perfis de Energia
    ["  󱐋        Perfil de Energia -> Verificar"]="notify_power_profile"
    ["  󱐋        Perfil de Energia -> Desempenho"]="powerprofilesctl set performance && notify_power_profile"
    ["  󱐋        Perfil de Energia -> Economia"]="powerprofilesctl set power-saver && notify_power_profile"
    ["  󱐋        Perfil de Energia -> Balanceado"]="powerprofilesctl set balanced && notify_power_profile"
    ["  󱐋        GPU — Nvidia"]="gpu_power_profile nvidia"
    ["  󱐋        GPU — Integrada"]="gpu_power_profile integrated"
    ["  󱐋        GPU — Híbrida"]="gpu_power_profile hybrid"
    # --- yt dl
    ["  󰨜        YT Baixar"]="alacritty -e ~/Dropbox/Kaiser-Linux/Scripts/DE/Functions/ytdl_download_lists.sh"
    ["  󰨜        YT Editar"]="alacritty -e ranger ~/Dropbox/Kaiser-Linux/Scripts/rofi/download_lists/lists"
    # --- Outros
    ["  󰎃        Temporizador"]="alacritty -e bash ~/Dropbox/Kaiser-Linux/Scripts/DE/Functions/timer.sh"
    #["  󰎃        Código muninn"]="code --profile "main" ~/Dropbox"
    #["  󰎃        Código notas"]="code --profile "main" ~/Dropbox/Notes"
    ["  󰎃        Outras opções"]="alacritty -e bash ~/Dropbox/Kaiser-Linux/Scripts/menu.sh"
)


# --- Rofi
selected_option=$(printf "%s\n" "${!main_options[@]}" | LC_ALL=C sort | rofi -dmenu -i)

# Execute the selected option
if [[ -n $selected_option ]]; then
    command="${main_options[$selected_option]}"
    eval "$command"
fi
