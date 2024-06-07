#!/bin/sh

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

${gmx} grompp -f inputs/production.mdp -c npt.gro -p topol.top -o production -pp production -po production
${gmx} mdrun -v -deffnm production -nt 8

${gmx} convert-trj -f production.xtc -s production.tpr -o production.xtc -dt 1

${gmx} msd -f production.xtc -s production.tpr -o na-msd.xvg << EOF
    3
EOF 

