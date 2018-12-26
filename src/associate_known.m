% function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
%           known_associations  1Xn
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
    assert(false, 'associate_known was called');
	M = size(S_bar, 2)
	n = size(z, 2)

	Psi = zeros(1,n,M);
	outlier = zeros(1,n);
	Qi = inv(Q);

	for i=1:n
		z_bar = observation_model(S_bar, W, known_associations(i));
		nu = z(:,i) - z_bar;
		nu(2) = wrap_angle(nu(2));
		psi_i = exp(-0.5 * nu' * Qi * nu);
		Psi(1,i,:) = psi_i;
		outlier(1,i) = 1/M * sum(psi_i) <= Lambda_psi;
	end

	% FILL IN HERE

	%BE SURE THAT YOUR innovation 'nu' has its second component in [-pi, pi]

	% also notice that you have to do something here even if you do not have to maximize the likelihood.

end

function alpha = wrap_angle(alpha)
    alpha = mod(alpha+pi, 2*pi)-pi;
end
