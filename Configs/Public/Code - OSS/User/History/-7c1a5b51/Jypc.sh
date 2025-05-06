#!/bin/bash

# --- --- Functions

function notify_power_profile() {
	output=$(powerprofilesctl get)
    graphics=$(envycontrol --query)
	dunstify "Power Profile: ${output} / ${graphics}"
}

function change_wallpaper_way() {
    wallpaper_dir='~/Dropbox/Avíi/Wallpapers/1-Sul-Collection'
    random_wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)
    wal -i "$random_wallpaper"
    hyprctl hyprpaper preload "$random_wallpaper"
    hyprctl hyprpaper wallpaper ",$random_wallpaper"
}

function change_wallpaper_xorg() {
    wallpaper_dir='~/Dropbox/Avíi/Art/Wallpapers/1-Sul-Collection'
    random_wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)
    wal -i "$random_wallpaper"
    feh --bg "$random_wallpaper"
	dunstify "Steel — Vegemor, Fore-dag Logging, Timers"
    bash "~/Dropbox/Kaiser-Linux/Configs/Public/alacritty/script.sh"
}

function snap_notepads() {
    # --- Size check
    REPO_PATH="~/Dropbox/Mirror/College"
    # Function to check folder size and emit a warning if it's larger than 1GB
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
    ["         Apps"]="rofi -modi "drun" -show drun"
    ["         Finder"]="bash ~/Dropbox/Kaiser-Linux/Scripts/rofi/finder.sh"
    ["         Clipboard Pins"]="bash ~/Dropbox/Kaiser-Linux/Scripts/rofi/clipboard-pins.sh"
    ["         YouTube"]="flatpak run io.freetubeapp.FreeTube"
    # --- DE
	["          Date"]="dunstify '$(date '+%b')' & dunstify "$(date '+%d %a')" & dunstify "$(date +'%H:%M')" "
    ["          Last Notification"]="dunstctl history-pop"
    # ["          Processes"]="alacritty -e htop --tree"
    ["          Turn-off"]="poweroff"
    ["          Reboot"]="reboot"
    ["          Exit i3"]="i3-msg exit"
    # ["          Exit Hypr"]="hyprctl dispatch exit"
    ["          Time-out - Disable"]="xset s off" # Only in current session, which is ideal
    # ["          Wallpaper (Hyprland)"]="change_wallpaper_way"
    ["          Wallpaper"]="change_wallpaper_xorg"
    ["          Git Snapshot Notepads"]="snap_notepads"
    ["          Workspaces"]="i3-msg -t get_workspaces | jq -r '.[].name' | sort | rofi -dmenu -p "Select Workspace" | xargs -I {} i3-msg workspace "{}""
    # --- Power Profiles
    ["  󱐋        Profile - Check"]="notify_power_profile"
    ["  󱐋        Profile - Performance"]="powerprofilesctl set performance && notify_power_profile"
    ["  󱐋        Profile - Power save"]="powerprofilesctl set power-saver && notify_power_profile"
    ["  󱐋        Profile - Balanced"]="powerprofilesctl set balanced && notify_power_profile"
    ["  󱐋        GPU — Nvidia"]="gpu_power_profile nvidia"
    ["  󱐋        GPU — Integrated"]="gpu_power_profile integrated"
    ["  󱐋        GPU — Hybrid"]="gpu_power_profile hybrid"
    # --- yt dl
    ["  󰨜        YT Download"]="alacritty -e ~/Dropbox/Kaiser-Linux/Scripts/DE/Functions/ytdl_download_lists.sh"
    ["  󰨜        YT Edit"]="alacritty -e ranger ~/Dropbox/Kaiser-Linux/Scripts/rofi/download_lists/lists"
    # --- Shortcuts
    ["  󱞳        Axioms of Practise"]="alacritty -e nvim '~/Dropbox/Notes/Arts/Music/—— Axioms/of Practise.md'"
    ["  󱞳        Templates"]="alacritty -e ranger '~/Dropbox/—— Archive/Templates'"
    ["  󱞳        Mirror Clip"]="alacritty -e micro ~/Dropbox/Archive/Mirror/clipboard.md"
    ["  󱞳        Diary"]="alacritty -e micro ~/Dropbox/Notes/Versa/Diaries/Diary.md"
    # --- Others
    ["  󰎃        Timer"]="alacritty -e bash ~/Dropbox/Kaiser-Linux/Scripts/DE/Functions/timer.sh"
    #["  󰎃        Code muninn"]="code --profile "main" ~/Dropbox"
    #["  󰎃        Code notes"]="code --profile "main" ~/Dropbox/Notes"
    ["  󰎃        Other options"]="alacritty -e bash ~/Dropbox/Kaiser-Linux/Scripts/menu.sh"
)

# --- Rofi
selected_option=$(printf "%s\n" "${!main_options[@]}" | LC_ALL=C sort | rofi -dmenu -i)

# Execute the selected option
if [[ -n $selected_option ]]; then
    command="${main_options[$selected_option]}"
    eval "$command"
fi
