#!/bin/bash

l=12             # Nanotube length [nm]
n=52             # Number of groups
ne=2;            # Number of groups to exclude at the ends
file="./_POST-PROCESSING/Temp.xvg"   # Input file to be processed

tmp=`mktemp -d`

# MEAN TEMPERATURE

# clean up the xvg file and remove the first column
grep -v '\#' $file | grep -v '\@' | awk '!($1="")' > $tmp/clean.dat 

# compute the mean of the columns
awk '{for(i=1; i<=NF; i++){sum[i]+=$i}} END \
{for(i=1; i<=NF; i++){printf "%d %f\n", i, sum[i]/NR}}' $tmp/clean.dat > $tmp/Tmean.dat

# convert line number to length
awk '{printf "%.30f %.30f\n", $1*'$l/$n', $2}' $tmp/Tmean.dat > Tmean.dat

rm -rf $tmp/*

# THERMAL FLUX

# Temperature at the right end
Tend=$(tail -1 Tmean.dat | awk {'printf "%.30f", $2'})

pi=3.14159265359
xi=$(echo "0.592108e12" | awk {'printf "%.30f", $1'})    # [s^-1]  Nose-Hoover (NH) Friction factor
dof=$(echo "15" | awk {'printf "%.30f", $1*3'})         # [-]     Number of degrees of freedom attached to NH
Kb=$(echo "1.3806e-23" | awk {'printf "%.30f", $1'})    # [J/K]   Boltzmann constant
b=$(echo "0.34e-9" | awk {'printf "%.30f", $1'})        # [m]     Wan der Vaals radius
r=$(echo "0.28e-9" | awk {'printf "%.30f", $1'})        # [m]     Tube cross-section radius

# Area [m^2]
S=$(awk -v pi="$pi" -v r="$r" -v b="$b" 'BEGIN {printf "%.30f", 2.*pi*r*b}')

# Thermal flux
q=$(awk -v xi="$xi" -v dof="$dof" -v Kb="$Kb" -v Tend="$Tend" \
-v S="$S" 'BEGIN {printf "%.30f", -xi*dof*Kb*Tend/S}')

# FIT & PLOT

# remove groups at the ends
awk 'NR>'$ne' && NR<('$n'-'$ne')' Tmean.dat > Tfit.dat

cat << EOF | gnuplot 2> fit.log
f(x) = a*x + b
fit f(x) "Tfit.dat" u 1:2 via a, b
set grid
set xlabel 'CNT length [nm]'
set ylabel 'Mean Temperature [K]'
k = $q/(a*1e9)
set title sprintf("k = %.2f [W/mK]", k)
p "Tmean.dat" u 1:2 t 'MD' w lp pt 7 ps 1, [0:12] f(x) t 'fit'
pause mouse
EOF
