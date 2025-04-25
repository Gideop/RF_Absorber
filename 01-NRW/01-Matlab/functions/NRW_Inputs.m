function [d,lamc,force,movavg,data_folder,filsel,m,plt,ex] = NRW_Inputs
% This function collects all user input for the NRW Script in one go

% OUTPUTS

% d- sample thickness in mm
% lamc- cutoff wavelength for rectangular waveguide (infinity for coax)
% force- 1/0, selector to force unity to zero for non-magnetic materials
% movavg- number of points in moving average to smooth noise
% data_folder- full path name of data folder with s2p files
% m- NRW starting branch
% plt- enables plots for instant viewing
% ex- enables the dataset (MATLAB workspace) to be exported

%% Ask for inputs

% Restart flag- prevents faulty inputs
f = 1;
while f
    f = 0;
    
    % Dialog box creation
    prompts = {'Sample Thickness [mm]:','Waveguide Number: (Available: 22, 10, 6, 5, 0 for coaxial cable)','Force permeability to unity for non-magnetic material: (1/0)','Number of points in moving average:','Full path of data folder:','Are the files s2p (0) or csv (1)?','NRW starting branch:','View plots? (1/0)','Save this dataset? (1/0)'};
    dlgtitle = 'NRW Inputs';
    fieldsize = [1 40];
    % Default values since I use them so much
    definput = {'0.5','22','0','100','','0','0','1','0'};
    x = inputdlg(prompts,dlgtitle,fieldsize,definput);
    
    % Break up responses into individual variables
        % Also converting strings to numbers
    d = str2num(x{1});
    WR = str2num(x{2});
    force = str2num(x{3});
    movavg = str2num(x{4});
    data_folder = x{5};
    filsel = str2num(x{6});
    m = str2num(x{7});
    plt = str2num(x{8});
    ex = str2num(x{9});
    
    % Convert thickness to mm
    d=d*1e-3;
    
    % WG a dimension to determine lamc
    switch WR
        case 22
            a = 5.6896e-3;  
        case 10
            a = 2.54e-3;
        case 6 
            a = 1.651e-3;
        case 5
            a = 1.2954e-3;
        case 0
            % Coax
            a = inf;
        otherwise
            % Run until dimension is assigned
            disp('Waveguide size not known. Update NRW_Inputs function with waveguide dimension or select another size.')
            % Repeat, ctrl+c to stop function if update needed
            f = 1;
    end

    % Determine lamc
    e0 = 8.854*10^-12;      % Epsilon naught
    mu0 = 4*pi*10^-7;        % Mu naught
    c = 1/sqrt(mu0*e0);                % Light speed [m/s]
    fc = c/(2*a);           % Cutoff frequency [Hz]
    lamc = c./fc;           % Cutoff wavelength [m]
end