#!/bin/bash

export GMX_MAXBACKUP=-1
gmx=/home/simon/Softwares/gromacs-2025.1/build/bin/gmx

# echo -e "Temperature" | ${gmx} energy -f nvt.edr -o nvt-T.xvg

# BASIC
${gmx} rdf -f production.xtc -s production.tpr -o production-rdf-so4-h2o.xvg << EOF
2
4
EOF

${gmx} rdf -f production.xtc -s production.tpr -o production-rdf-na-h2o.xvg << EOF
3
4
EOF

# REFINED 
${gmx} make_ndx -f production.tpr << EOF
a OW1
a S1
q
EOF

${gmx} rdf -f production.xtc -s production.tpr -o production-rdf-OW1-OW1.xvg -n index.ndx << EOF
7
7
EOF

${gmx} rdf -f production.xtc -s production.tpr -o production-rdf-na-OW1.xvg -n index.ndx << EOF
3
7
EOF

${gmx} rdf -f production.xtc -s production.tpr -o production-rdf-so4-OW1.xvg -n index.ndx << EOF
8
7
EOF