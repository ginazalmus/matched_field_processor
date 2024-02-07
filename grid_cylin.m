function D_new=grid_cylinder(r,n_p,n_r,z)
k=0;
for j=1:1:n_p %number of cylinders
for i=1:1:n_r %radial resolution
k=n_p*(j-1)+i;   
a_new(k,1)=r*j/n_p*cosd(360*(i-1)/n_r);
a_new(k,2)=r*j/n_p*sind(360*(i-1)/n_r);
end

end
x1=a_new(:,1);
x2=a_new(:,2);
a1=[x1; -x1; x1; -x1; 0];
a2=[x2; x2; -x2; -x2; 0];
size_2d=size(a1,1); 

for i=1:numel(z)
Z_coord=ones(size_2d,1);
Z_coord=z(i)*Z_coord;
D(:,:,i)=[a1,a2,Z_coord];
end

D_new = permute(D,[1 3 2]);
D_new = reshape(D_new,[],size(D,2),1);

scatter3(D_new(:,1),D_new(:,2),D_new(:,3))