#!/bin/bash

# Define the base repo path once
REPO_PATH="/home/simon/Git/GROMACS/main/docs/sphinx/source/tutorials/tutorial1/figures"

# Copy the images to their destinations
cp final-composite.png     "$REPO_PATH/populate-box.png"
cp final-composite-dm.png  "$REPO_PATH/populate-box-dm.png"

echo "✅ Images copied to $REPO_PATH"
