function V_pre=sim_exp(x_pocket,y_pocket,z_pocket,f0,r_pocket,mph_name,mic_numbers,t_fat,Cd,c_lung)
    model=mphload(mph_name);   
    mphgetexpressions(model.param);
    model.param.set('f0',[num2str(f0) '[Hz]']);
    model.param.set('r_pocket',[num2str(r_pocket) '[cm]']);
    model.param.set('x_pocket',[num2str(x_pocket) '[cm]']);
    model.param.set('y_pocket',[num2str(y_pocket) '[cm]']);
    model.param.set('z_pocket',[num2str(z_pocket) '[cm]']);
    model.param.set('t_fat',[num2str(t_fat) '[cm]']);
    model.param.set('Cd',[num2str(Cd) '[dB/m]']);
    model.param.set('c_lung',[num2str(c_lung) '[m/s]']);
    model.study('std1').run
    V = mphevalpoint(model,'sqrt((solid.u_tX)^2+(solid.u_tY)^2)','selection',mic_numbers); 
    V=transpose(V);
    V_pre=V;   
end