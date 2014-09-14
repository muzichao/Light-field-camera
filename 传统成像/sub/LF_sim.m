function [im,error]=LF_sim(obj,d,D,F,v,N_line,sen_d,sen_N)
%2012 12 24 by lichao
%功能：模拟传统相机成像
%用法：im=LF_sim(obj,D,F,v,N_line,sen_d,sen_N)
%obj:           场景
%d:             场景距离主透镜的距离
%D:             主透镜直径
%F:             主透镜焦距
%v:             成像位置，即传感器位置
%N_line:        主透镜采样率
%sen_d:         传感器直径
%sen_N:         传感器个数
%nx:            场景x坐标
%ny:            场景y坐标

im=zeros(sen_N);
%%  物体信息
Kx=size(obj,1);
Ky=size(obj,2);
d_D=8;                                                                      %场景是主透镜的多少倍
d_m=2;                                                                      %每个传感器上对应场景中的点的个数
[nx,ny,error]=select_nx_ny(Kx,Ky,F,d,sen_N,D,d_D,d_m);                      %d_D,d_m为可选参数，不输入时为d_D=8,d_m=2
if error==1
    return;
else
    fprintf('\n开始相机传输过程：\n');
end
%% 相机成像过程
M_len=[1 0;-1/F 1];                                                         %主透镜折射
T=[1 v;0 1];                                                                %主透镜与微透镜之间传播

sen_N_1=1/sen_d;                                                            %单位距离传感器个数

para_x=zeros(N_line,1);
para_rx=zeros(N_line,1);                                                    %光线在传感器上坐标
para_th=zeros(N_line,1);                                                    %光线与微透镜的夹角

para_y=zeros(N_line,1);
para_ry=zeros(N_line,1);
para_be=zeros(N_line,1);

n=linspace(-fix(D/2),fix(D/2),N_line);%透镜离散化

k_num=0.1;
for ix=1:Kx
    for jy=1:Ky
        if obj(ix,jy)~=0
            dx=nx(ix);                                                      %选择入射光在物体处的x坐标
            dy=ny(jy);                                                      %选择入射光在物体处的y坐标
            In=obj(ix,jy)/(N_line^2);                                       %每条光线的光强  此处有近似
            for i=1:N_line
                x=n(i);                                                     %透镜上离散坐标
                theta=atan((x-dx)/d);                                       %入射光与透镜的角度
                pq1_x=T*M_len*[x;theta];                                    %透镜的转换及移动距离v
                x1=pq1_x(1);
                para_th(i)=pq1_x(2);
                para_x(i)=sen_N_1*x1+fix(sen_N/2)+1 ;                       %调整后的x2  1--4001
                para_rx(i)=round(para_x(i));                                %传感器坐标为整数
            end
            for j=1:N_line
                y=n(j);
                beta=atan((y-dy)/d);
                pq1_y=T*M_len*[y;beta];                                     %透镜的转换及移动距离v
                y1=pq1_y(1);
                para_be(j)=pq1_y(2);
                para_y(j)=sen_N_1*y1+fix(sen_N/2)+1 ;                       %调整后的y2
                para_ry(j)=round(para_y(j));                                %传感器坐标为整数
            end
            for i=1:N_line
                for j=1:N_line
                    if ((n(i)^2+n(j)^2)<=(D/2)^2)&&(para_rx(i)<=sen_N)&&(para_ry(j)<=sen_N)&&(para_rx(i)>0)&&(para_ry(j)>0)
                        %((n(i)^2+n(j)^2)<=(D/2)^2)                                     主透镜圆形
                        %(para_rx(i)<=sen_N_total)&&(para_ry(j)<=sen_N_total)&&(para_rx(i)>0)&&(para_ry(j)>0) 在传感器范围内
                        rx=para_rx(i);
                        ry=para_ry(j);
                        midpara=im(rx,ry);
                        In1=midpara+In*sqrt(cos(para_th(i))^2+cos(para_be(j))^2);
                        im(rx,ry)=In1;
                    end
                end
            end
        end
    end
    if ix==fix(k_num*Kx)
        disp(['已完成',num2str(k_num*100),'%']);
        k_num=k_num+0.1;
    end
end