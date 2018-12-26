% function [S_bar] = predict(S,u,R)
% This function should perform the prediction step of MCL
% Inputs:
%           S(t-1)              3XM % previous timestep's particles
%           R                   2X2 % state model noise
%           delta_t             1X1
% Outputs:
%           S_bar(t)            4XM
function [S_bar] = predict(S, R, delta_t)
    M = size(S,2);
    assert(isequal(size(S,1), 3), 'S has wrong dimensions');
    noises = mvnrnd([0 0], R, M)';
    % Update the time + some noise
	S_bar(1,:) = S(1,:) + delta_t + noises(1,:);
    % Update the time in full day increments
    S_bar(1,:) = S_bar(1,:) + round(normrnd(0,0.2,1,M));
    % Update the latitude with some noise
    S_bar(2,:) = S(2,:) + noises(2,:);
    %assert(numel(find(S_bar(1,:) < S(1,:))) < 0.05*M, ...
    %    'Error: More than 5% of particles moved backwards in time with update.');
    % Copy particle weights
    S_bar(3,:) = S(3,:);
end