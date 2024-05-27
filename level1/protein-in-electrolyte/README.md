
# Downloaded protein from https://www.rcsb.org/structure/1CTA

# Convert pdb to gro

gmx trjconv -f 1cta.pdb -s 1cta.pdb -o 1cta.gro -center -box 5 5 5
0 
0

# Add force field

gmx pdb2gmx -f 1cta.gro -water spce -v -ignh -o unsolvated.gro
# The Amber03 force field and the spce water model are used.

# Solvated

gmx solvate -cs spc216.gro -cp unsolvated.gro -o solvated.gro -p topol.top

# Minimize energy

gmx grompp -f inputs/mininimize.mdp -c solvated.gro -p topol.top -o min -pp min -po min -maxwarn 1
gmx mdrun -v -deffnm min

# Replaced water molecules by ions

gmx genion -s min.tpr -p topol.top -conc 1 -neutral -o salted.gro
# Select SOL (14)

# NVT energy

gmx grompp -f inputs/nvt.mdp -c salted.gro -p topol.top -o nvt -pp nvt -po nvt -maxwarn 1
gmx mdrun -v -deffnm nvt