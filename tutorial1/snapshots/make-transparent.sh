#!/bin/bash

for file in *.tga; do
  # Skip if no .tga files are found
  [ -e "$file" ] || continue

  # Get base name without extension
  base="${file%.tga}"

  # Set transparency color
  if [[ "$file" == *-dm.tga ]]; then
    transparent_color="black"
  else
    transparent_color="white"
  fi

  # Convert to PNG with transparency, trim, and double width
convert "$file" \
  -transparent "$transparent_color" \
  -trim +repage \
  -background none \
  "${base}.png"

  #   -gravity center \
  # -extent 120%x100% \

  echo "Converted: $file → ${base}.png"

  [ -e "$base" ] && rm "$base"
done
