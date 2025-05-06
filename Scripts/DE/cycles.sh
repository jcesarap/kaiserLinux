#!/bin/bash

function prevent_multiple_instances() {
    # Checker
    if [ -f "/tmp/12h_lock.txt" ]; then
        exit 0
    fi
    # Create tmp file
    touch /tmp/12h_lock.txt
}

function snapshot_10m() {
    rsync -avh --delete "~/Dropbox/Notes/" "~/.Snapshots/Automated/Notes/"
    rsync -avh --delete "~/Dropbox/Glyphi/" "~/.Snapshots/Automated/Glyphi/"
    sed -i '/^10m:/s/:.*/:'"$(date +%s)"'/' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt
    # Notify Discharging
    power=$(upower -d | grep -v "ignored" | grep "percentage:" | head -n 1 | awk '{print $2}' | tr -d '%') # Get power percentage, remove the '%' sign, and convert to an integer
    power=$(echo "$power" | xargs)  # Trim any whitespace
    battery_threshold=70
    if [ "$power" -lt "$battery_threshold" ]; then
        dunstify -u critical -t 1500 "Discharging battery at $power%"
    else
        printf " "
    fi
}

function snapshot_30m() {
    rsync -avh --delete "~/Dropbox/" "~/.Snapshots/Automated/Dropbox/" # By extension another backup layer notes and glyphi
    sed -i '/^30m:/s/:.*/:'"$(date +%s)"'/' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt
    # dunstify "30m Snapshot Taken" # Temporary notification for ensuring execution
    # --- Check for file conflicts
    SEARCH_DIR="~/Dropbox"
    find "$SEARCH_DIR" -type f -iname "*conflict*" -print | while read -r file; do
        echo "Found: $file"
    done
    count=$(find "$SEARCH_DIR" -type f -iname "*conflict*") # wc is a counter
    if echo $count | grep -q "conflict"; then
        dunstify "There are file conflicts - use ranger's fzf to find them"
    fi
}

function extra() {
    # --- --- Trimming --- --- 
    dirs=(
        "~/Dropbox/Glyphi/Litill/Configs/Calendar"
        "~/Dropbox/Glyphi/Litill/Configs/AudioAnchor"
        "~/Dropbox/Glyphi/Litill/Configs/AntennaPod"
    )
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir" || :
        find "$dir" -maxdepth 1 -type f -printf '%T@ %p\n' | sort -n | head -n -2 | cut -d' ' -f2- | xargs rm -f
    done
	# Package lists
    dirs=(
		"~/Dropbox/Kaiser-Linux/Assets/PkgList/pacman"
	    "~/Dropbox/Kaiser-Linux/Assets/PkgList/flatpak"
    	"~/Dropbox/Kaiser-Linux/Assets/PkgList/nix"
    )
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir" || :
        find "$dir" -maxdepth 1 -type f -printf '%T@ %p\n' | sort -n | head -n -9 | cut -d' ' -f2- | xargs rm -f
		find "$dir" -mtime +1 -exec rm {} \; # Delete files older than a day - which is okay here, opposed to above, because these files are always being generate
    done
    # Purge
    find "~/.trash/" -type f -mtime +30 -delete
    rm -r ~/.var/app/io.typora.Typora/config/Typora/draftsRecover/*
    rm ~/nohup.out ||:
    # --- --- List Songs --- --- 
    bash ~/Dropbox/Kaiser-Linux/Scripts/DE/Functions/list_music_dir.sh
}


function sensitive_snaps_via_git() {
    # Paths to snapshots with git
    dirs=(
        "~/.Snapshots/Automated/Dropbox/"
    )
    for dir in "${dirs[@]}"; do
        cd "$dir" || continue  # Exit the loop if cd fails

        # Configure Git user details
        git config user.username "kaiser"
        git config user.email "jkaisermp@protonmail.com"

        # Initialize repository if not exists
        git init

        # Check if 'automatic' branch exists
        if git rev-parse --verify automatic &>/dev/null; then
            # Trim history older than 10 days
            git checkout --orphan new-branch
            git commit --allow-empty -m "Fresh start preserving last 10 days"

            # Get recent commits and cherry-pick if any exist
            recent_commits=$(git rev-list --reverse --after="10 days ago" automatic)
            if [ -n "$recent_commits" ]; then
                git cherry-pick $recent_commits
            fi

            # Clean up old branch and optimize repo
            git branch -D automatic
            git branch -m automatic
            git gc --prune=now --aggressive
        else
            # Create initial branch structure
            git checkout --orphan automatic
            git commit --allow-empty -m "Initial snapshot commit"
        fi

        # Add latest changes and commit
        git checkout automatic -f
        if [[ "$dir" == "~/.Snapshots/Automated/Dropbox/" ]]; then
            git add .  # Add all files in current directory
        else
            git add --all
        fi
        git commit -m "Auto commit: $(date "+%Y-%m-%d %H:%M:%S")"
        dunstify "Git snapshot successful"
    done
}

function snapshot_12h() {
    prevent_multiple_instances
    dunstify -t 2000 -u critical "Running 12h cycle"
    extra
    # 12 hours — By using rsync with this setting, you use less power/battery with snapshots - syncthing also transfers less data, less prone to errors
    rsync -avh --delete "~/Music/" "~/.Snapshots/Automated/12h/Music/"
    rsync -avh --delete "~/Dropbox/" "~/.Snapshots/Automated/12h/Dropbox/"
    rsync -avh --delete "~/.minecraft/saves/New World (1)" "~/Dropbox/Kaiser-Linux/Assets/minecraft-worlds"
    sed -i '/^12h:/s/:.*/:'"$(date +%s)"'/' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt
	# find ~/Dropbox/ ! -user $USER -exec sudo chown $USER:$USER "{}" \; # Fix dropbox permission error
    sensitive_snaps_via_git
    dunstify "12h cycle done"
    # Check Security
    if arch-audit | grep -q "critical"; then
        dunstify -u critical "Security Breaches Found - Update your system" && dunstify -u critical "Security Breaches Found - Update your system" && dunstify -u critical "Security Breaches Found - Update your system"
    fi
    rm /tmp/12h_lock.txt
}

