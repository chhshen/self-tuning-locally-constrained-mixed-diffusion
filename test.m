%demo

load 'Dist_SC_MPEG.mat';
load 'Dist_IDSC_MPEG.mat';
Diff1 = dist_SC; 
Diff2 = dist_IDSC;
NoShapes = 20;
NoClasses = 70;
NoTraining = 15;

tMaxN = 100; %inital kNN size
tMax1NN = 5; %threshold for confident SAN

fprintf('Computing the 1st affinity matrix...\n');
[K1,nDN1,DN1,tag1] = selfAdaptDistance2(Diff1,tMaxN,tMax1NN);
[W1]=affinityMatrix6(Diff1,round(mean(K1)),1/3); %use mean(K) to determine the Gaussian width

fprintf('Computing the 2rd affinity matrix...\n');
[K2,nDN2,DN2,tag2] = selfAdaptDistance2(Diff2,tMaxN,tMax1NN);
[W2]=affinityMatrix6(Diff2,round(mean(K2)),1/3); 

% co-training
fprintf('CoTraining...\n');
c1=0.5;
c2=1-c1;
[CoW,W1,W2] = matrixCo1(W1,W2,K1,K2,c1,c2);
newW = c1*W1+c2*W2;
iter=15;
score = zeros(iter,2);
precision=zeros(iter,2*NoShapes);
for i = 1:iter
    newW=matrixAffinityCo1(CoW,newW,1);
    accur=precisionBulleye(newW,NoShapes*ones(1,NoClasses));
    score(i,1) = accur(end/2); %precision of top 'NoShapes' ranking
    score(i,2) = accur(end);   %bulleye's score
    precision(i,:) = accur;
    fprintf('Iter %d bulleye score: %f\n',i,score(i,2));
end
