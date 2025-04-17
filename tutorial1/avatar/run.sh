#!/bin/bash

export GMX_MAXBACKUP=-1
gmx=/home/simon/Softwares/gromacs-2025.1/build/bin/gmx

${gmx} grompp -f ../inputs/avatar.mdp -c conf.gro -o avatar -pp avatar -po avatar -maxwarn 1
${gmx} mdrun -v -deffnm avatar -nt 8

${gmx} trjconv -s avatar.tpr -f avatar.xtc -o avatar-mol.xtc -pbc mol  << EOF
0
0
EOF
mv avatar-mol.xtc avatar.xtc
