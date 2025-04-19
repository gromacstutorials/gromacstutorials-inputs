#!/bin/bash

# Config
SPACING=80

# Function to assemble a composite image from 3 panels
assemble_panels () {
  local conf=$1
  local na=$2
  local so4=$3
  local output=$4

  echo "🔧 Assembling: $output"

  # Step 1: Create vertical spacer
  convert -size 1x${SPACING} xc:none spacer-v.png

  # Stack Na and SO4 vertically with spacer
  convert -background none -gravity center \
    "$na" spacer-v.png "$so4" -append right-stack.png

  # Step 2: Get height of conf panel
  height=$(identify -format "%h" "$conf")

  # Resize right stack to match conf height
  convert right-stack.png -resize x${height} right-stack-resized.png

  # Step 3: Create horizontal spacer
  convert -size ${SPACING}x${height} xc:none spacer-h.png

  # Step 4: Compose final image
  convert -background none -gravity center \
    "$conf" spacer-h.png right-stack-resized.png +append "$output"

  echo "✅ Created $output"
}

# Assemble dark mode version
assemble_panels conf-dm.png Na-dm.png SO4-dm.png final-composite-dm.png

# Assemble light mode version
assemble_panels conf.png Na.png SO4.png final-composite.png