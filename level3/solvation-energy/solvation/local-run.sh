#/bin/bash
set -e 

# create folder for analysis
mkdir -p dhdl

export GMX_MAXBACKUP=-1

gmx=/home/simon/Softwares/gromacs-2024.2/build/bin/gmx

# loop on the 21 lambda state
for state in $(seq 0 20)
do
    # create folder for the lambda state
    DIRNAME=lambdastate${state}
    mkdir -p $DIRNAME

    # update the value of init-lambda-state
    newline='init-lambda-state = '$state
    linetoreplace=$(cat inputs/equilibration.mdp | grep init-lambda-state)
    sed -i '/'"$linetoreplace"'/c\'"$newline" inputs/equilibration.mdp
    linetoreplace=$(cat inputs/production.mdp | grep init-lambda-state)
    sed -i '/'"$linetoreplace"'/c\'"$newline" inputs/production.mdp

    ${gmx} grompp -f inputs/equilibration.mdp -c ../preparation/npt.gro -p topol.top -o equilibration -pp equilibration -po equilibration -maxwarn 1
    ${gmx} mdrun -v -deffnm equilibration -nt 8

    ${gmx} grompp -f inputs/production.mdp -c equilibration.gro -p topol.top -o production -pp production -po production -maxwarn 1
    ${gmx} mdrun -v -deffnm production -nt 8

    mv production.* $DIRNAME
    mv equilibration.* $DIRNAME  

    # create links for the analysis
    cd dhdl/
        ln -sf ../$DIRNAME/production.xvg md$state.xvg
    cd ..
done

cd dhdl/
    gmx bar -f *.xvg
cd ..