close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This routine prints to screen the content of the *.ndx file to be used in the
% Nose-Hoover md simulation. "Initial value" is the label (integer) of the first 
% group. "Interval" is the number of atoms in each group. "Number of groups" 
% is the total number of groups to be created. 
%
% After running, copy-paste what is printed on the MATLAB command windows 
% into a text file with *.ndx extension.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IV = input('Initial value [integer]: ');
IN = input('Interval [integer]: ');
GN = input('Number of groups [integer]: ');

N = 1;
 while (N<=GN)
     temp = sprintf('[ INT%i ]',N);
     disp(temp)
     N = N+1;
     output = '';
     for i = IV:(IV+IN-1)
         temp = sprintf('%3i  ',i);
         output = [output,temp]; 
     end
     disp(output)
     IV = IV+IN;
 end