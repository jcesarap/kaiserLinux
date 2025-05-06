#!/bin/bash

SOURCE_DIR="~/Music"
DEST_FILE="~/Dropbox/Notes/Lists/b — Music.md"

# Clear existing file and write header
echo "# Complete Music Listing" > "$DEST_FILE"
echo "Generated: $(date)" >> "$DEST_FILE"
echo >> "$DEST_FILE"

# Process files with directory headers
find "$SOURCE_DIR" -type f -print0 | sort -z | while IFS= read -d '' -r file; do
    # Get relative directory path
    dir_path=$(dirname "$file" | sed "s|^$SOURCE_DIR/||")
    
    # Add directory header if new section
    if [[ "$dir_path" != "$current_dir" ]]; then
        [[ -n "$current_dir" ]] && echo >> "$DEST_FILE"
        echo "## $dir_path" >> "$DEST_FILE"
        current_dir="$dir_path"
    fi
    
    # Extract metadata
    artist_title=$(mediainfo --Output="General;%Performer% - %Title%" "$file" 2>/dev/null | tr -d '\n')
    artist_title=$(echo "$artist_title" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    
    # Get filename without path
    filename=$(basename "$file")
    
    # Format line with 10 spaces before filename
    if [[ -n "$artist_title" && "$artist_title" != " - " ]]; then
        printf "  • %s          (%s)\n" "$artist_title" "$filename" >> "$DEST_FILE"
    else
        printf "  • %s\n" "$filename" >> "$DEST_FILE"
    fi
done

echo "Music list updated: $DEST_FILE"