function calculate_cycles() {
    # Interval - Minutes converted to seconds
    timeshift_interval=86400 # 24 * 60 = 1440, * 60 = 
    _10m_interval=600
    _30m_interval=1800
    _12h_interval=43200
    _3_mo_interval=7890048
    # Retrieve - in seconds
    current_date=$(date +%s) # Current date since Unix Epoch
    last_timeshift=$(grep '^timeshift:' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt | awk -F ':' '{print $2}')
    last_10m=$(grep '^10m:' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt | awk -F ':' '{print $2}')
    last_30m=$(grep '^30m:' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt | awk -F ':' '{print $2}')
    last_12=$(grep '^12h:' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt | awk -F ':' '{print $2}')
    last_3_mo=$(grep '^3 months:' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt | awk -F ':' '{print $2}')
    # Can not start with a number
    timeshift_difference=$(((current_date - last_timeshift)))
    _10m_difference=$(((current_date - last_10m)))
    _30m_difference=$(((current_date - last_30m)))
    _12h_difference=$(((current_date - last_12)))
    _3_mo_difference=$(((current_date - last_3_mo)))
    # Time difference must be larger than interval
    if [ "$timeshift_interval" -lt "$timeshift_difference" ]; then
        # dunstify -u critical -t 2000 "Snapshot recommended"
        printf " "
    fi
    if [ "$_10m_interval" -lt "$_10m_difference" ]; then
        nohup ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh 10m > /dev/null 2>&1 & # Notification messages at end of cycles, work as error-handling
    fi
    if [ "$_30m_interval" -lt "$_30m_difference" ]; then
        nohup ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh 30m > /dev/null 2>&1 & # Notification messages at end of cycles, work as error-handling
    fi
    if [ "$_12h_interval" -lt "$_12h_difference" ]; then
        nohup ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh 12h > /dev/null 2>&1 & # Notification messages at end of cycles, work as error-handling
    fi
    if [ "$_3_mo_interval" -lt "$_3_mo_difference" ]; then
        nohup ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh three_months > /dev/null 2>&1 & # Notification messages at end of cycles, work as error-handling
    fi
}

# Test function for displaying time difference between tasks
function echo() {
    clear
    calculate_cycles
    # Make it readable - seconds to minutes (or hours)
    timeshift_difference=$(((current_date - last_timeshift)  / 3600))
    _10m_difference=$(((current_date - last_10m)  / 60))
    _30m_difference=$(((current_date - last_30m) / 60))
    _12h_difference=$(((current_date - last_12) / 3600))
    # Echo
    printf "\n — Timeshift "$timeshift_difference"h \n — 10m "$_10m_difference"m \n — 30m "$_30m_difference"m \n — 12h "$_12h_difference"h \n\n"
    read -p '  Enter to close' 
}

function three_months() {
    cd ~/Dropbox/Kaiser-Linux/Assets/PkgList/
    find flatpak nix pacman update_log -mindepth 1 -delete 2>/dev/null
    dunstify "3 month cycle ran"
    sed -i '/^3 months:/s/:.*/:'"$(date +%s)"'/' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt
}

function logPkgs() {
    dnf list | tee "~/Dropbox/Kaiser-Linux/Assets/PkgList/pacman/$(date +"%d_of_%b_at_%H-%M").txt" # It's key that this keeps log of versions as it already does
	flatpak list | tee "~/Dropbox/Kaiser-Linux/Assets/PkgList/flatpak/$(date +"%d_of_%b_at_%H-%M").txt"
	nix-env -q | tee "~/Dropbox/Kaiser-Linux/Assets/PkgList/nix/$(date +"%d_of_%b_at_%H-%M").txt"
}

function bash_to_nvim() {
    # Managing log file
    b_to_nvim="~/.bash_to_nvim"
    cp "${b_to_nvim}.txt" "${b_to_nvim}-backup.txt"
    truncate -s 0 "${b_to_nvim}.txt"
}

# --- --- Control Flow
#
# CREATE 2 MINUTE CYCLE FOR MONITORING TASKS, IT CONSUMES LITTLE RESOURCES TO JUST CONSULT TEMP AND NOTIFY IF HIGHER
#
if [[ "$1" == "calculate_cycles" ]]; then
    calculate_cycles
elif [[ "$1" == "10m" ]]; then
    #bash_to_nvim
    #snapshot_10m
elif [[ "$1" == "30m" ]]; then
	#snapshot_30m
	logPkgs
	dropbox & # Redundancy
elif [[ "$1" == "12h" ]]; then
	#snapshot_12h
elif [[ "$1" == "three_months" ]]; then
    three_months
else
    echo "Invalid argument."
fi
