#!/bin/bash

export GMX_MAXBACKUP=-1
gmx=/home/simon/Softwares/gromacs-2025.1/build/bin/gmx

${gmx} grompp -f inputs/min.mdp -o min -pp min -po min -maxwarn 1 # optional -c conf.gro -p topol.top
${gmx} mdrun -v -deffnm min -nt 8

${gmx} grompp -f inputs/nvt.mdp -c min.gro -o nvt -pp nvt -po nvt # optional -p topol.top
${gmx} mdrun -v -deffnm nvt -nt 8

${gmx} grompp -f inputs/npt.mdp -c nvt.gro -o npt -pp npt -po npt # optional -p topol.top
${gmx} mdrun -v -deffnm npt -nt 8

${gmx} grompp -f inputs/production.mdp -c npt.gro -o production -pp production -po production # optional -p topol.top
${gmx} mdrun -v -deffnm production -nt 8
