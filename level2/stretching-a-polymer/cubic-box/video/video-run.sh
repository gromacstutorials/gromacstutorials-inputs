#!/bin/sh
set -e 

export GMX_MAXBACKUP=-1

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

# CUBIC SYSTEM

cp topol-original.top topol.top

${gmx} grompp -f ../inputs/em.mdp -c ../peg.gro -p topol.top -o em-peg
${gmx} mdrun -deffnm em-peg -v -nt 8

${gmx} trjconv -f em-peg.gro -s em-peg.tpr -o peg-recentered.gro -center -pbc mol -box 3 3 3 << EOF
    0
    0
EOF

${gmx} solvate -cp peg-recentered.gro -cs spc216.gro -o peg-solvated.gro -p topol.top

${gmx} grompp -f ../inputs/em.mdp -c peg-solvated.gro -p topol.top -o em
${gmx} mdrun -deffnm em -v -nt 8

${gmx} grompp -f ../inputs/nvt-peg-h2o.mdp -c em.gro -p topol.top -o nvt -maxwarn 1
${gmx} mdrun -deffnm nvt -v -nt 8

${gmx} grompp -f ../inputs/npt-peg-h2o.mdp -c nvt.gro -p topol.top -o npt -maxwarn 1
${gmx} mdrun -deffnm npt -v -nt 8

${gmx} grompp -f ../inputs/video.mdp -c npt.gro -p topol.top -o video -maxwarn 1
${gmx} mdrun -deffnm video -v -nt 8

${gmx} trjconv -f video.xtc -s video.tpr -o video.xtc -pbc nojump << EOF
    0
EOF

