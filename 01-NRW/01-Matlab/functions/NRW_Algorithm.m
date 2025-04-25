function [e, u, z,n,egd,RHS,Phi0,Phi] = NRW_Algorithm(f, S11, S21, d, lamc, m, force)
% This function is based on the Tretyakov 2011 paper

%% INPUTS

% f- frequency vector in Hz
% S11- raw, complex S11
% S21- raw, complex S21
% d- sample thickness in m
% lamc- cutoff wavelength for rectangular waveguide, infinity if coax
% m- branch selection, effectively trial and error
    % 0 if sample is less than half wavelength at lowest frequency
    % 1,2,3... for every half wavelength beyond
    % i.e., if sample is 1.2 wavelengths at lowest freq, use m = 2 (2 halves)
    % Code just needs to start in correct branch, adapts to higher branches after that
% force- force permeability to unity as an input

%% OUTPUTS

% NECESSARY:
% e- complex permittivity array
% u- complex permittivity array

% Debug:
% z- complex impedance array
% n- complex refractive index array
% egd- short for exp(gamma*d), the inverse of the propagation constant
% RHS- right hand side of equation 9; the refractive index in coax
% Phi0- phase angle of lowest frequency
% Phi- phase angle of all other frequencies

%% Initialization 

% Derived values
c = 3e8;                    % Light speed [m/s]
lam = c./f;                 % Free Space Wavelength [m]
k = (2*pi)./lam;            % Free space wavenumber [m^-1]
wc =2*pi*c./lamc;           % Cutoff frequency [rad/s]
w = 2*pi*f;                 % Frequency [rad/s]

%% Tretyakov algorithm

% Find wave impedance z (10)
znum = (1 + S11).^2 - S21.^2;
zden = (1 - S11).^2 - S21.^2;
z = sqrt(znum./zden);

% Find inverse of transmission coefficient T
    % e^+(gamma*d) from (11)
T1 = ( 1 - S11.^2 + S21.^2 )./( 2 * S21 );
T2 = ( 2 * S11 )./( (z - z.^-1) .* S21);
egd = T1 + T2;

% Find arguement (phase angle) for each frequency point 
    % Phi (8)
Phi0 = angle(egd(1)) +(2*pi*m);
Phi = Phi0 + cumsum(angle(egd(2:end)./egd(1:end-1)));

% Find refractive index 
    % n (9)
RHS = zeros(size(egd));
RHS(1) =     (1./(k(1)    .*d)).*(-j*log(abs(egd(1    ))) + Phi0);
RHS(2:end) = (1./(k(2:end).*d)).*(-j*log(abs(egd(2:end))) + Phi );

n = sqrt(RHS.^2 + (wc./w).^2);

% Get mu (10)
    % Force to unity
if force
    u = ones(size(f));
else
    unum = n.^2 - (wc./w).^2;
    udem = 1 - (wc./w).^2;
    u = z.*sqrt(unum./udem);
end

%% Final (non-Tretyakov) steps

% Get epsilon (inferred: n=sqrt(u*e))
    % Include reliance on u in case u is forced to unity
e = (n.^2)./(u);

% e&u should be in form x = x` - jx``, so make imag(x) negative
% Necessary to plot the correct sign of the imaginary part
e = real(e) - j*imag(e);
u = real(u) - j*imag(u);