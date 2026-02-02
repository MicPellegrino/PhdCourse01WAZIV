*******************************************************************************
*******************************************************************************
Welcome to the GROMACS exercise for evaluating thermal conductivity of carbon
nanotubes via NEMD method.
*******************************************************************************
*******************************************************************************

Here follows the instructions for running a GROMACS simulation to compute
thermal conductivity of single-wall carbon nanotubes. Provided by the
Multi-Scale Modeling Lab of Politecnico di Torino (Italy).  These resources are
intended for pedagogical purposes, and were designed for the undergraduate
course: "Energy Applications of Materials", taught at Politecnico
di Torino during spring 2023.
 
Matteo Fasano (matteo.fasano@polito.it)    
All rights reserved (2023).
*******************************************************************************


!!!!!!ALL COMMANDS ARE CONTAINED BETWEEN TWO DASHED LINES!!!!!!


*******************************************************************************
0 - MACHINE PREPARATION 
*******************************************************************************

To start the tutorial, let us enter into the tutorial directory:

---------------------
cd /home/labmd/Documents/THERMAL-CNT_exercise1
---------------------

You can check if you correctly moved to the tutorial directory by the command:

---------------------
pwd
---------------------

*******************************************************************************


*******************************************************************************
1 - SETUP PREPARATION 
*******************************************************************************

First of all, what you need is a geometry file (file formats: *.pdb), 
where all atom coordinates are indicated in the form of Cartesian coordinates. 
In the *.pdb files also connections among atoms may be specified. 
Readily available geometry generators can be found at: 
http://turin.nss.udel.edu/research/tubegenonline.html, or 
http://www.ugr.es/~gmdm/contub.htm .

We need first to convert the *.pdb geometry file (general and adopted also by many 
other software for MD) into *.gro (typical geometry file used by GROMACS). 
The following command can be used, where a periodic computational box of 
16 nm x 16 nm x 16 nm is created, 
with the box edge (16 nm) being roughly 1.3 times the CNT length (periodicity 
is imposed along x, y and z): 

---------------------
gmx editconf -f 0-INPUT/CNT53_12x057.pdb -o CNT53_12x057.gro -box 16 16 16
---------------------

Next a topology (*.top) file needs to be created from the geometry file (*.gro). 
Topology files are basically a list of all the stretching, angular and dihedral bonds. 
In order to generate a *.top file from the corresponding *.gro file, the 
force-field files are requested. In particular, for this step the two required files are: 
ffoplsaaCNT.n2t and ffoplsaaCNT.rtp are used (included in the ffoplsaaCNT.ff subfolder).

Enter into the 0-INPUT folder:

---------------------
cd 0-INPUT
---------------------

and then run the x2top command:

---------------------
gmx x2top -f ../CNT53_12x057.gro -o CNT53_12x057.top -ff ffoplsaaCNT -noparam
---------------------

Check the content of the created TOP file by:

---------------------
featherpad CNT53_12x057.top &
---------------------

Finally, let us go back to the main folder:

---------------------
cd ../
---------------------

*******************************************************************************


*******************************************************************************
2 - ENERGY MINIMIZATION 
*******************************************************************************

Once the correct *.top file is available, we are ready to perform MD
simulations.  Before starting, the energy minimization of the simulated
structure needs to be performed. In this case it is not strictly required,
because our CNT is already in the configuration of minimal energy. However, in
general, energy minimization is always necessary for a correct numerical
convergence of the subsequent steps.  Here, we need an *.mdp file where
prescriptions on the numerical simulations are indicated (an *.mdp file is
already included in the subfolder 1-EM). First, we pre-compile di simulation:

---------------------
gmx grompp -f 1-EM/em.mdp -c CNT53_12x057.gro -p ./0-INPUT/CNT53_12x057.top -o 1-EM/CNT53_12x057_em.tpr -po 1-EM/mdout.mdp
---------------------

then, we run it:

---------------------
gmx mdrun -s 1-EM/CNT53_12x057_em.tpr -o 1-EM/CNT53_12x057_em.trr -c CNT53_12x057_em.gro -g 1-EM/em.log -e 1-EM/em.edr -v 
---------------------

A basic tool for visualization of the simulated structure is:

