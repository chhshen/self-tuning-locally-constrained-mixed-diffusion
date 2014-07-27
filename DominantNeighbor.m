function [DN] = DominantNeighbor(W,DN)
%find dominant neighbors
%input W is the affinity matrix
%input DN is the initial neighboring set (by kNN)
%output DN is the found dominant neighbors

[K1,K2]= size(W);
if K1~=K2
    fprintf('The input matrix should be square./n');
    return;
end
K = K1;

% W = (W-mean(W(:)))/std(W(:));
maxW = max(W(:));
W = maxW-W;
W = W./repmat(sum(W,2),1,K2);
weight = (W(1,:)/sum(W(1,:)));%the weight of a neighbor corresponds to its similarity with the query object
W([0:K1-1].*K2+[1:K1])=0; %the weighted graph has no self-circle, so set the diag to zeros

% w0 = 0;
% weight = (W(1,:)/sum(W(1,:)))*(1-w0); %the weight of a neighbor corresponds to its similarity with the query object
% weight(1) = w0; % set the weight of the query object to w0

weight = weight.^.5;
weight = weight/sum(weight);
W = diag(weight) * W * diag(weight);

t1 = 1000; %max iteration
t2 = 1/100/K; %zero bound, number less than t2 is condider as zero
% x = ones(K,1)/K/2;
% x(1) = x(1)+0.5;
% x = ones(K,1)/K;
x = weight'.^2;
% x = weight';
for i = 1:t1
    xNew = x.*(W*x/(x'*W*x));
    xNew(xNew<t2) = 0;
    if sum(abs(x-xNew))<t2
        break;
    end
    x = xNew;
end
DN = DN(x~=0);