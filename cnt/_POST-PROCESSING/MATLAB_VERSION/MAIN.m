%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This routine is used for the post-processing of the results after the 
% non-equilibrium simulation. For that, just copy past in the folder
% "POST-PROCESSING" the file *.xvg which has been produced by the command:
% g_energy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=12e-9;            % Nanotube length [m]
N=52;               % Number of groups
cap=2;              % Number of groups to exclude at the ends

xx=0:L/N:L-L/N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  File containing the trend of temperatures within the nanotube during the simulation
file = ('Temp.xvg');
importfile(char(file));

%  Edit data
T = data(:,2:end);
T_mean = mean (T);
L = 11.8;
%Dist = linspace (0,L,52);
plot(10^9*xx,T_mean,'o-')
xlabel('Length [nm]')
ylabel('Temperature [K]')

T=T_mean';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TT=T(end);          % [K]     Temperature at right-end
xi=0.592108e12;     % [s^-1]  Nose-Hoover (NH) Friction factor 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nf=15*3;             % [-]     Number of degrees of freedom attached to NH
kb=1.3806e-23;       % [J/K]   Boltzmann constant 
b=0.34e-9;           % [m]     Wan der Vaals radius
r=0.28e-9;           % [m]     Tube cross-section radius

SA=2*pi*r*b;         % [m^2]   Area

q=-xi*Nf*kb*TT/SA;   % [W/m^2] Heat flux

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Here we estimate the slope of the temperature profile 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=T';
P = polyfit(xx(1+cap:end-cap),T(1+cap:end-cap),1);
yy=P(1)*xx + P(2);
hold on
plot(10^9*xx(1+cap:end-cap),yy(1+cap:end-cap),'r','linewidth',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Here we estimate the CNT thermal conductivity by Fourier's law
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=q/P(1);

disp('Measured conductivity: [W/mK]')

disp(abs(k))
text(4,310,['k=',num2str(abs(k)),' [W/mK]'],'FontSize',20)
