% function [S,R,Q,Lambda_psi] = init(bound,start_pose)
% This function initializes the parameters of the filter.
% Inputs:
%           bound_t:        1X2 (lower, upper bounds on initial time estimate)
%           bound_l:        1x2 (lower, upper bounds on latitude)
%           start_pose:     2X1 (fixed initial time estimate)
% Outputs:
%			S(0):			3XM (particles;rows for time, latitude, weights)
%			R:				2X2 (process noise)
%			Q:				1X1 (measurement noise)
%           Lambda_psi:     1X1 (threshold for discarding outliers)
function [S,R,Q,Lambda_psi] = init(bound_t,bound_l, start_pose)
    M = 1000; %number of particles
    %part_bound = 20; %number of hypothesis groups

    if exist('start_pose', 'var')
        assert(isequal(size(start_pose), [2 1]), 'Start pose has wrong dimensions');
        S = [repmat(start_pose,1,M);
             1/M*ones(1,M)]; %state dimensions then weights
    else
        S = [rand(1,M)*(bound_t(2) - bound_t(1)) + bound_t(1);
             rand(1,M)*(bound_l(2) - bound_l(1)) + bound_l(1);
             1/M*ones(1,M)];
    end
    
    % Process noise covariance matrix
    R = [5e-7 0; 0 1e-6];
    
    % Measurement noise covariance matrix [radians^2]
    Q = 0.01^2;
    Lambda_psi = 0.0001;
end
