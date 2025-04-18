#!/bin/bash
set -e  # Stop on error

# Function to process a sequence (dark or light)
process_sequence() {
    prefix="$1"

    echo "Processing: $prefix"

    # Convert PPM to PNG
    for f in ${prefix}.*.ppm; do
    convert "$f" "${f%.ppm}.png"
    done

    # Detect background color
    bg_color="black"
    if [[ "$prefix" == "light" ]]; then
    bg_color="white"
    fi

    # Remove background & add alpha
    for f in ${prefix}.*.png; do
    convert "$f" -transparent "$bg_color" -fuzz 10% "${f%.png}_transparent.png"
    done

    # Resize
    for f in ${prefix}.*_transparent.png; do
    convert "$f" -resize 50% "$f"
    done

    # Create movie
    [ -f "${prefix}.webp" ] && rm "${prefix}.webp"

    ffmpeg -framerate 20 -i "${prefix}.%05d_transparent.png" \
    -loop 0 -lossless 0 -qscale 5 -g 1 "${prefix}.webp"

    # Cleanup PNGs
    rm ${prefix}.*.png
    convert ${prefix}.00000.ppm ${prefix}.png
}

# Run for both dark and light sequences
process_sequence "dark"
process_sequence "light"

