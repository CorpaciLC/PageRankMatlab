function [ x ] = PageRank( A, tol )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

d = 0.85; %damping factor
n = size(A,2);
c = sum(A,1); %suma pe coloane a A
k = find(c~=0); %poz i la care c(i) !=0
D = sparse(k,k,1./c(k), n, n); %matrice diagonala cu elem 1/c
e = ones(n,1);
I = speye(n,n);

z = ((1-d)*(c~=0) + (c==0))/n;
M = d*A*D + e*z;
x = e/n;
oldx = zeros(n,1);
while(norm(x - oldx) > tol)
    oldx = x;
    x = (I - M)\e;
end
x = x/sum(x);

end

