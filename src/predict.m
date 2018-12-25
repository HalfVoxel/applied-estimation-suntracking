% function [S_bar] = predict(S,u,R)
% This function should perform the prediction step of MCL
% Inputs:
%           S(t-1)              4XM
%           v(t)                1X1
%           omega(t)            1X1
%           R                   3X3
%           delta_t             1X1
% Outputs:
%           S_bar(t)            4XM
function [S_bar] = predict(S,v,omega,R,delta_t)
	dx = cos(S(3,:)).*v.*delta_t;
	dy = sin(S(3,:)).*v.*delta_t;
	dtheta = ones(1, size(S, 2)) * omega.*delta_t;
    std = sqrt(diag(R));
	w = S(4,:);
	S_bar = S + [dx; dy; dtheta; w] + [std .* randn(3, size(S,2)); zeros(1, size(S,2))];
end