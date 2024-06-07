#!/bin/sh
set -e 

export GMX_MAXBACKUP=-1

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

# ELONGATED SYSTEM

cp topol-original.top topol.top

${gmx} grompp -f inputs/em.mdp -c peg.gro -p topol.top -o em-peg
${gmx} mdrun -deffnm em-peg -v -nt 8

${gmx} trjconv -f em-peg.gro -s em-peg.tpr -o peg-elongated.gro -center -pbc mol -box 6 2.6 2.6 << EOF
    0
    0
EOF

${gmx} solvate -cp peg-elongated.gro -cs spc216.gro -o peg-solvated.gro -p topol.top

${gmx} grompp -f inputs/em.mdp -c peg-solvated.gro -p topol.top -o em -maxwarn 1
${gmx} mdrun -deffnm em -v -nt 8

${gmx} grompp -f inputs/nvt-peg-h2o.mdp -c em.gro -p topol.top -o nvt -maxwarn 1
${gmx} mdrun -deffnm nvt -v -nt 8

${gmx} grompp -f inputs/npt-peg-h2o.mdp -c nvt.gro -p topol.top -o npt -maxwarn 1
${gmx} mdrun -deffnm npt -v -nt 8

${gmx} make_ndx -f nvt.gro -o index.ndx << EOF
    a 82
    a 5
    name 6 End1
    name 7 End2
    q
EOF

${gmx} grompp -f inputs/stretching-peg-h2o.mdp -c npt.gro -p topol.top -o stretching -n index.ndx
${gmx} mdrun -deffnm stretching -v -nt 8

#${gmx} grompp -f inputs/production-peg-h2o.mdp -c stretching.gro -p topol.top -o production -n index.ndx
#${gmx} mdrun -deffnm production -v -nt 8

${gmx} trjconv -f stretching.xtc -s stretching.tpr -o stretching-centered.xtc -center -pbc mol << EOF
    2
    0
EOF

${gmx} mk_angndx -s stretching.tpr -hyd no
${gmx} angle -n angle.ndx  -f stretching-centered.xtc -od angle-distribution.xvg -binwidth 0.25 << EOF
    0
EOF