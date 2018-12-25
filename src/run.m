function run()
    test2()
end

function test1()
    M = 10000;
    part_bound = 10;
    start_pose = []; %[0, 0, 0]';
    if ~isempty(start_pose)
        S = [repmat(start_pose,1,M); 1/M*ones(1,M)];
    else
        S = [];
    end
    % Below here you may want to experiment with the values but these seem to work for most datasets.

    R = diag([1 1 1] * 0.01); %process noise covariance matrix
    Q = diag([0.1 0.1]); % measurement noise covariance matrix
    Lambda_psi = 0.0001;
    show_odo = true;
    show_gth = true;
    show_estimate = true;
    simoutfile = 'so_sym2_nk.txt';
    mapfile = 'map_sym2.txt';
    runlocalization_MCL(simoutfile, mapfile, show_estimate, show_gth, show_odo, S, R, Q, Lambda_psi, M, part_bound, 3);
end

function test2()
    M = 10000;
    part_bound = 10;
    start_pose = []; %[0, 0, 0]';
    if ~isempty(start_pose)
        S = [repmat(start_pose,1,M); 1/M*ones(1,M)];
    else
        S = [];
    end
    % Below here you may want to experiment with the values but these seem to work for most datasets.

    R = diag([1 1 1] * 0.01); %process noise covariance matrix
    Q = diag([0.1 0.1]); % measurement noise covariance matrix
    Lambda_psi = 0.0001;
    show_odo = true;
    show_gth = true;
    show_estimate = true;
    simoutfile = 'so_sym3_nk.txt';
    mapfile = 'map_sym3.txt';
    runlocalization_MCL(simoutfile, mapfile, show_estimate, show_gth, show_odo, S, R, Q, Lambda_psi, M, part_bound, 3);
end