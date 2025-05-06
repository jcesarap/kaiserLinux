#!/bin/bash

monitor=$1

universal() {
    pkill polybar
    # dunstify "${monitor} Monitor(s) - press press twice for double monitors" -t 800
    xrdb -merge ~/.Xresources # Ensure stable mouse size though different monitor pixel density
}

wacom_to_external_monitor() {
    xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput 1920x1080+0+0 &
    xsetwacom set "Wacom Intuos S Pad pad" MapToOutput 1920x1080+0+0 &
    xsetwacom --set "Wacom Intuos S Pen stylus" Mode "Absolute" &
}

wacom_to_internal_monitor() {
    xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput 1920x1080+0+1080 &
    xsetwacom set "Wacom Intuos S Pad pad" MapToOutput 1920x1080+0+1080 &
    xsetwacom --set "Wacom Intuos S Pen stylus" Mode "Absolute" &
}

wacom_to_internal_monitor_only() {
    xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput 1920x1080+0+0 &
    xsetwacom set "Wacom Intuos S Pad pad" MapToOutput 1920x1080+0+0 &
    xsetwacom --set "Wacom Intuos S Pen stylus" Mode "Absolute" &
}

case "$1" in
    Internal)
        echo "internal" > ~/.config/xrandr/display_config.txt
        universal
        bash "~/.config/xrandr/internal.sh"
        polybar -r mybar_internal
        # Log
        ;;
    Dual)
        echo "dual" > ~/.config/xrandr/display_config.txt
        universal
        bash "~/.config/xrandr/dual.sh"
        polybar -r mybar_external # Polybar handles one bar per monitor
        polybar -r mybar_internal
        ;;
    External)
        universal
        bash "~/.config/xrandr/external.sh"
        polybar -r mybar_external
        ;;
    wacom)
        wacom=$(cat ~/.config/xrandr/display_config.txt)
        if [[ "$wacom" == "dual" ]]; then # If multiple monitors
            workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name') # Check which workspace you're on
            if echo "$workspace" | grep -q "1\|2"; then # If 1 or 2, then assign to external monitor
                wacom_to_external_monitor
            else
                wacom_to_internal_monitor
            fi
        else
            wacom_to_internal_monitor_only
        fi
        ;;
    *)
        echo "Invalid argument. Choose between: internal, dual, external (read the script for details). "
        ;;
esac

# Universal - Key-bindings
xsetwacom --set "Wacom Intuos S Pad pad" Button 1 "key alt t" &
xsetwacom --set "Wacom Intuos S Pad pad" Button 2 "key del" &
xsetwacom --set "Wacom Intuos S Pad pad" Button 3 "key ctrl -" &
xsetwacom --set "Wacom Intuos S Pad pad" Button 8 "key ctrl shift +" &
