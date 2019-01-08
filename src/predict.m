% function [S_bar] = predict(S,u,R)
% This function should perform the prediction step of MCL
% Inputs:
%           S(t-1)              3XM % previous timestep's particles
%           R                   2X2 % state model noise
%           delta_t             1X1 % time change per step
%           v                   1XM % weights of particles, to determine if
%                                       day adjust noise should be added
% Outputs:
%           S_bar(t)            4XM
function [S_bar] = predict(S, R, delta_t, v)
    M = size(S,2);
    assert(isequal(size(S,1), 3), 'S has wrong dimensions');
    noises = mvnrnd([0 0], R, M)';
    probs1 = normpdf(noises(1,:), 0, sqrt(R(1,1)));
    probs2 = normpdf(noises(2,:), 0, sqrt(R(2,2)));
    probs = probs1 .* probs2;
    probs = probs / max(probs);

    % Update the time + some noise
	S_bar(1,:) = S(1,:) + delta_t + noises(1,:);
    S_bar(2,:) = S(2,:);
    % Copy particle weights
    S_bar(3,:) = S(3,:) .* probs;

    % Update the time in full day increments
    for i = 1:M
        if rand < 0.005 % && sqrt(v(i)) > 0.003
           S_bar(1,i) = S_bar(1,i) + round(normrnd(0,1));
           S_bar(3,i) = S_bar(3,i) * 0.005;
        end

    end
    
    
    % Update the latitude with some noise
    S_bar(2,:) = S_bar(2,:) + noises(2,:);
    S_bar(2,:) = max(min(S_bar(2,:), pi/2), -pi/2);
end