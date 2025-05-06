#!/bin/bash

timeshift-gtk

# Archived
function cli() {
    # Decrypt and CD
    sudo cryptsetup luksOpen /dev/nvme0n1p5 spans
    sudo mkdir -p /mnt/spans/home/ ||:
    sudo mount /dev/mapper/spans /mnt/spans
    cd /mnt/spans

    # --- Selection

    # Function to display free space in GB
    get_free_space() {
        local mountpoint=$1
        df -h "$mountpoint" | awk 'NR==2 {print $4}'
    }
    echo_free_space="- Main: $(get_free_space "/")  Snapshots: $(get_free_space "/mnt/spans")"
    list_timeshift=$(sudo timeshift --list | awk 'NR>=9')
    list_home=$(ls /mnt/spans/home/)

    echo " — Run (firefox -allow-downgrade) if you face any problems"
    read -p " — In another terminal window, 'timeshift --delete' to quickly delete one" reminder


    cat << EOF

    ---		---		SPACE		---		---
        
    $echo_free_space
        

    ---		---		SNAPSHOTS		---		---

    ---		TIMESHIFT
        
    $list_timeshift


    ---		---		OPTIONS		---		---

    EOF

    echo " — KEEP AS MANY SNAPSHOTS AS YOU CAN, THEY'LL BE LIGHT, AS HOME DIR ISN'T ENTIRELY BACKED UP"
    read -p " — Take, restore, manage (home) snapshots? " option


    # --- Flow Functions

    # | Home directory snapshots may take a lot of space, but often times they were precisely what you needed to restore to fix an issue - rendering timeshift useless by lacking them

    function snap() {
        read -p " Name the snapshot: " name
        # --- --- --- --- Timeshift --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
        # --- Redundancy setup
        sudo timeshift --snapshot-device /dev/nvme0n1p5
        sudo timeshift --rsync
        # --- Actual Snapshot
        sudo timeshift --create --comments "$name"
        # --- --- --- --- Home Dir --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
        # The only files that are likely to break a system - the rest you don't need snapshotted
        #sudo rsync -avh "~/.config/" "/mnt/spans/home/$name"
        #sudo rsync -avh "~/.bashrc" "/mnt/spans/home/$name"
        #sudo rsync -avh "~/.bash_profile" "/mnt/spans/home/$name"
        # --- Whole Home Dir
        # sudo mkdir -p "/mnt/spans/home" ||:
        # sudo rsync -avh --delete --exclude="/.local/share/gnome-boxes/" --exclude="/Music/" --exclude="/.trash/" "~/" "/mnt/spans/home/$name"
        # --- Log Last snapshot
        sed -i '/^timeshift:/s/:.*/:'"$(date +%s)"'/' ~/Dropbox/Kaiser-Linux/Assets/cycles-tracker.txt
    }

    function restore() {
        # --- --- --- --- Common --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
        ls /mnt/spans/home/
        read -p " Copy and paste the snapshot name:  " home_name
        # Check if the path exists
        if [ ! -e "/mnt/spans/home/$home_name" ]; then
            echo "Snapshot Mistyped"
            exit 1
        fi
        # --- --- --- --- Home Dir --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
        #sudo rsync -avh "/mnt/spans/home/$name/.config" "~/"
        #sudo rsync -avh "/mnt/spans/home/$name/.bashrc" "~/"
        #sudo rsync -avh "/mnt/spans/home/$name/.bash_profile" "~/"
        # --- Whole Home Dir
        # sudo rsync -avh --delete --exclude="/.local/share/gnome-boxes/" --exclude="/Music/" --exclude="/.trash/" "/mnt/spans/home/$home_name/" "~/"
        # --- --- --- --- Timeshift --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
        sudo timeshift --restore # Selection will be prompted
    }

    # --- Control Flow

    if [ "$option" = "take" ]; then
            snap
        elif [ "$option" = "restore" ]; then
            restore
        elif [ "$option" = "manage" ]; then
            ranger /mnt/spans	
        else
            echo "Invalid option"
    fi


    # --- --- --- --- Reference

    # --- format_and_encrypt
    # sudo umount /dev/sda*
    # sudo fdisk /dev/sda # Press the following to create a partition: g (GPT partition table), n (new partition), Enter (for default values for the whole disk), w (write changes and exit)
    # sudo mkfs.ext4 /dev/nvme0n1p5
    # sudo cryptsetup luksFormat /dev/nvme0n1p5	

    # --- unmount
    # sudo umount /mnt/spans
    # sudo cryptsetup close spans

    # --- Fix broken drive
    # | Device path
     # DEVICE="/dev/mapper/spans"

     # | List of backup superblocks to try
     # BACKUP_SUPERBLOCKS=(32768 98304 163840 229376 294912 819200 884736 1605632 2654208 4096000 7962624 11239424 20480000 23887872)

     # | Function to try fsck with a given superblock
     # try_fsck() {
     #     local sb=$1
     #     echo "Trying superblock at $sb..."
     #     sudo fsck -b $sb $DEVICE
     # }

     # | Try each backup superblock
    #  for sb in "${BACKUP_SUPERBLOCKS[@]}"; do
    #      try_fsck $sb
    #      if [ $? -eq 0 ]; then
    #          echo "Filesystem repaired with superblock $sb."
    #          exit 0
    #      fi
    #  done
    # 
    #  echo "All backup superblocks failed. The filesystem might be unrecoverable or not ext2/ext3/ext4."

     # | Optionally, re-create the filesystem if repair fails and data is not needed
     # read -p "Do you want to re-create the filesystem? (This will erase all data) [y/n]: " choice
     # if [ "$choice" == "y" ]; then
     #     echo "Re-creating filesystem on $DEVICE..."
     #     sudo mkfs.ext4 $DEVICE
     #     echo "Filesystem created successfully."
     # else
     #     echo "Re-creation of filesystem aborted. Please investigate further or seek data recovery options."
     # fi
}
