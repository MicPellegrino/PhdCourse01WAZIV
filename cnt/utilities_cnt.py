import numpy as np

def make_index(IV, IN, GN) :

    """
        This routine prints to screen the content of the *.ndx file to be used in the
        Nose-Hoover md simulation. 
        
        IV ("Initial value") = label (integer) of the first group. 
        IN ("Interval") = the number of atoms in each group. 
        GN ("Number of groups") = the total number of groups to be created.

        After running, copy-paste what is printed on the output (either shell or 
        notebook) into a text file with *.ndx extension.
    """

    N = 1
    while N <= GN:

        # Header (group name)
        print(f"[ INT{N} ]")

        # Atoms for each group
        output = ""
        for i in range(IV, IV + IN):
            output += f"{i:3d}  "
        print(output)

        # Update counters
        IV += IN
        N += 1


def make_nose_hoover(GN, NN, TI, TF, tau):

    """
        This routine prints to screen what is required in the *.mdp file for the 
        non-equilibrium simulation. 
        
        GN ("Number of groups") = total number of groups of the system
        NN ("Number of Nose-Hoover groups") = number of groups at the end of the
            tube attached to Nose-Hoover (NH) thermostats
        TI ("Initial temperature") = temperature to impose at one end
        TF ("Final temperature") = temperature to impose at the other end
        tau ("Nose-Hoover time") = relaxation time to impose for the NH thermostats
        
        After running, copy-paste what is printed on the output (either shell or 
        notebook) into the *.mdp file before running the grompp command.
    """

    # Define the thermostat coupling groups
    output = "tc-grps = "
    N = 1
    while N <= GN:
        output += f"INT{N}  "
        N += 1
    print(output)

    # Define temperature for each group 
    output = "ref-t = "
    N = 1
    while N <= GN:
        if N < (NN + 1):
            temp = f"{TI}  "
        elif N > (GN - NN):
            temp = f"{TF}  "
        else:
            temp = f"{(TI + TF) / 2}  "
        output += temp
        N += 1
    print(output)

    # Define temperature coupling time for each group
    #       (tau = -1 : do not couple) 
    output = "tau-t = "
    N = 1
    while N <= GN:
        if N < (NN + 1):
            temp = f"{tau}  "
        elif N > (GN - NN):
            temp = f"{tau}  "
        else:
            temp = f"{-1}  "
        output += temp
        N += 1
    print(output)


def compute_lambda(l, n, ne, file, xi):

    """
        l = Nanotube length [nm]
        n = Number of groups
        ne = Number of groups to exclude at the ends
        file = Input file to be processed
        xi = friction factor computed from MD s^-1
    """

    # Read and clean XVG file: skip # and @, remove first column (time)
    data = []
    with open(file) as f:
        for line in f:
            if line.startswith('#') or line.startswith('@'):
                continue
            fields = line.split()
            if len(fields) <= 1:
                continue
            data.append([float(x) for x in fields[1:]])
    data = np.asarray(data)

    # Compute the mean of each column
    col_means = data.mean(axis=0)

    # Convert column index to a distance
    indices = np.arange(1, len(col_means) + 1, dtype=float)
    positions = indices * l / n
    Tmean = np.column_stack((positions, col_means))

    # Determine the thermal flux
    Tend = Tmean[-1, 1]
    pi = np.pi

    dof = 15*3          # degrees of freedom
    Kb = 1.380649e-23   # Boltzmann's constant J/K
    b = 0.34e-9         # m
    r = 0.28e-9         # m

    # Area
    S = 2.0*pi*r*b

    # Thermal flux
    q = -xi*dof*Kb*Tend/S

    # Remove groups at the ends
    Tfit = Tmean[ne:n-ne]

    return Tmean, Tfit, q


if __name__ == "__main__" :

    IV = 1
    IN = 784//52
    GN = 52
    NN = 1
    TI = 280
    TF = 320
    tau = 0.2

    make_index(IV, IN, GN)
    make_nose_hoover(GN, NN, TI, TF, tau)

    l=12
    n=52
    ne=2
    file="_POST-PROCESSING/Temp.xvg"
    xi = 0.592108e12

    Tmean, Tfit, q = compute_lambda(l, n, ne, file, xi)
    print(Tmean.shape)
    print(Tfit.shape)
    print(q.shape)