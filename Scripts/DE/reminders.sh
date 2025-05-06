#!/bin/bash
# Mnemonics to shebang: comment, !shebang, path to bash

# To CRUD: Add a Declaration, Update, Difference/Comparisson, Update read and write option (here in the script).

if [[ "$1" == "write" ]]; then # Mark as done for the cycle
    printf "\n # Reminders \n 1) Uza \n 2) Draw (1 thing (E.g., body part) a day) \n"
    read -p " Which you want to mark as done: " option
    case "$option" in
        1)
            sed -i '/^uza:/s/:.*/:'"$(date +%s)"'/' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt
            ;;
        2)
            sed -i '/^draw:/s/:.*/:'"$(date +%s)"'/' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt
            ;;
        *)
            command ...
            ;;
    esac
else # Cyclical reminders
    # --- Declaration
    uza_interval=86400 # Daily reminder, with snooze option
    draw_interval=86400
    # --- General use
    current_date=$(date +%s) # Current date since Unix Epoch
    # --- Update
    last_uza=$(grep '^uza:' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt | awk -F ':' '{print $2}')
    last_draw=$(grep '^draw:' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt | awk -F ':' '{print $2}')
    # --- Difference/Comparisson
    uza_dif=$((current_date - last_uza))
    draw_dif=$((current_date - last_draw))
    # Update Read
    if [ "$uza_interval" -lt "$uza_dif" ]; then
        dunstify -u critical "Uza practise is pending"
    fi
    if [ "$draw_interval" -lt "$draw_dif" ]; then
        dunstify -u critical "Drawing practise is pending"
    fi
fi
