function beta_norm=bartlett(D_new,exp_data,replica_data)
load(exp_data)
load(replica_data)
y_sensor=v_results;
y_sensor(24)=y_sensor(1);
y_sensor=y_sensor/norm(y_sensor);
y_conj=conj(y_sensor);
y_h=transpose(y_conj);
C=y_sensor*y_h;

%Linear Processor
for i=1:numel(V_pre(1,:))
   V_norm=V_pre(:,i); 
   V_norm=V_norm/norm(V_norm);
   V_conj=conj(V_norm);
   V_h=transpose(V_conj);
   beta(i)=(V_h*C*V_norm);
end
%Normalizing MVDR results
% beta = beta - min(beta(:));
% beta = beta ./ max(beta(:)); 
%%%%
beta_norm=beta;
beta_r0=max(beta_norm);
%%%%

%%%Maksimum bulma
[argvalue, argmax] = max(beta_norm);

%%%Maksimum pointlerin location kayıdı
D_max(1,1)=D_new(argmax,1);
D_max(1,2)=D_new(argmax,2);

for i=1:numel(beta_norm)
     if i==argmax
         beta_norm(i)=beta_norm(i);
     else
         beta_norm(i)=0;
     end
end


end