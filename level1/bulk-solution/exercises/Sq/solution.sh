#!/bin/sh

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

${gmx} scattering -f ../../production.xtc -s ../../production.tpr -o scattering-system.xvg <<EOF
    0
EOF

${gmx} scattering -f ../../production.xtc -s ../../production.tpr -o scattering-SO4.xvg <<EOF

    2
EOF

${gmx} scattering -f ../../production.xtc -s ../../production.tpr -o scattering-ions.xvg <<EOF

    6
EOF
