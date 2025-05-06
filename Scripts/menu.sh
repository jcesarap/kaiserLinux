#!/bin/bash

# System Tasks - Necessary even without DE

cat << EOF

# CLI Menu
# Options

    1. System Setup Script
    2. Snapshots (Timeshift)
    3. Snapshots (Check Cycles)
    4. Snapshots (Manual)
    5. Update
    6. Exit

# Reference
    - m: Menu
    - d: Marking Reminders as Done
    - r: Ranger
    - s: FZF Search 
    - i: Convert images in directory to Neovim's markdown compatible

EOF

read -p "  What do you want to run: " choice

case $choice in
        1)
            echo " Selected [ Option $choice ]"
            sudo bash ~/Dropbox/Kaiser-Linux/Scripts/setup.sh
            ;;
        2)
            echo " Selected [ Option $choice ]"
            bash ~/Dropbox/Kaiser-Linux/Scripts/DE/Functions/snap.sh
            ;;
        3)
            echo "Selected [ Calculate and echo pending cycles ]"
            bash ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh echo
            clear
            ;;
        4)
            read -p "Choose the name of the Snapshot: " option
            target_dir="~/.Snapshots/Manual/$option/"
            # Remove the directory if it exists & Create new
            rm -rf "$target_dir" || : && mkdir -p "$target_dir" || :
            # Synchronize files to the new directory
            rsync -avh --delete "~/Dropbox/" "/$target_dir/"
            ;;
        5)
	    echo "Empty stdin means there are none."
	    printf "\n --- DO YOU WANT TO REMOVE ORPHAN PACKAGES? --- \n\n" && pacman -Qtdq | sudo pacman -Rns - 
            echo "-------------"
            echo " UPDATE"
            echo "-------------"

            ~/Dropbox/Kaiser-Linux/Scripts/DE/Functions/snap.sh

            flatpak update -y &
            # command1 | tee >(command2)
            # command1 runs, and its output is both displayed and piped to command2.
            sudo pacman -Syu | tee "~/Dropbox/Kaiser-Linux/Assets/PkgList/update_log/$(date '+%a %d, %B - %Y').log"

            sudo fwupdmgr get-devices
            sudo fwupdmgr refresh --force
            sudo fwupdmgr get-updates -y
            sudo fwupdmgr update -y

			yay -Syu

            read -p "Done. Press enter to continue" 
            read -p "..." 
            ;;
        6)
            echo " Selected [ Option $choice ]"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

