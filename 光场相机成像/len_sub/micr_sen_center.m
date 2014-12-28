function out=micr_sen_center(D,micr_N,F,v)
%D=4;主透镜直径
%micr_N=200;微透镜个数
%lens_d=D/micr_N;微透镜直径
%sen_N=20;每个微透镜后的像素个数
%sen_d=lens_d/sen_N;微透镜直径
%F=16; 焦距
%v=16; 微透镜位置

lens_d=D/micr_N;%微透镜直径

lens_v=F/D*lens_d;%微透镜与传感器距离

sen_v=lens_v+v;%传感器位置
out=zeros(micr_N,1);%用于保存每个微透镜的上限和下限

%% 确定每个微透镜的中心坐标
y=linspace(0,D/2,micr_N+1);
yy=reshape(y(1:micr_N),2,micr_N/2);
yy1=yy(2,:);

yy2=-fliplr(yy1);

y_axis=cat(2,yy2,yy1);

%% 确定主透镜——微透镜中心对应的传感器位置
for i=1:micr_N    
    y3=get_Y([0,v],[0,y_axis(i)],sen_v);%确定过主透镜上边缘和某个微透镜中心的直线在传感器上的纵坐标
    out(i,1)=y3;           %保存上限坐标 
end

out=out+D/2;%将中心轴跳到0处

