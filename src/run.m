function run()
    % test1()
    % test2()
    % test3()
    % test4()
    test5()
    % test6()
end

function test1()
    num_particles = 1000; %number of particles
    R = [5e-7 0; 0 1e-6];
    
    % Measurement noise covariance matrix [radians^2]
    Q = 0.01^2;
    Lambda_Psi = 0 * 0.0001;
    starting_state = [100 ; 0*pi/180]; %time, latitude in radians
    
    % Days per step
    delta_t = 0.1;
    
    % Standard deviation [minutes/day]
    time_process_noise = 1;
    
    % Standard deviation [radians/day]
    latitude_process_noise = 10^(-3);
    
    % Measurement noise standard deviation [degrees]
    measurement_noise = 0.57;
    rng(1)
    runlocalization_MCL(num_particles, R, Q, Lambda_Psi, starting_state, delta_t, time_process_noise, latitude_process_noise, measurement_noise, 1, true);
end

function test2()
    num_particles = 1000; %number of particles
    R = [5e-7 0; 0 1e-6];
    
    % Measurement noise covariance matrix [radians^2]
    Q = 0.01^2;
    Lambda_Psi = 0 * 0.0001;
    starting_state = [100 ; 45*pi/180]; %time, latitude in radians
    
    % Days per step
    delta_t = 0.1;
    
    % Standard deviation [minutes/day]
    time_process_noise = 1;
    
    % Standard deviation [radians/day]
    latitude_process_noise = 10^(-3);
    
    % Measurement noise standard deviation [degrees]
    measurement_noise = 0.57;
    rng(1)
    runlocalization_MCL(num_particles, R, Q, Lambda_Psi, starting_state, delta_t, time_process_noise, latitude_process_noise, measurement_noise, 2, true);
end

function test3()
    num_particles = 1000; %number of particles
    R = [5e-7 0; 0 1e-6];
    
    % Measurement noise covariance matrix [radians^2]
    Q = 0.01^2;
    Lambda_Psi = 0 * 0.0001;
    starting_state = [100 ; 89*pi/180]; %time, latitude in radians
    
    % Days per step
    delta_t = 0.1;
    
    % Standard deviation [minutes/day]
    time_process_noise = 1;
    
    % Standard deviation [radians/day]
    latitude_process_noise = 10^(-3);
    
    % Measurement noise standard deviation [degrees]
    measurement_noise = 0.57;
    rng(1)
    runlocalization_MCL(num_particles, R, Q, Lambda_Psi, starting_state, delta_t, time_process_noise, latitude_process_noise, measurement_noise, 3, true);
end

function test4()
    num_particles = 3000; %number of particles
    R = [5e-7 0; 0 50 * 1e-6];
    
    % Measurement noise covariance matrix [radians^2]
    Q = 0.01^2;
    Lambda_Psi = 0 * 0.0001;
    starting_state = [100 ; 45*pi/180]; %time, latitude in radians
    
    % Days per step
    delta_t = 0.1;
    
    % Standard deviation [minutes/day]
    time_process_noise = 1;
    
    % Standard deviation [radians/day]
    latitude_process_noise = 50 * 10^(-3);
    
    % Measurement noise standard deviation [degrees]
    measurement_noise = 0.57;
    rng(1)
    runlocalization_MCL(num_particles, R, Q, Lambda_Psi, starting_state, delta_t, time_process_noise, latitude_process_noise, measurement_noise, 4, true);
end


function test5()
    num_particles = 3000; %number of particles
    R = [5e-7 0; 0 200 * 1e-6];
    
    % Measurement noise covariance matrix [radians^2]
    Q = 0.01^2;
    Lambda_Psi = 0 * 0.0001;
    starting_state = [100 ; 45*pi/180]; %time, latitude in radians
    
    % Days per step
    delta_t = 0.1;
    
    % Standard deviation [minutes/day]
    time_process_noise = 1;
    
    % Standard deviation [radians/day]
    latitude_process_noise = 200 * 10^(-3);
    
    % Measurement noise standard deviation [degrees]
    measurement_noise = 0.57;
    rng(1)
    runlocalization_MCL(num_particles, R, Q, Lambda_Psi, starting_state, delta_t, time_process_noise, latitude_process_noise, measurement_noise, 5, true);
end

function test6()
    num_particles = 1000; %number of particles
    R = [5e-7 0; 0 1e-6];
    
    % Measurement noise covariance matrix [radians^2]
    Q = 0.01^2;
    Lambda_Psi = 0 * 0.0001;
    starting_state = [100 ; 0*pi/180]; %time, latitude in radians
    
    % Days per step
    delta_t = 0.1;
    
    % Standard deviation [minutes/day]
    time_process_noise = 1;
    
    % Standard deviation [radians/day]
    latitude_process_noise = 10^(-3);
    
    % Measurement noise standard deviation [degrees]
    measurement_noise = 0.57;
    rng(1)
    runlocalization_MCL(num_particles, R, Q, Lambda_Psi, starting_state, delta_t, time_process_noise, latitude_process_noise, measurement_noise, 6, false);
end