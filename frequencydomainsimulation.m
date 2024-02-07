clear all
clc

%% region of interest for replica data
grid_type=2; %grid points in 1=cubic, 2=cylindrical, or 3=rectangular domain, 0 for experimental results

%% creating grid points
if grid_type==1
%inputs
X=3:1:7;%[cm]
Y=3:1:7;%[cm]
Z=-12:1:-8;%[cm]
%
grid_points=grid_cubic(X,Y,Z);
scatter3(grid_points(:,1),grid_points(:,2),grid_points(:,3))

elseif grid_type==2
%inputs
r=10;%radius in [cm]
n_p=10;%parallel resolution
n_r=20;%meridian resolution
z=-0:-1:-25;%height in [cm]
%
body_points=grid_cylin(r,n_p,n_r,z);
j=1;    

%1st case and 2nd case4cm
% for i=1:numel(body_points(:,1))
% if body_points(i,1)>=3 || body_points(i,2)>=3    
% if body_points(i,1)>0 && body_points(i,2)>0    
% if sqrt((body_points(i,1))^2+(body_points(i,2))^2)>=3 && sqrt((body_points(i,1))^2+(body_points(i,2))^2)<=8
%     if body_points(i,3)<=-8 && body_points(i,3)>=-12    
%     grid_points(j,1)=body_points(i,1);
%     grid_points(j,2)=body_points(i,2);
%     grid_points(j,3)=body_points(i,3);
%     j=j+1;
%     end
%    end
% end
% end
% 
% end


for i=1:numel(body_points(:,1))
if abs(body_points(i,1))>=3 || abs(body_points(i,2))>=3    
%if body_points(i,1)>0 && body_points(i,2)>0    
if sqrt((body_points(i,1))^2+(body_points(i,2))^2)>=5 && sqrt((body_points(i,1))^2+(body_points(i,2))^2)<=7
    if body_points(i,3)<=-4 && body_points(i,3)>=-6    
    grid_points(j,1)=body_points(i,1);
    grid_points(j,2)=body_points(i,2);
    grid_points(j,3)=body_points(i,3);
    j=j+1;
    end
   end
%end
end

end


figure(1)
plot1=scatter3(grid_points(:,1),grid_points(:,2),grid_points(:,3),5,'black','filled');
% 
figure(2)
plot2=scatter3(body_points(:,1),body_points(:,2),body_points(:,3),1,'black','filled');

elseif grid_type==3
%%4cminputs   
X=-6:1:6;%[cm]
Y=-20:1:-4;%[cm]

%2cminputs   
% X=-8:1:8;%[cm]
% Y=-20:1:-2;%[cm]

%source
% X=-9:1:9;%[cm]
% Y=-20:1:-1;%[cm]

grid_points=grid_rect(X,Y);
%scatter(grid_points(:,1),grid_points(:,2),5 ,'black','filled')
end


%% simulation settings
sim_type=1; %creates replica=1 or experimental=2 dataset, 0 for off

%%inputs
f0=400;%[hz]
r_pocket=3;%[cm]
t_fat=2;%[cm]
Cd=150;
c_lung=30;
mph_name='v1_600hz';
%mic_numbers=[2; 3; 4; 5; 6; 7; 8; 9; 53; 54; 55; 56; 57; 58; 59; 60;]; %replica mics 2D
%mic_numbers=[2; 3; 4; 5; 6; 7; 8; 9; 57; 58; 59; 60; 61; 62; 63; 64;]; %experimental or water pocket mics 2D
mic_numbers=[2; 3; 4; 5; 29; 30; 31; 32; 33; 34; 35; 36; 58; 59; 60; 61; 136; 137; 138; 139; 168; 169; 170; 171; 172; 173; 174; 175; 199; 200; 201; 202;];
     %mic_numbers=[ 29; 30; 31; 32; 33; 34; 35; 36; 168; 169; 170; 171; 172; 173; 174; 175;];
%pocket location for experimental data
x_pocket=6;
y_pocket=4;
z_pocket=-10;
r_replica=2;

if sim_type==0
  model=mphload(mph_name);
% model.param.set('r_pocket',[num2str(r_pocket) '[cm]']);
% model.param.set('x_pocket',[num2str(x_pocket) '[cm]']);
% model.param.set('y_pocket',[num2str(y_pocket) '[cm]']);
% model.param.set('z_pocket',[num2str(z_pocket) '[cm]']);
% model.param.set('t_fat',[num2str(t_fat) '[cm]']);
% % model.study('std1').run
 else
 end

