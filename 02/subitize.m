
subitize_graph();

function subitize_graph()
    figure_name = 'subitize_graph.pdf'; 
    fig = figure('Name', figure_name); 
    current_participation = [0.55,0.75,0.95,1.15,1.35,1.55,1.75,1.95,2.15,2.35]; 
    original_experiment = [0.6,0.65,0.70,0.86,1.12,1.50,1.79,2.13,2.15,2.58];
    plot(1:10,current_participation, '-r.', 'LineWidth',1) 
    hold on 
    plot(1:10,original_experiment, '-b.', 'LineWidth',1) 
    xlabel('items on screen');
    ylabel('time');
    h = zeros(2,1); 
    h(1) = plot(NaN,NaN, '.r');
    h(2) = plot(NaN,NaN, '.b');
    legend(h, 'Current patricipation', 'Original experiment'); 
    grid
    save_plot(fig, figure_name);
end 

% function to save the plot
function save_plot(fig, name)
    set(fig, 'PaperPosition', [0 0 20 20]);
    set(fig, 'PaperSize', [20 20]);
    saveas(fig, name);
end 
