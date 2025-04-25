function [f,S11,S21,S12,S22,names] = Read_csv_s2p_RI(movavg,data_folder)
% Made by Jack Benn
% Read S parameters and frequency vector from csv files 
% Same thing as Read_s2p_RI.m but does csv instead
    % Only for HFSS
% Reads entire folder at once!

% INPUTS
% movavg- apply moving average of this many points to smooth noise
% data_folder- the full path of the folder with all data to be read

% OUTPUTS
% f, S11, S21, S12, S22- frequency and real/imaginary S matrix from s2p
% names- name of each file

% Delete quotation marks (messes up path finding)
data_folder(find(data_folder == '"'))=[];
% Remember current folder and move to data_folder
orig_folder = cd;
cd(data_folder);
% Count csv files
all_csv=dir([data_folder '/*.csv']); 
% Iterate for each csv
for i = 1:length(all_csv)
    
    % Get the name of the file
    file = all_csv(i);
    names{i} = file.name;

    % Read s2p without RF toolbox:
    numberOfHeaderLines = 8;
    FID = fopen(file.name);
    %datacell = textscan(FID,'%f%f%f%f%f%f%f%f%f','Headerlines',numberOfHeaderLines,'CollectOutput',1);
    T = readmatrix(names{i},'Range',2);
    fclose(FID);
    %samp=datacell{1};
    clear ans FID numberOfHeaderLines datacell file
    
    % Break into constituent components
    f_i = T(:,1).*power(10,9);               % THIS ONE IS IN Hz 
    S11_i = T(:,2) + j.*T(:,3);
    S21_i = T(:,4) + j.*T(:,5);
    S12_i = T(:,6) + j.*T(:,7);
    S22_i = T(:,8) + j.*T(:,9);
    
    % Apply moving average to raw data
    if movavg
        S11_i = movmean(S11_i,movavg);
        S21_i = movmean(S21_i,movavg);
        S12_i = movmean(S12_i,movavg);
        S22_i = movmean(S22_i,movavg);
    end

    % Stick into larger matrix
        % i subscript indicates values during each loop
        % They get stuck together in columns of a 2D matrix here
    f(:,i) = f_i;
    S11(:,i) = S11_i;
    S21(:,i) = S21_i;
    S12(:,i) = S12_i;
    S22(:,i) = S22_i;

end

% Return to original folder
cd(orig_folder)