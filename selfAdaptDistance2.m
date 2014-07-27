function [K,nDN,DN,tag]=selfAdaptDistance2(Diff,tMaxN,tMax1NN)%,tC,tMinD,tMaxN)
% compute the self adapt neighborhood
% input: 
% Diff is the distance matrix
% tMaxN is the size of initial kNN
% tMax1NN is the threshold for confident SAN
% output: 
% DN is the dominant neighbors of input distance matrix
% K is positions of the furthest Dominant Neighbor in KNN
% nND is the number of DN
% tag index the DN's of the initial kNN


Diff=(Diff+Diff')/2;
[T,INDEX]=sort(Diff,2);
[m,n]=size(Diff);
if n<=tMaxN+1
    tMaxN = n-1;
end
%find the first non-zero neighbor (zeros may hazard the computation of
%Dominant Neighbors)
k_1NN = 2*ones(m,1);
for i=1:m 
    tempN = 2;%size of current KNN
    while T(i,tempN) == 0
        tempN = tempN + 1;
    end
    k_1NN(i) =  tempN;
end
% N = k_1NN;

I_N = zeros(m,tMaxN);
I_N(:,1) = [1:m]';%set querys as the first neighbors of theirselves
for i = 1:m
    I_N(i,2:end) = INDEX(i,k_1NN(i):tMaxN+k_1NN(i)-2);
end
DN = cell(m,1);%Dominant Neighbors
K = zeros(m,1);%position of the last Dominant Neighbor in KNN
nDN = zeros(m,1);%size of Dominant Neighbor Set
tag = false(m,1);
for i = 1:m
    DN{i}=DominantNeighbor(Diff(I_N(i,:),I_N(i,:)),I_N(i,:));
    K(i) = find(I_N(i,:)==DN{i}(end))+k_1NN(i)-2;
    nDN(i) = length(DN{i});
    if DN{i}(1) ~= i || find(I_N(i,:)==DN{i}(2))+k_1NN(i)-2 > tMax1NN
        tag(i)= true;
    end
end
% sum(tag)
% K_Ave = round(mean(K(~tag)));
% K(tag) = K_Ave;