---------------------
gmx view -f 1-EM/*.trr -s 1-EM/*tpr
---------------------

However, a much better visualization (of many geometry files such as: *.pdb, 
*.gro, *.xyz, etc., as well as of trajectories: *.trr) can be obtained by 
the free software VEGA-ZZ (http://www.vegazz.net/) or OVITO (https://www.ovito.org/). 
For downloading them, you just need to make a registration. *.pdb files can 
be visualized also by "molviewer" readily available in MATLAB.

*******************************************************************************


*******************************************************************************
3 - THERMAL EQUILIBRATION 
*******************************************************************************

Here, we want to thermalize the whole system by attaching a Berendsen thermostat 
to the CNT. Therefore, we need an *.mdp file where prescriptions on the numerical 
simulations are indicated (an *.mdp file is already included in the subfolder 2-TE).
The command grompp performs a preparation step before running the real md 
simulation and it produces a *.tpr file. In order to start the simulation 
from a previous minimal energy state (Energy minimization), use here the flag -t 
as follows:

---------------------
gmx grompp -f 2-TE/md-te.mdp -c CNT53_12x057_em.gro -p ./0-INPUT/CNT53_12x057.top -t 1-EM/CNT53_12x057_em.trr -o 2-TE/CNT53_12x057_md-te.tpr -po 2-TE/mdout.mdp
---------------------

The real md simulation is performed by the command mdrun, which accepts the 
*.tpr as an input and it produces a *.trr file as an output, as follows:

---------------------
gmx mdrun -s 2-TE/CNT53_12x057_md-te.tpr -o 2-TE/CNT53_12x057_md-te.trr -c CNT53_12x057_md-te.gro -g 2-TE/md-te.log -e 2-TE/md-te.edr -v 
---------------------

After that the simulation is finished, we can extract the temperature/energy of the 
system from the trajectory as:

---------------------
gmx energy -f 2-TE/md-te.edr -o 2-TE/energies.xvg
---------------------

and then type the numbers corresponding to the quantities to extract, as suggested 
by the interactive menu. Double 'Enter' to end the selection. For plotting 
temperature/energy history use:

---------------------
xmgrace -nxy 2-TE/energies.xvg
---------------------

A basic tool for visualization of the simulated trajectory is:

---------------------
gmx view -f 2-TE/*.trr -s 2-TE/*tpr
---------------------

*******************************************************************************


*******************************************************************************
3 - NON-EQUILIBRIUM SIMULATION 
*******************************************************************************

Here, for computing the thermal conductivity of the carbon nanotube we 
perform a non-equilibrium computation, where the one end of the tube is 
attached to a Nose-Hoover (NH) thermostat at 320 K, the other end is attached 
to a NH thermostat at 280 K. Thermal conductivity is then computed by measuring
both the slope of the temperature profile and the heat flux. For this computation, 
we need to subdivide all carbon atoms into several groups: 
this is done by creating an index file *.ndx (here, you can find it in 
the subfolder 0-INPUT). However, a MATLAB subroutine (makeindex.m) is included 
in the subfolder "_POST-PROCESSING/MATLAB_VERSION" for making your own groups 
(instructions are therein included). As above, we need an *.mdp file where 
all prescriptions/inputs on the numerical simulations are provided (an *.mdp 
file is already included in the subfolder 3-NE). Detailed instructions 
need to be given in the *.mdp file for specifying thermostats for each 
group of atoms. The provided MATLAB subroutine "makenosehoover.m" 
(included in the subfolder "_POST-PROCESSING/MATLAB_VERSION") will enable 
you to produce the proper text to be included in the *.mdp file before 
performing the grompp command. In this case, we have already done this 
step and the provided *.mdp file is consistent.

The command grompp performs a preparation step before running the real 
md simulation and it produces a *.tpr file. In order to start the simulation 
from a the previous equilibrium state (Berendsen equilibration) use here 
the flag -t:

---------------------
gmx grompp -n 0-INPUT/CNT53-long.ndx -f 3-NE/md-ne.mdp -c CNT53_12x057_md-te.gro -t 2-TE/CNT53_12x057_md-te.trr -p ./0-INPUT/CNT53_12x057.top -o 3-NE/CNT53_12x057_md-ne.tpr -po 3-NE/mdout.mdp -maxwarn 1
---------------------

The real md simulation is performed by the command mdrun, which accepts 
the *.tpr as an input and it produces a *.trr file as an output, as follows:

---------------------
gmx mdrun -s 3-NE/CNT53_12x057_md-ne.tpr -o 3-NE/CNT53_12x057_md-ne.trr -c CNT53_12x057_md-ne.gro -g 3-NE/md-ne.log -e 3-NE/md-ne.edr &
---------------------

For checking the evolution of the run:

---------------------
tail -f 3-NE/*log
---------------------

NOTE: You can press CTRL+C to exit the "tail" command.

For extracting the temperature/energy history use "gmx energy" and then type 
the numbers corresponding to the quantities to extract, as suggested by 
the interactive menu. In this case type from 35 to 86 (and we provide them 
by "echo" command), in order to analyze the trend of temperature in the 
different groups of carbon atoms of the nanotube at steady state conditions, 
namely after 50 ps:

---------------------
echo "35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 0" | gmx energy -f 3-NE/md-ne.edr -o _POST-PROCESSING/Temp.xvg -b 50 -e 200
---------------------

The heat flux through the nanotube can be computed as: 
q = f * N_DOF * k_B * T_a / S, being
f     --> [s^-1] Nose-Hoover (NH) friction factor
N_DOF --> [-]    Number of degrees of freedom attached to NH
k_B   --> [J/K]  Boltzmann constant
T_a   --> [K]    Average temperature of NH
S     --> [m^2]  Tube cross-section surface 
(see the slides for a more comprehensive explanation). The average friction factor 
during the simulation at steady state conditions can be extracted as:

---------------------
echo "vXi-INT52" | gmx energy -f 3-NE/md-ne.edr -o _POST-PROCESSING/FrictionNH.xvg -b 50 -e 200
---------------------

Finally, the post-processing (computation of thermal conductivity) can be 
performed by the provided shell routine "compute-lambda.sh" included in the 
subfolder "_POST-PROCESSING".
The average value of friction factor of the NH thermostat (group INT52) 
should be then updated in this shell script. Just open it:

---------------------
featherpad ./_POST-PROCESSING/compute-lambda.sh 
---------------------

and then update the value of friction factor in the "xi" variable 
(0.592108e12, in this case):

xi=$(echo "0.592108e12" | awk {'printf "%.30f", $1'})    # [s^-1]  Nose-Hoover (NH) Friction factor

After saving and closing the shell script, it can be made as executable by:

---------------------
chmod 777 ./_POST-PROCESSING/compute-lambda.sh
---------------------

and then run by:

---------------------
./_POST-PROCESSING/compute-lambda.sh
---------------------

Notice that a MATLAB version of the previous script is also available
in the _POST-PROCESSING folder. 


*******************************************************************************
