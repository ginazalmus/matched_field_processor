function D_new=grid_cubic(X,Y,Z)
[X,Y,Z]=meshgrid(X,Y,Z); %Grid of XY coordinates%r2cm600hz
[M,N]=size(X);
X=reshape(X,[M*N,1]);
Y=reshape(Y,[M*N,1]);
Z=reshape(Z,[M*N,1]);

D_new(:,1)=X;
D_new(:,2)=Y;
D_new(:,3)=Z;
scatter3(D_new(:,1),D_new(:,2),D_new(:,3))
end