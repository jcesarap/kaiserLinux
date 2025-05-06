#!/bin/bash

set -x

##### ABOUT #####

# Description: Main player file,
# which starts in Rofi config file
# Using mpv for play music
# Developer: ivanvit100 @ GitHub

##### DEPENDENCIES #####
# mpv           ^ v0.37.0
# jq            ^ jq-1.7.1
# Rofi          ^ 
# notify-send   ^ 0.8.3
# socat         ^ 1.8.0.0
# ffmpeg        ^ n6.1.1

##### FLAGS #####
# --offset={{num}}      - additional offset for numbers in menu
# --icon={{way}}        - custom way to notify-send icon
# --notify={{boolean}}  - enable/disable notification
# --np={{way}}          - custom way to support script

#####       #####

##### VARIABLES #####

SCRIPT_NAME="Rofi_Player"
OFFSET=${1#*=}
icon=${2#*=}
notify=${3#*=}
ipc_path="/tmp/mpv-socket-$(date +%s)"
np=${4#*=}

##### SETTING DEFAULT VALUES #####

if [ -z "$OFFSET" ]; then
    OFFSET="20"
fi
if [ -z "$notify" ]; then
    notify=true
fi
if [ -z "$icon" ]; then
    icon="$HOME/Music/logo.png"
fi
if [ -z "$np" ]; then
    np="$HOME/.config/hypr/scripts/notify_player.sh"
fi

##### PLAYLISTS FORMING #####

FORMING(){
    PLAYLISTS=$(find ~/Music -maxdepth 1 -type d -exec basename {} \;)
}

FORMING
PLAYLISTS+=$'\n'"Query"
PLAYLISTS+=$'\n'"Pause"      # New option: Pause
PLAYLISTS+=$'\n'"Resume"     # New option: Resume
PLAYLISTS+=$'\n'"Exit"

##### USER MENU LOGIC #####

SELECTED_PLAYLIST=$(echo -e "$PLAYLISTS" | rofi -dmenu -i -p "Select a playlist")

if [ -z "$SELECTED_PLAYLIST" ]; then
    pkill -f "$SCRIPT_NAME"
    exit 0
fi

##### PAUSE/RESUME FUNCTIONS #####

pause_mpv() {
    pkill -STOP mpv
    notify-send --app-name="$SCRIPT_NAME" --icon="$icon" --expire-time=1500 "Playback Paused"
    exit 0
}

resume_mpv() {
    pkill -CONT mpv
    notify-send --app-name="$SCRIPT_NAME" --icon="$icon" --expire-time=1500 "Playback Resumed"
    exit 0
}

##### HANDLE PAUSE/RESUME SELECTION #####

if [ "$SELECTED_PLAYLIST" = "Pause" ]; then
    pause_mpv
elif [ "$SELECTED_PLAYLIST" = "Resume" ]; then
    resume_mpv
fi

##### SEARCH AND PLAY SONG #####

SEARCH_MUSIC() {
    pkill -f "$SCRIPT_NAME"
    # Create array of all music files with their full paths
    mapfile -t ALL_SONGS < <(find ~/Music -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \))
    
    # Show selection menu with just filenames
    SELECTED_SONG=$(printf '%s\n' "${ALL_SONGS[@]##*/}" | rofi -dmenu -i -p "Search song")
    
    if [ -z "$SELECTED_SONG" ]; then
        exit 0
    fi
    
    # Find the matching full path
    SONG_PATH=""
    for song in "${ALL_SONGS[@]}"; do
        if [[ "$(basename "$song")" == "$SELECTED_SONG" ]]; then
            SONG_PATH="$song"
            break
        fi
    done

    # Debug: Check if SONG_PATH is correct
    echo "Selected song path: $SONG_PATH"

    if [ -n "$SONG_PATH" ] && [ -f "$SONG_PATH" ]; then
        # Escape special characters in path and pass to mpv
        mpv --no-video "$(printf '%q' "$SONG_PATH")" --title="$SCRIPT_NAME" --idle --input-ipc-server="$ipc_path" &
    else
        notify-send --app-name="$SCRIPT_NAME" --expire-time=1500 --icon="$icon" "Song not found: $SELECTED_SONG"
        exit 1
    fi
}

if [ "$SELECTED_PLAYLIST" = "Query" ]; then
    SEARCH_MUSIC
elif [ "$SELECTED_PLAYLIST" = "Exit" ]; then
    exit 0
fi

##### PLAYLIST PLAYBACK #####

playlist(){ 
    pkill -f "$SCRIPT_NAME"
    if [ "$SELECTED_PLAYLIST" = "Music" ]; then
        TRACKS=$(find ~/Music -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \))
    else
        TRACKS=$(find ~/Music/"$SELECTED_PLAYLIST" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \))
    fi
    PLAYLIST=$(mktemp)
    echo "$TRACKS" | shuf > "$PLAYLIST"
    mpv --no-video --playlist="$PLAYLIST" --title="$SCRIPT_NAME" --idle --input-ipc-server="$ipc_path" &
}

##### USAGE #####

trap "rm -f $ipc_path; rm -f $PLAYLIST" TERM INT EXIT

playlist

while [ -e "/proc/$!" ] && [ "$notify" ]; do
    current_file=$(echo '{ "command": ["get_property", "path"] }' | socat - "$ipc_path" | jq -r '.data')
    if [ "$current_file" == null ]; then
        continue
    fi
    if [ "$current_file" != "$previous_file" ]; then
        metadata=$(echo '{ "command": ["get_property", "metadata"] }' | socat - "$ipc_path" | jq -r '.data')
        title=$(echo "$metadata" | jq -r '."title"')
        artist=$(echo "$metadata" | jq -r '."artist"')
        if [ "$title" == null ]; then
            title=$(echo '{ "command": ["get_property", "media-title"] }' | socat - "$ipc_path" | jq -r '.data')
            if [ "$title" == null ]; then
                title=$(basename $current_file)
            fi
        fi
        if [ "$artist" == null ]; then
            artist="$SCRIPT_NAME"
        fi
        if [[ $current_file =~ ^/ ]]; then
            ffmpeg -i "$current_file" -an -codec:v copy /tmp/rofi_player_cover.jpg
            file_type=$(file --mime-type -b "/tmp/rofi_player_cover.jpg")
            if [[ $file_type == image/* ]]; then
                notify-send --app-name="$artist" --icon=/tmp/rofi_player_cover.jpg --expire-time=1500 "$title"
            else
                notify-send --app-name="$artist" --icon="$icon" --expire-time=1500 "$title"
            fi
        else
            notify-send --app-name="$artist" --icon="$icon" --expire-time=1500 "$title"
        fi
        previous_file=$current_file
    fi
    rm -f /tmp/rofi_player_cover.jpg
    sleep 1
done
