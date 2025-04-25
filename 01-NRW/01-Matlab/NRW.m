%% NRW 
% Brenden Mears 2025
% Finalized and packaged NRW script

% Updated 10 Apr 2025

% Everything in one place to extract complex permittivity and permeability
% from real/imaginary s2p files

% Also shielding effectiveness

% Formatting and reset:
clc; clear; format compact; close all

% Naming convention:
% While not required, I recommend naming your s2p files in the format:
% 'length_concentrationMaterial_sample#.s2p'
% i.e., the 2nd copy of a 0.5mm thick 60 wt% BaM sample would be:
% 0.5_60BaM_2.s2p

% LIST OF REQUIRED FUNCTIONS
% THESE MUST BE IN THE "functions" FOLDER IN THE SAME FOLDER AS THIS SCRIPT:

% NRW_Inputs.m
% Read_s2p_RI.m
% Read_csv_s2p_RI.m
% NRW_Algorithm.m
% SE_Algorithm.m
% NRW_Plots.m
% SE_Plots.m

% Add it to path
addpath('functions')

%% Data collection

% Collect user inputs
    % Have file explorer open separately, right click s2p folder, copy as path
    % Don't need to delete quotation marks before entering
[d,lamc,force,movavg,data_folder,filsel,m,plt,ex] = NRW_Inputs;
clc

% Read s2p files
    % By default, don't bother saving S12 and S22, but change here if
    % needed
if filsel
    % csv from HFSS
    [f,S11,S21,~,~,names] = Read_csv_s2p_RI(movavg,data_folder);
else
    % s2p from VNA
    [f,S11,S21,~,~,names] = Read_s2p_RI(movavg,data_folder);
end
clc

%% NRW Algorithm

% The actual NRW step
% Iterate for each file
    % Loop here and not inside algorithm
for i = 1:length(names)
    [e(:,i), u(:,i)] = NRW_Algorithm(f(:,i),S11(:,i),S21(:,i),d,lamc,m,force);
end

%% Shielding Effectiveness

% SER = reflection
% SEA = absorption
for i = 1:length(names)
    [SER(:,i) SEA(:,i)] = SE_Algorithm(S11(:,i),S21(:,i));
end

%% Plots

if plt 
    NRW_Plots(f,e,u,names)
    SE_Plots(f,SER,SEA,d,names)
end

%% Export

% Export the important variables in the workspace
    % d- sample thickness [mm]
    % e- relative complex permittivity vectors
    % f- frequency vectors [Hz]
    % names- naming key for each vector
    % S11
    % S21
    % SEA- absorption
    % SER- reflection
    % u- relative complex permeability vector
% Enables hardcoding final plots in separate scripts
    % Strongly recommend .mat extension for easy loading

if ex 
    dataset_name = inputdlg('What is the name of this dataset? Include file extension (.mat is recommended):');
    datasetfile = append('PackagedDatasets/',dataset_name{1});
    save(datasetfile, "d","e","f","names","S11","S21","SEA","SER","u")
end