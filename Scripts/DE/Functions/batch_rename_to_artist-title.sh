#!/bin/bash

# Script to rename mp3 and m4a files to "Artist - Title" format based on metadata

MUSIC_DIR="~/Music"

# Check requirements
if ! command -v ffprobe &> /dev/null; then
    echo "ffprobe (part of ffmpeg) is required but not installed. Please install ffmpeg first."
    echo "On Ubuntu/Debian: sudo apt install ffmpeg"
    echo "On Fedora: sudo dnf install ffmpeg"
    echo "On Arch: sudo pacman -S ffmpeg"
    exit 1
fi

# Enhanced filename sanitization
sanitize() {
    local s="${1?Need a string}"
    # Remove control characters
    s=$(echo "$s" | tr -d '\n\r\t' | sed -e 's/[[:cntrl:]]//g')
    # Replace forbidden characters with dash
    s=$(echo "$s" | sed -e 's/[<>:"/\\|?*]/~/g' -e 's/~\+/-/g' -e 's/^-//' -e 's/-$//')
    # Trim whitespace and collapse multiple dashes
    s=$(echo "$s" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/-\+/-/g')
    echo "$s"
}

# Process files safely with spaces/special chars
while IFS= read -r -d '' file; do
    # Extract metadata efficiently
    artist=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file")
    title=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$file")

    # Sanitize and validate
    artist=$(sanitize "$artist")
    title=$(sanitize "$title")
    
    if [[ -z "$artist" || -z "$title" ]]; then
        echo "Skipping $file - missing metadata"
        continue
    fi

    # Get file components
    extension="${file##*.}"
    dir=$(dirname "$file")
    new_name="$dir/${artist} - ${title}.${extension}"

    # Check for existing file and rename
    if [[ "$file" != "$new_name" ]]; then
        if [[ -e "$new_name" ]]; then
            echo "Conflict: $new_name already exists - skipping"
        else
            echo "Renaming: ${file##*/} -> ${new_name##*/}"
            mv -n "$file" "$new_name"
        fi
    fi
done < <(find "$MUSIC_DIR" -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -print0)

echo "Renaming complete!"
