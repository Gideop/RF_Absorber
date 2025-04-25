function [SER SEA] = SE_Algorithm(S11,S21)

% Calculates shielding effectiveness 

% INPUTS-
% S11 and S21- self explanatory

% OUTPUTS-
% SER- power reflected
% SEA- power absorbed

SER = -10 .* log10(1 - abs(S11).^2 );
SEA = -10 .* log10( ( abs(S21).^2 ) ./ ( 1 - abs(S11).^2 ) );

% Did I really need to make this a separate function?