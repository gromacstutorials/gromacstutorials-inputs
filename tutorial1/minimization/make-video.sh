#!/bin/bash
set -e  # Stop on error

# Define your image pairs (format: left_prefix:right_prefix)
PAIRS=("SO4:Na" "SO4-dm:Na-dm")

# Helper: detect background color
detect_bg() {
    [[ "$1" == *-dm || "$1" == "dark" ]] && echo "black" || echo "white"
}

# Step 1: Convert and make transparent
process_frames() {
    folder="$1"
    prefix="$2"
    bg_color=$(detect_bg "$prefix")
    echo "Processing $prefix frames from $folder (bg: $bg_color)"

    for f in "$folder"/${prefix}.*.ppm; do
        [ -f "$f" ] || continue  # skip if no files match
        convert "$f" -transparent "$bg_color" -fuzz 10% "${f%.ppm}_transparent.png"
    done
}

# Step 2: Compose side-by-side frames
compose_frames() {
    left_folder="$1"
    left_prefix="$2"
    right_folder="$3"
    right_prefix="$4"
    out_dir="$5"
    mkdir -p "$out_dir"

    for l in "$left_folder"/${left_prefix}.*_transparent.png; do
        frame=$(basename "$l" | grep -o '[0-9]\{5\}')
        r="$right_folder/${right_prefix}.${frame}_transparent.png"
        out="$out_dir/frame_${frame}.png"

        if [[ -f "$r" ]]; then
            convert +append "$l" "$r" "$out"
        else
            echo "Warning: Missing right frame $r"
        fi
    done
}

# Step 3: Encode to animated WebP
create_webp() {
    folder="$1"
    name="$2"
    echo "Creating WebP: $name.webp"
    ffmpeg -y -framerate 20 -i "$folder/frame_%05d.png" \
        -loop 0 -lossless 0 -qscale 5 -g 1 "$name.webp"
}

# Step 4: Cleanup
cleanup() {
    echo "Cleaning up..."
    rm -rf composed_frames_*
    for pair in "${PAIRS[@]}"; do
        IFS=":" read LEFT RIGHT <<< "$pair"
        find SO4 Na -name "${LEFT}.*_transparent.png" -delete
        find SO4 Na -name "${RIGHT}.*_transparent.png" -delete
    done
}

for pair in "${PAIRS[@]}"; do
    IFS=":" read LEFT_PREFIX RIGHT_PREFIX <<< "$pair"

    if [[ "$LEFT_PREFIX" == *-dm ]]; then
        OUTPUT_NAME="composition-dm"
    else
        OUTPUT_NAME="composition"
    fi
    OUTPUT_DIR="composed_frames_${OUTPUT_NAME}"

    process_frames "SO4" "$LEFT_PREFIX"
    process_frames "Na" "$RIGHT_PREFIX"
    compose_frames "SO4" "$LEFT_PREFIX" "Na" "$RIGHT_PREFIX" "$OUTPUT_DIR"
    create_webp "$OUTPUT_DIR" "$OUTPUT_NAME"
done

cleanup
