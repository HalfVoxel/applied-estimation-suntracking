% function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
	M = size(S_bar, 2);
	n = size(z, 2);
	N = size(W, 2);

	Psi = zeros(1,n,M);
	outlier = zeros(1,n);
	Qi = inv(Q);
    c = 1/(2*pi*sqrt(det(Q)));

	for i=1:n
		psi_i = zeros(1, M);
		for j=1:N
			z_bar = observation_model(S_bar, W, j);
			nu = z(:,i) - z_bar;
			nu(2,:) = wrap_angle(nu(2,:));
			psi_i_j = zeros(1, M);
			for m=1:M
				v = 0.5 * nu(:,m)' * Qi * nu(:,m);
				psi_i_j(m) = c * exp(-v);
			end
			psi_i = max(psi_i, psi_i_j);
		end
		Psi(1,i,:) = psi_i;
		outlier(1,i) = 1/M * sum(psi_i) <= Lambda_psi;
    end
end

function alpha = wrap_angle(alpha)
    alpha = mod(alpha+pi, 2*pi)-pi;
end
