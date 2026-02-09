for ii=1:length(wm)
    
% Initialize variables.
filename = ['msd_' num2str(wm(ii)) '.xvg'];
delimiter = ' ';
startRow = 20;
endRow = 20;
formatSpec = '%*s%*s%*s%*s%f%*s%f%*s%*s%*s%*s%*s%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow-1, 'ReturnOnError', false);

% Close the text file.
fclose(fileID);

% Create output variable
d(ii,:) = [dataArray{1:end-1}];
% Clear temporary variables
clearvars filename delimiter startRow endRow formatSpec fileID dataArray ans;
end
