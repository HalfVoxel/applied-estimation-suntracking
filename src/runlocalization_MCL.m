% This function is the entrance point to the code. 
function runlocalization_MCL(num_particles, R, Q, Lambda_Psi, starting_state, delta_t, time_process_noise, latitude_process_noise, measurement_noise, save_index, allow_inject)
    days_per_year = 365.2422;
    polar_circumference = 39941e3; %polar circumference in meters

    bound_t = [0 days_per_year];
    bound_l = [-pi/2 pi/2];
    S = init_particles(num_particles, bound_t, bound_l);
    mean_weights = zeros(size(S,2),1);
    state = starting_state; %time, latitude in radians
    estimation_history = [];

    % Process noise covariance matrix
    true_R = [(time_process_noise*delta_t/(60*24))^2 0; 0 (delta_t*latitude_process_noise)^2];

    true_Q = (measurement_noise * pi/180)^2;
    
    state_history = state;
    subplot(2,1,1);
    p1 = plot([0], [0], 'DisplayName', 'True latitude');
    hold on;
    
    p2 = plot([0], [0], 'DisplayName', 'Velocity (km / hr)');
    
    p3 = plot([0], [0], '.', 'DisplayName', 'True sun height');    
    s = scatter(S(1,:), S(2,:) * 180/pi, 'DisplayName', 'Candidates');    
    bestEstimate = plot([0], [0], 'rx', 'DisplayName', 'Best Estimate');
    
    legend()
    ylim([-90 90]);
    xlim([0,730]);
    yticks(-90:15:90);
    grid on;
    hold off;
    
    
    subplot(2,1,2);
    e1 = plot([0], [0], 'DisplayName', 'Time of day error (0.1 hours)');
    hold on;
    e3 = plot([0], [0], 'DisplayName', 'Latitude error (degrees)');
    e2 = plot([0], [0], 'DisplayName', 'Time of year error (days)');
    e5 = plot([0], [0], 'DisplayName', 'Time of year error (days)');
    e6 = plot([0], [0], 'DisplayName', 'Time of year error (days)');
    
    
    
    drawnow;
    
    xlabel('Fractional Time');
    hold off;
    legend();
    ylim([-4 4]);
    xlim([0,730]);
    hold off;
    psi = zeros(1, size(S,2));
    v = zeros(1, size(S,2));
    for i = 1:3650*2
        dt = delta_t * (0.8 + 0.2 * rand());
        % Update the time without noise
        state(1) = state(1) + dt;
        
        % Add some noise to the time and latitude update
        state = state + mvnrnd([0 0], true_R)';
        
        % Prevent the latitude from getting impossible values
        state(2) = max(min(state(2), pi/2), -pi/2);

        state_history = [state_history state];
        
        height = observation_model([state ; 1]);
        % Note: if the height is zero, then we did not observe anything
        if (height > 0)
            height = height + normrnd(0, true_Q)
        end
        if (height > pi/2)
            height = pi/2;
        end
        height
        
        % Update the states
        S = predict(S, R, dt, v);
        
        % Canonicalize particle states to remove symmetries
        % North/South hemisphere symmetry
        % we cannot differentiate between a state (t,lat) and the state (t+year/2,-lat)
        %     southern = S(2,:) < 0;
        %     S(1,southern) = S(1,southern) - days_per_year/2;
        %     S(2,southern) = -S(2,southern);
        % Note that the state is not perfectly periodic in a year because
        % a year does not have an integer number of days
        % S(1,:) = mod(S(1,:), days_per_year);
        if (height > 0) || true
            if height > 0 && allow_inject
                % Add in a few random particles
                num_random = 50; % round(500 / max(mean(psi)*mean(psi), 5));
                random_indices = randi(size(S,2), num_random, 1);
                S2 = init_particles(num_random, bound_t, bound_l);
                S2(3,:) = 0;
                S2(1,:) = round(S2(1,:)) + mod(S(1,random_indices), 1);
                S(:,random_indices) = S2(:,1:num_random);
                mean_weights(random_indices) = -10;

                num_symmetry = 20;
                random_indices = randi(size(S,2), num_symmetry, 1);
                new_ts = S(1,random_indices) + (randi(2, 1, num_symmetry) * 2 - 3) * round(days_per_year/2) + round(mvnrnd(zeros(num_symmetry, 1), 1))';
                inside_bounds = new_ts >= bound_t(1) & new_ts <= bound_t(2);
                S(1,random_indices(inside_bounds)) = new_ts(inside_bounds);
                S(2,random_indices(inside_bounds)) = -S(2,random_indices(inside_bounds));
                mean_weights(random_indices(inside_bounds)) = -10;
            end

            [outlier, psi, v] = associate(S, height, Lambda_Psi, Q * (1 + 1000 * exp(-i/50)));
        end
        
        psi_mean = mean(psi)
        e6.XData = [e6.XData state(1)];
        e6.YData = [e6.YData mean(psi)];
        
        mean_weights = mean_weights * 0.8 + log(psi'+0.0000001) * 0.2;
        
        [maxval, maxind] = max(mean_weights);
        % [maxval, maxind] = max(psi);
        
        %G = S(1,:);
        %H = round(S(2,:));
        %I = mod(S(2,:), 1);
        estimated_state = S(:,maxind);
        total = 0;
        est_latitude = 0;
        est_time = 0;
        [B,I] = maxk(mean_weights .* (abs(S(1,:) - S(1,maxind))' < 50), 30);
        for j = 1:length(I)
            index = I(j);
            est_latitude = est_latitude + S(2,index)*mean_weights(index);
            est_time = est_time + S(1,index)*mean_weights(index);
            total = total + mean_weights(index);
        end
        estimated_state(1) = round(est_time / total) + mod(estimated_state(1),1);
        estimated_state(2) = est_latitude / total;
        estimation_history = [estimation_history estimated_state];
        mintimeerror = abs(mod(estimated_state(1) - state(1),1)) * 24;
        mintimeerror = mod(mintimeerror + 12, 24) - 12;
        
        est_dayofyear = mod(estimated_state(1), days_per_year);
        other_est_dayofyear = mod(est_dayofyear + days_per_year/2, days_per_year);
        dayofyear = mod(state(1), days_per_year);
        mindayerror = min(abs(dayofyear - est_dayofyear), abs(dayofyear - other_est_dayofyear));
        %   minlaterror  = abs(estimated_state(2) - state(2)) * 180/pi * 10;
                % the above is exact error, but is off the chart if we are
                % stuck in a symmetry point; use the below instead
        minlaterror = abs(abs(estimated_state(2)) - abs(state(2))) * 180/pi;
        %psi(maxind)
        
        s.XData = S(1,:);
        s.YData = S(2,:) * 180/pi;
        p1.XData = state_history(1,:);
        p1.YData = state_history(2,:)*180/pi;

        % Plot the estimated state with all different symmetries and
        % periodicities.
        % The time is periodic in a year and there is a symmetry such that
        % we cannot differentiate between a state (t,lat) and the
        % state (t+year/2,-lat)
        bestEstimate.XData = [estimated_state(1), estimated_state(1) + days_per_year, estimated_state(1) - days_per_year];
        bestEstimate.XData = [bestEstimate.XData, bestEstimate.XData - days_per_year/2];
        bestEstimate.YData = [estimated_state(2) * 180/pi, estimated_state(2) * 180/pi, estimated_state(2) * 180/pi];
        bestEstimate.YData = [bestEstimate.YData, -bestEstimate.YData];
        
        % If we can see the sun, then add a new sample
        if (height > 0) || true
            S_bar = weight(S, psi, outlier);
            S_bar = [S_bar; psi; mean_weights'];
            S = systematic_resample(S_bar);
            psi = S(4,:);
            mean_weights = S(5,:)';
            S = S(1:3,:);
        end

        f = abs(state_history(2,i+1) - state_history(2,i)) / (2*pi);
        dt = state_history(1,i+1) - state_history(1, i);
        distance = polar_circumference * f;
        
        p2.XData = [p2.XData state(1)];
        p2.YData = [p2.YData distance / 1000 / 24 / dt];
        
        p3.XData = [p3.XData state(1)];
        p3.YData = [p3.YData height*180/pi];
        e1.XData = [e1.XData state(1)];
        e1.YData = [e1.YData mintimeerror * 10];
        e2.XData = [e2.XData state(1)];
        e2.YData = [e2.YData mindayerror];
        e3.XData = [e3.XData state(1)];
        e3.YData = [e3.YData minlaterror];
        
        e5.XData = [e5.XData state(1)];
        e5.YData = [e5.YData maxval];
        
%         if mintimeerror < -3
%             drawnow;
%             pause;
%         end
        
        
        if mod(i, 10) == 0
            drawnow;
        end
        
        % drawnow;
        % pause
        
        % observation_model(S(:,5)) - height
    end
    
    estimation_history = [estimation_history(:,1) estimation_history];
    dlmwrite(sprintf('../test%d/states.csv', save_index), [state_history; p3.YData; e1.YData/10; e2.YData; e3.YData; estimation_history]);
end