%%running simulation
if sim_type==1
   V_pre=sim_replica(grid_points,f0,r_pocket,mph_name,mic_numbers); %simreplica değiştir
   %%saving data
   save('V_3D_3cm_water_400hz.mat','V_pre')
elseif sim_type==2
   v_results=sim_exp(x_pocket,y_pocket,z_pocket,f0,r_pocket,mph_name,mic_numbers,t_fat,Cd,c_lung);
   save('v_results_3D_case4b_600hz.mat','v_results')
end


noise_type=0; %1=adding noise to exp data, 0=zero noise
noise_rate=0.5; %between 0 and 1, determ"ines error magnitude
if noise_type==1
   a=size(mic_numbers);
   noisy_signal=add_noise(v_results,noise_rate,a(1,1));
   save('v_results.mat','noisy_signal')
end

mph_name='v1_600hz_plotluk';
model=mphload(mph_name);

%% Matched-field processor

mfp_type=0; %mfp_type=1 for bartlett, 2 for mvdr
replica_data='V_3D_2cm_water_600hz';
exp_data='v_results_3D_case4b_600hz';

if mfp_type==1
   beta_norm=bartlett(grid_points,exp_data,replica_data);
elseif mfp_type==2
   beta_norm=mvdr(grid_points,exp_data,replica_data);
end
    
%% plotting
grid_type==0;

if grid_type==2
    figure (4)  
    hold on
    max_beta=max(beta_norm);
    r_replica=2;
    index_beta=find(beta_norm==max_beta);
    x_beta=grid_points(index_beta,1);
    y_beta=grid_points(index_beta,2);
    z_beta=grid_points(index_beta,3);
    error_d=sqrt((x_beta-x_pocket)^2+(y_beta-y_pocket)^2+(z_beta-z_pocket)^2);
    [x_b,y_b,z_b]=sphere;  
    X1 = x_b * r_replica;
    Y1 = y_b * r_replica;
    Z1 = z_b * r_replica;
    surf(X1+x_beta,Y1+y_beta,Z1+z_beta,'FaceAlpha',0.5,'FaceColor', [1 0 0])
    hold on
    [x_p,y_p,z_p]=sphere;
    X2 = x_p * r_pocket;
    Y2 = y_p * r_pocket;
    Z2 = z_p * r_pocket;        
    surf(X2+x_pocket,Y2+y_pocket,Z2+z_pocket,'FaceAlpha',0.5, 'FaceColor', [0 1 0])
    load('CustomColormap')    
    location_plot=figure(4);
    %scatter3(x_beta,y_beta,z_beta, 1200 ,'red' ,'filled');
    hold on
    beta_result=abs(max(beta_norm));
    scatter3(grid_points(:,1),grid_points(:,2),grid_points(:,3),2 ,'black','filled')
    hold on
    pd = mphplot(model, 'pg22');
    format_spec='%.2f';
    title(['Error = ' num2str(error_d,format_spec),' [cm] ',' B = ',num2str(beta_result, format_spec)])
    legend('Predicted Pocket', 'Actual Pocket', 'Grid Points')
    for i=1:3
    if i==1
    saveas(gcf,'case4biso.png')
    elseif i==2
    title('Side View')    
    view(360,0)
    saveas(gcf,'case4bside.png')
    elseif i==3
    title('Front View')    
    view(270,0)
    saveas(gcf,'case4bfront.png')
    end
    end
    
    
    
    
elseif grid_type==1
    
    load('CustomColormap')
    figure(3)
    scatter3(grid_points(:,1),grid_points(:,2),grid_points(:,3),50 ,beta_norm,'filled')
    hold on
    scatter3(x_pocket,y_pocket,z_pocket,100,'black','filled');
    colormap(flipud(CustomColormap));
    colorbar;
    legend(sprintf(' B = %0.5f',max(beta_norm)))
    
elseif grid_type==3

    load('CustomColormap')
    figure(3)
    scatter(grid_points(:,1),grid_points(:,2),50 ,beta_norm,'filled')
    hold on
    pd = mphplot(model, 'pg4');
    %scatter(x_pocket,y_pocket,2*100,'black','filled');
    colormap(flipud(CustomColormap));
    colorbar;
    legend(sprintf(' B = %0.5f',max(beta_norm)))
    
end

    
    


