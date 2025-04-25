function [] = SE_Plots(f,SER,SEA,d,names)

% Convert d back to mm from m
d = d*1000;

for i = 1:length(names)
    % Generate one 2x1 subplot for each material
        % First subplot is SER vs f
        % Second is SEA/mm vs f
        % Not meant to be final figures, add extra functionality for pretty
        % professional plots
    
    figure
    
    subplot(2,1,1)
    plot(f(:,i)/1e9,SER(:,i),'r',LineWidth=3)
    ylabel('SER [dB]')
    xlim([f(1,i)/1e9 f(end,i)/1e9])

    subplot(2,1,2)
    plot(f(:,i)/1e9,SEA(:,i)./d,'b',LineWidth=3)
    ylabel('SEA [dB/mm]')
    xlabel('Frequency [Hz]')
    xlim([f(1,i)/1e9 f(end,i)/1e9])

    % Don't need the file extension in the material name
    mat = erase(names{i},'.s2p');
    % Underscore means subscript to the text interpreter
    mat = replace(mat,'_',' ');
    sgtitle(mat)
    fontsize(30,'points')

end