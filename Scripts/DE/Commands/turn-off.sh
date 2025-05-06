#!/bin/bash

printf " ——— TURN OFF / REBOOT MENU ———"
printf "\n Selected Option (change to): $1"
printf "\n Options: \n 1) Integrated \n 2) Hybrid \n 3) [No] (changes) \n"
read -p " Do you want to change power settings for your next boot? " option
case "$option" in
    1)
        sudo envycontrol -s integrated
        ;;
    2)
        sudo envycontrol -s hybrid --force-comp
        ;;
    *) # No changes
        echo "Running $1"
        ;;
esac
case "$1" in
    poweroff)
        poweroff
        ;;
    *) # Reboot
        reboot
        ;;
esac
