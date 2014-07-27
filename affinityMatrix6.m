function [W]=affinityMatrix6(Diff,K,c)
% distance matrix -> affinity matrix
% Diff: distance matrix
% K: kNN size
% c: parameter

Diff=(Diff+Diff')/2;
[m,n]=size(Diff);

if length(K) ==1
    K =K*ones(m,1);
end

T = sort(Diff,2);
SIGMA = zeros(m,1);
for i = 1: m
    SIGMA(i) = sum(T(i,2:K(i)));
end
SIGMA = (repmat(SIGMA',m,1) + repmat(SIGMA,1,n))./...
    (repmat(K',m,1) + repmat(K,1,n));
%normpdf is better than guassian
SIGMA = SIGMA.^2.*(2*c^2);
W = exp(-Diff.^2./SIGMA)./(sqrt(pi.*SIGMA)); %normpdf
% W = exp(-(Diff./SIGMA./c).^2);