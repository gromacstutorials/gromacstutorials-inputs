#!/bin/sh
gmx grompp -f inputs/video.mdp -c video.gro -p topol.top -o video -pp video -po video -maxwarn 2
gmx mdrun -v -deffnm video

gmx trjconv -s video.tpr -f video.xtc -o video.xtc -pbc nojump
