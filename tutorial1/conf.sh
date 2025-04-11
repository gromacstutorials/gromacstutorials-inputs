#!/bin/bash

export GMX_MAXBACKUP=-1
gmx=/home/simon/Softwares/gromacs-2025.1/build/bin/gmx

nb_so4=6
nb_na=$((2 * nb_so4))
nb_h2o=800

${gmx} insert-molecules -ci so4.gro -f empty.gro -o conf.gro -nmol ${nb_so4} -radius 0.5
${gmx} insert-molecules -ci na.gro -f conf.gro -o conf.gro -nmol ${nb_na} -radius 0.5
${gmx} insert-molecules -ci h2o.gro -f conf.gro -o conf.gro -nmol ${nb_h2o} -radius 0.14
