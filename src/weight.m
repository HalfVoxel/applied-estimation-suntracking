% function S_bar = weight(S_bar,Psi,outlier)
%           S_bar(t)            3XM
%           outlier             1X1
%           Psi(t)              1XM
% Outputs: 
%           S_bar(t)            3XM (reweighted S_bar)
function S_bar = weight(S_bar,Psi,outlier)
    Psi(1,outlier == true,:) = 1;
    S_bar(3,:) = Psi / sum(Psi,2);
end
