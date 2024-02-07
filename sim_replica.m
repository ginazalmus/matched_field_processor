function V_pre=sim_replica(D_new,f0,r_pocket,mph_name,mic_numbers)
for i=1:numel(D_new(:,1))
    model=mphload(mph_name);   
    mphgetexpressions(model.param);
    model.param.set('f0',[num2str(f0) '[Hz]']);
    %pocket
    model.param.set('r_pocket',[num2str(r_pocket) '[cm]']);
    model.param.set('x_pocket',[num2str(D_new(i,1)) '[cm]']);
    model.param.set('y_pocket',[num2str(D_new(i,2)) '[cm]']);
    model.param.set('z_pocket',[num2str(D_new(i,3)) '[cm]']);
    %source
%   model.param.set('x_source',[num2str(D_new(i,1)) '[cm]']);
%   model.param.set('y_source',[num2str(D_new(i,2)) '[cm]']);
    model.study('std1').run
    V = mphevalpoint(model,'sqrt((solid.u_tX)^2+(solid.u_tY)^2)','selection',mic_numbers); 
    V=transpose(V);
    V_pre(:,i)=V;   
end
end