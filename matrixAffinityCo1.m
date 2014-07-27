function [W]=matrixAffinityCo1(CoW,W,iter);
%LDCP

if ~exist('iter')
    iter = 3;
end

for k=1:iter
    W=CoW*W*CoW';
end