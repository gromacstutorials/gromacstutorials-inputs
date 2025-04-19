#!/bin/bash
set -e  # Stop on error

# Define the base repo path once
REPO_PATH="/home/simon/Git/GROMACS/main/docs/sphinx/source/tutorials/tutorial1/figures"

# Copy the images to their destinations
cp composition.webp     "$REPO_PATH/minimisation.webp"
cp composition-dm.webp  "$REPO_PATH/minimisation-dm.webp"

echo "✅ Images copied to $REPO_PATH"
