#!/bin/bash
set -e  # Stop on error

# Function to process a sequence (dark or dark-dm)
process_sequence() {
    prefix="$1"
    echo "Processing: $prefix"

    # Detect background color based on suffix
    if [[ "$prefix" == *-dm ]]; then
        bg_color="black"
    else
        bg_color="white"
    fi

    # Convert PPM to PNG (raw)
    for f in ${prefix}.*.ppm; do
        convert "$f" "${f%.ppm}.png"
    done

    # Remove background & add alpha
    for f in ${prefix}.*.png; do
        convert "$f" -transparent "$bg_color" -fuzz 10% "${f%.png}_transparent.png"
    done

    # Resize to 50%
    for f in ${prefix}.*_transparent.png; do
        convert "$f" -resize 45% "$f"
    done

    # Create movie
    [ -f "${prefix}.webp" ] && rm "${prefix}.webp"
    ffmpeg -framerate 20 -i "${prefix}.%05d_transparent.png" \
        -loop 0 -lossless 0 -qscale 5 -g 1 "${prefix}.webp"

    # Cleanup
    rm ${prefix}.*.png
    convert ${prefix}.00000.ppm ${prefix}.png
}

# Run for both light and dark
process_sequence "avatar"
process_sequence "avatar-dm"
