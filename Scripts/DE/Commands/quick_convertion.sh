#!/bin/bash

convert_images_to_nvim(){
    # Convert all JPG/JPEG files to PNG and move originals to trash
    for file in *.jpg *.jpeg *.JPG *.JPEG; do
        if [ -f "$file" ]; then  # Check if file exists (handles case where no matches)
            # Get the filename without extension
            filename="${file%.*}"
            # Convert to PNG
            magick "$file" "${filename}.png"
            # Move original to trash
            mv "$file" "~/.trash/"
        fi
    done
}

if [[ "$1" == "nvim_img" ]]; then
    convert_images_to_nvim
fi


dunstify "Conversion complete"
