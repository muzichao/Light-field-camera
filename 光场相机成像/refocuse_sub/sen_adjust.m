function sen_coor=sen_adjust(D,micr_N,F,v,sen_N)
%D=4;主透镜直径
%micr_N=200;微透镜个数
%lens_d=D/micr_N;微透镜直径
%sen_N=20;每个微透镜后的像素个数
%sen_d=lens_d/sen_N;微透镜直径
%F=16; 焦距
%v=16; 微透镜位置

lens_d=D/micr_N;%微透镜直径
sen_N_total=micr_N*sen_N;%总的传感器个数
sen_d=lens_d/sen_N;%传感器直径

lens_v=F/D*lens_d;%微透镜与传感器距离

sen_v=lens_v+v;%传感器位置
y_edge=zeros(micr_N,2);%用于保存每个微透镜的上限和下限

%% 确定每个微透镜的中心坐标
y=linspace(0,D/2,micr_N+1);
yy=reshape(y(1:micr_N),2,micr_N/2);
yy1=yy(2,:);

yy2=-fliplr(yy1);

y_axis=cat(2,yy2,yy1);

%% 确定微透镜对应的传感器边缘
for i=1:micr_N    
    y3=get_Y([0,v],[2,y_axis(i)],sen_v);%确定过主透镜上边缘和某个微透镜中心的直线在传感器上的纵坐标
    y_edge(i,1)=y3;           %保存上限坐标 
    y3=get_Y([0,v],[-2,y_axis(i)],sen_v);%确定过主透镜下边缘和某个微透镜中心的直线在传感器上的纵坐标
    y_edge(i,2)=y3;          %保存下限坐标
end

%%  计算每个微透镜后面对应的传感器误差
y0=linspace(-D/2,D/2,micr_N+1);%微透镜边缘

y_anis=zeros(micr_N,2);

for i=1:micr_N
    y_anis(i,1)=y0(i);
    y_anis(i,2)=y0(i+1);
end


y_error=y_anis-y_edge;%微透镜边缘与实际对应的传感器边缘误差

y_sensor_error=y_error/sen_d;%每个微透镜对应传感器的误差个数

y_sen_error=round(y_sensor_error);%误差个数取整

sen_adjust=y_sen_error(:,1);%每个微透镜保存一个即可


%%  计算每个微透镜对应的传感器范围
sen_co=linspace(0,sen_N_total,micr_N+1);
sen_coor=zeros(micr_N,2);
for i=1:micr_N
    sen_coor(i,1)=sen_co(i)+1+sen_adjust(micr_N-i+1);
    sen_coor(i,2)=sen_co(i+1)+sen_adjust(micr_N-i+1);
end