% function S_bar = weight(S_bar,Psi,outlier)
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar,Psi,outlier)
    Psi(1,outlier == true,:) = 1;
    S_bar(4,:) = prod(Psi,2);
    S_bar(4,:) = S_bar(4,:) / sum(S_bar(4,:));
end
