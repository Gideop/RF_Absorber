function [] = NRW_Plots(f,e,u,names)

for i = 1:length(names)
    % Generate one 2x1 subplot for each material
        % First subplot is real/imag eps vs f
        % Second is real/imag mu vs f
        % Not meant to be final figures, add extra functionality for pretty
        % professional plots
    
    figure(i)
    
    subplot(2,1,1)
    hold on
    plot(f(:,i)/1e9,real(e(:,i)),'r',LineWidth=3)
    plot(f(:,i)/1e9,imag(e(:,i)),'--r',LineWidth=3)
    ylabel('\epsilon')
    xlim([f(1,i)/1e9 f(end,i)/1e9])

    subplot(2,1,2)
    hold on
    plot(f(:,i)/1e9,real(u(:,i)),'b',LineWidth=3)
    plot(f(:,i)/1e9,imag(u(:,i)),'--b',LineWidth=3)
    ylabel('\mu')
    xlabel('Frequency [GHz]')
    xlim([f(1,i)/1e9 f(end,i)/1e9])

    % Don't need the file extension in the material name
    mat = erase(names{i},'.s2p');
    % Underscore means subscript to the text interpreter
    mat = replace(mat,'_',' ');
    sgtitle(mat)
    fontsize(30,'points')

end