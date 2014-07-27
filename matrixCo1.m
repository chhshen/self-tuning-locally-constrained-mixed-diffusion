function [newW,W1,W2]=matrixCo1(W1,W2,K1,K2,c1,c2)
% construct a new affinity matrix from the input affinity matrices

[m,n]=size(W1);
%normalization
W1=W1./repmat(sum(W1,2),1,n);
W2=W2./repmat(sum(W2,2),1,n);

if length(K1)==1%SAN size
    K1 = K1*ones(m,1);
    K2 = K2*ones(m,1);
else
    %!HEURISTIC! Bound the SAN size (not too small or too large)
    av_K = mean(K1);
    tureK = min(2*av_K*ones(m,1),av_K);
    tureK = round(tureK);
    K1 = tureK;
    av_K = mean(K2);
    tureK = min(2*av_K*ones(m,1),av_K);
    tureK = round(tureK);
    K2 = tureK;
end

%construct the affinity matrix
[YW1,IW1] = sort(W1,2,'descend');
[YW2,IW2] = sort(W2,2,'descend');
newW1=zeros(m,n);
newW2=zeros(m,n);
for k=1:m
    newW1(k,IW1(k,1:K1(k)))=W1(k,IW1(k,1:K1(k)));
    newW2(k,IW2(k,1:K2(k)))=W2(k,IW2(k,1:K2(k)));
end
if numel(c1) == 1
    newW = newW1*c1 + newW2*c2;
else
    newW = newW1.*c1 + newW2.*c2;
end
newW=newW./repmat(sum(newW,2),1,n);

