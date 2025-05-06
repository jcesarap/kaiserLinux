#!/bin/bash

# Keep the downloads in different folders after done. It helps with quicker sorting, it requires not a different script for videos and mixes
# ...And ranger is pretty quick in moving things out of them manually



echo "Create a .txt list in the relevant path, for each genre - and place the links there"

# Backup lists
mkdir -p "~/.Snapshots/Manual/Download_lists/lists/"
rsync -avh --delete "~/Dropbox/Kaiser-Linux/Scripts/rofi/download_lists/lists" "~/.Snapshots/Manual/Download_lists/lists/"
# All folders/files should stack beneath here, to allow counting for error handling
mkdir ~/Downloads/yt || :
# Download to genre folder & Set genre by folder name - set by start list
for file in ~/Dropbox/Kaiser-Linux/Scripts/rofi/download_lists/lists/*.txt; do
    genre="${file##*/}" # Extract filename from path
    genre="${genre%.txt}" # Remove .txt extension
    mkdir -p "~/Downloads/yt/$genre" || :
    cd "~/Downloads/yt/$genre"
    yt-dlp -x --audio-format mp3 --audio-quality 0 -o '%(title)s.%(ext)s' --batch-file="$file" || :
    # Check if mp3 files exist
    shopt -s nullglob
    mp3_files=(*.mp3)
    if [ ${#mp3_files[@]} -gt 0 ]; then
		# Set genre metadata based on list/folder
        for mp3_file in *.mp3; do
            id3v2 --TCON "$genre" "$mp3_file"
        done
    else
        echo "No .mp3 files found in the directory for genre $genre" >&2
    fi
done
# --- --- Check for errors
# Count lines on lists - each corresponds to an download
total_lines=0
for file in "~/Dropbox/Kaiser-Linux/Scripts/rofi/download_lists/lists"*.txt; do
if [ -f "$file" ]; then
    lines=$(wc -l < "$file")
    total_lines=$((total_lines + lines))
fi
done
dunstify "$total_lines files marked for download"
# Count files downloaded
download_count=$(find "~/Downloads/yt/" -type f | wc -l)
dunstify "$download_count files were downloaded"
# --- --- Clean all lists
for file in ~/Dropbox/Kaiser-Linux/Scripts/rofi/download_lists/lists/*.txt; do
    > "$file"
done

read -p "Run (to equalise title/filename, having one less field to edit): "
