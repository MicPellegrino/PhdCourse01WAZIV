function importfile(file)

%  Imports data from the specified file
%  FILE:  file to read


DELIMITER = ' ';
HEADERLINES = 70;

% Import the file
newData1 = importdata(file, DELIMITER, HEADERLINES);

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

