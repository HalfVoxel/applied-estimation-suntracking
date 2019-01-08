function overview_plots()
    N = 10000
    times = linspace(0, 365.24, N);
    lats = 60 + zeros(1, N);
        S = [times; lats * pi/180; zeros(1,N)];
    heights = observation_model(S);
    k = [times; heights];
    dlmwrite('overview0.mat', k);
    
    
    lats = 85 + zeros(1, N);
        S = [times; lats * pi/180; zeros(1,N)];
    heights = observation_model(S);
    k = [times; heights];
    dlmwrite('overview1.mat', k);
    % plot(times, heights);
    
    
    lats = 0 + zeros(1, N);
        S = [times; lats * pi/180; zeros(1,N)];
    heights = observation_model(S);
    k = [times; heights];
    dlmwrite('overview2.mat', k);
    % plot(times, heights);
    
    lats = 10 + zeros(1, N);
        S = [times; lats * pi/180; zeros(1,N)];
    heights = observation_model(S);
    k = [times; heights];
    dlmwrite('overview3.mat', k);
    % plot(times, heights);
    
    lats = 20 + zeros(1, N);
        S = [times; lats * pi/180; zeros(1,N)];
    heights = observation_model(S);
    k = [times; heights];
    dlmwrite('overview4.mat', k);
    % plot(times, heights);
end