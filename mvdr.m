function beta_norm=mvdr(D_new,exp_data,replica_data)
load(exp_data)
load(replica_data)
y_sensor=v_results;
y_sensor=y_sensor/norm(y_sensor);
y_conj=conj(y_sensor);
y_h=transpose(y_conj);
C=y_sensor*y_h;
C_inv=C\ones(size(C));

for i=1:numel(V_pre(1,:))
   V_norm=V_pre(:,i); 
   V_norm=V_norm/norm(V_norm);
   V_conj=conj(V_norm);
   V_h=transpose(V_conj);
   %MVDR Processor
   beta(i)=(1)/(V_h*C_inv*V_norm);
end
%Normalizing MVDR results
beta=sqrt(real(beta).^2+imag(beta).^2);

beta = beta - min(beta(:));
beta = beta ./ max(beta(:)); 
beta_norm=beta;
beta_r0=max(beta_norm);

½finding the location of the maximum value
[argvalue, argmax] = max(beta_norm);
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
