
zbrodoff_rt();
zbrodoff_F();
zbrodoff_s();

function zbrodoff_rt()
    figure_name = 'zbrodoff_graph_rt.pdf'; 
    fig = figure('Name', figure_name); 
    response_time_rt_m1 = [1.347, 1.250, 1.249]; 
    response_time_rt_0 = [1.605, 1.279, 1.282]; 
    response_time_rt_1 = [2.390, 1.888, 1.402]; 
    response_time_rt_2 = [3.290, 2.928, 2.496]; 

    plot(1:3,response_time_rt_m1, '-r.', 'LineWidth',1) 
    hold on 
    plot(1:3,response_time_rt_0, '-b.', 'LineWidth',1) 
    plot(1:3,response_time_rt_1, '-g.', 'LineWidth',1) 
    plot(1:3,response_time_rt_2, '-c.', 'LineWidth',1) 

    xlabel('Block');
    ylabel('Runtime');
    h = zeros(4,1); 
    h(1) = plot(NaN,NaN, '.r');
    h(2) = plot(NaN,NaN, '.b');
    h(3) = plot(NaN,NaN, '.g');
    h(4) = plot(NaN,NaN, '.c');

    legend(h, 'rt: -1', 'rt: 0', 'rt: 1', 'rt: 2'); 
    grid
    save_plot(fig, figure_name);
end 

function zbrodoff_F()
    figure_name = 'zbrodoff_graph_F.pdf'; 
    fig = figure('Name', figure_name); 
    response_time_F_1 = [2.172, 1.408, 1.320]; 
    response_time_F_7 = [2.214, 1.358, 1.33]; 
    response_time_F_13 = [2.421, 1.539, 1.331]; 
    response_time_F_20 = [2.907, 1.616, 1.497]; 

    plot(1:3,response_time_F_1, '-r.', 'LineWidth',1) 
    hold on 
    plot(1:3,response_time_F_7, '-b.', 'LineWidth',1) 
    plot(1:3,response_time_F_13, '-g.', 'LineWidth',1) 
    plot(1:3,response_time_F_20, '-c.', 'LineWidth',1) 

    xlabel('Block');
    ylabel('Runtime');
    h = zeros(4,1); 
    h(1) = plot(NaN,NaN, '.r');
    h(2) = plot(NaN,NaN, '.b');
    h(3) = plot(NaN,NaN, '.g');
    h(4) = plot(NaN,NaN, '.c');

    legend(h, 'lf: 0.1', 'lf: 0.7', 'lf: 1.3', 'lf: 2'); 
    grid
    save_plot(fig, figure_name);
end 

function zbrodoff_s()
    figure_name = 'zbrodoff_graph_s.pdf'; 
    fig = figure('Name', figure_name); 
    response_time_s_1 = [1.958, 1.251, 1.259]; 
    response_time_s_3 = [1.801,1.250,1.245]; 
    response_time_s_5 = [1.921,1.393,1.349]; 
    response_time_s_8 = [2.021,1.555,1.517]; 

    plot(1:3,response_time_s_1, '-r.', 'LineWidth',1) 
    hold on 
    plot(1:3,response_time_s_3, '-b.', 'LineWidth',1) 
    plot(1:3,response_time_s_5, '-g.', 'LineWidth',1) 
    plot(1:3,response_time_s_8, '-c.', 'LineWidth',1) 

    xlabel('Block');
    ylabel('Runtime');
    h = zeros(4,1); 
    h(1) = plot(NaN,NaN, '.r');
    h(2) = plot(NaN,NaN, '.b');
    h(3) = plot(NaN,NaN, '.g');
    h(4) = plot(NaN,NaN, '.c');

    legend(h, ':ans 0.1', ':ans 0.3', ':ans 0.5', ':ans 0.8'); 
    grid
    save_plot(fig, figure_name);
end 
% function to save the plot
function save_plot(fig, name)
    set(fig, 'PaperPosition', [0 0 20 20]);
    set(fig, 'PaperSize', [20 20]);
    saveas(fig, name);
end 
