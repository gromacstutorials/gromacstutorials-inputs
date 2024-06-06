#!/bin/sh

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

${gmx} grompp -f inputs/min.mdp -c conf.gro -p topol.top -o min -pp min -po min
${gmx} mdrun -v -deffnm min -nt 8

${gmx} grompp -f inputs/nvt-minimalist.mdp -c min.gro -p topol.top -o nvt-minimalist -pp nvt-minimalist -po nvt-minimalist
${gmx} mdrun -v -deffnm nvt-minimalist -nt 8

${gmx} grompp -f inputs/nvt.mdp -c min.gro -p topol.top -o nvt -pp nvt -po nvt
${gmx} mdrun -v -deffnm nvt -nt 8

${gmx} grompp -f inputs/npt.mdp -c nvt.gro -p topol.top -o npt -pp npt -po npt
${gmx} mdrun -v -deffnm npt -nt 8

${gmx} grompp -f inputs/production.mdp -c npt.gro -p topol.top -o production -pp production -po production
${gmx} mdrun -v -deffnm production -nt 8

${gmx} rdf -f production.xtc -s production.tpr -o na-sol-rdf.xvg << EOF
    3
    4
EOF

${gmx} rdf -f production.xtc -s production.tpr -o so4-sol-rdf.xvg << EOF
    2
    4
EOF

${gmx} rdf -f production.xtc -s production.tpr -o sol-sol-rdf.xvg -bin 0.0002 -excl << EOF
    4
    4
EOF

${gmx} msd -f production.xtc -s production.tpr -o so4-msd.xvg << EOF
    2
EOF 

${gmx} msd -f production.xtc -s production.tpr -o na-msd.xvg << EOF
    3
EOF 

${gmx} msd -f production.xtc -s production.tpr -o sol-msd.xvg << EOF
    4
EOF 