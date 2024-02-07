function D_new=grid_rect(X,Y)
[X,Y]=meshgrid(X,Y);
[M,N]=size(X);
X=reshape(X,[M*N,1]);
Y=reshape(Y,[M*N,1]);

D_new(:,1)=X;
D_new(:,2)=Y;

scatter(D_new(:,1),D_new(:,2))
end