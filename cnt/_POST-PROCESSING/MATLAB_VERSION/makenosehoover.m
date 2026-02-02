%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This routine prints to screen what is required in the *.mdp file for the 
% non-equilibrium simulation. 
% "Number of groups" is the total number of groups of the system
% "Number of Nosè-Hoover groups" is the number of groups at the end of the
% tube attached to Nosè-Hoover (NH) thermostats
% "Initial temperature" is the temperature to impose at one end
% "Final temperature" is the temperature to impose at the other end
% "Nosè-Hoover time" is the relaxation time to impose for the NH
% thermostats
%
% After running, copy-paste what is printed on the MATLAB command windows 
% into the *.mdp file before the grompp command.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

GN  = input('Number of groups [integer]: ');
NN  = input('Number of Nosè-Hoover groups [integer]: ');
TI  = input('Initial temperature [integer]: ');
TF  = input('Final temperature [integer]: ');
tau = input('Nosè-Hoover time [real]: ');

N = 1;
output = '';
while (N<=GN)
    temp = sprintf('INT%i  ',N);
    output = [output,temp]; 
    N = N+1;
end
disp(output)

N = 1;
output = '';
while (N<=GN)
    if (N<(NN+1))
        temp = sprintf('%i  ',TI);
    elseif (N>(GN-NN))
        temp = sprintf('%i  ',TF);
    else
        temp = sprintf('%i  ',(TI+TF)/2);
    end
    output = [output,temp]; 
    N = N+1;
end
disp(output)

N = 1;
output = '';
while (N<=GN)
    if (N<(NN+1))
        temp = sprintf('%f  ',tau);
    elseif (N>(GN-NN))
        temp = sprintf('%f  ',tau);
    else
        temp = sprintf('%f  ',0);
    end
    output = [output,temp]; 
    N = N+1;
end
disp(output)