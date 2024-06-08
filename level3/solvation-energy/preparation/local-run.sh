#!/bin/sh
set -e 

export GMX_MAXBACKUP=-1

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

${gmx} trjconv -f FJEW_allatom_optimised_geometry.pdb -s FJEW_allatom_optimised_geometry.pdb -o hbc.gro -box 3.5 3.5 3.5 -center << EOF
	0
	0
EOF

${gmx} grompp -f inputs/min.mdp -c solvated.gro -p topol.top -o min -pp min -po min -maxwarn 1
${gmx} mdrun -v -deffnm min -nt 8
${gmx} grompp -f inputs/nvt.mdp -c min.gro -p topol.top -o nvt -pp nvt -po nvt -maxwarn 1
${gmx} mdrun -v -deffnm nvt -nt 8
${gmx} grompp -f inputs/npt.mdp -c nvt.gro -p topol.top -o npt -pp npt -po npt -maxwarn 1
${gmx} mdrun -v -deffnm npt -nt 8
