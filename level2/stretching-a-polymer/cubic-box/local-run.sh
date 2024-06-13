#!/bin/sh
set -e 

export GMX_MAXBACKUP=-1

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

# CUBIC SYSTEM

cp topol-original.top topol.top

${gmx} grompp -f inputs/em.mdp -c peg.gro -p topol.top -o em-peg
${gmx} mdrun -deffnm em-peg -v -nt 8

${gmx} trjconv -f em-peg.gro -s em-peg.tpr -o peg-recentered.gro -center -pbc mol -box 2.6 2.6 2.6 << EOF
    0
    0
EOF

${gmx} solvate -cp peg-recentered.gro -cs spc216.gro -o peg-solvated.gro -p topol.top

${gmx} grompp -f inputs/em.mdp -c peg-solvated.gro -p topol.top -o em
${gmx} mdrun -deffnm em -v -nt 8

${gmx} energy -f em.edr -o energy-em.xvg  << EOF
    7
EOF

${gmx} grompp -f inputs/nvt-peg-h2o.mdp -c em.gro -p topol.top -o nvt -maxwarn 1
${gmx} mdrun -deffnm nvt -v -nt 8

${gmx} energy -f nvt.edr -o energy-nvt.xvg  << EOF
    7
EOF

${gmx} grompp -f inputs/npt-peg-h2o.mdp -c nvt.gro -p topol.top -o npt -maxwarn 1
${gmx} mdrun -deffnm npt -v -nt 8

${gmx} energy -f npt.edr -o energy-npt.xvg  << EOF
    7
EOF

${gmx} grompp -f inputs/production-peg-h2o.mdp -c npt.gro -p topol.top -o production -maxwarn 1
${gmx} mdrun -deffnm production -v -nt 8

${gmx} trjconv -f production.xtc -s production.tpr -o production.xtc -center -pbc mol << EOF
    2
    0
EOF

${gmx} mk_angndx -s production.tpr -hyd no -type dihedral
${gmx} angle -n angle.ndx  -f production.xtc -od dihedral-distribution.xvg -binwidth 0.25 -type dihedral << EOF
    1
EOF

${gmx} grompp -f inputs/video.mdp -c production.gro -p topol.top -o video -maxwarn 1
${gmx} mdrun -deffnm video -v -nt 8
${gmx} trjconv -f video.xtc -s video.tpr -o video.xtc -pbc nojump

