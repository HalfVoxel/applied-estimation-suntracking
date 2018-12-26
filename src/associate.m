% function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
%           S_bar(t)            3XM (particles)
%           z(t)                1X1 (observed sun height)
%           Lambda_psi          1X1 (threshold for outliers)
%           Q                   1X1 (predicted observation noise)
% Outputs: 
%           outlier             1X1 (outlier indicator vector)
%           Psi(t)              1XM (maximum likelihood)
function [outlier,Psi] = associate(S_bar,z,Lambda_psi,Q)
	M = size(S_bar, 2);
	Qi = inv(Q);
    c = 1/(2*pi*sqrt(det(Q)));
    Psi = zeros(1, M);

	z_bar = observation_model(S_bar);
	nu = z - z_bar;
    for m=1:M
		v = -0.5 * nu(:,m)' * Qi * nu(:,m);
		Psi(m) = c * exp(v);
    end
	outlier = 1/M * sum(Psi) <= Lambda_psi;
end