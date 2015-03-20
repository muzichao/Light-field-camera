function im=LF_sim(obj,d_m,d,Cam,Sen,CS)
%2013 12 24 by lichao
%功能：模拟压缩感知相机成像
%用法：im=LF_sim(obj,D,F,v,N_line,sen_d,sen_N)
%obj:           场景
%d:             场景距离主透镜的距离
%D:             主透镜直径
%F:             主透镜焦距
%v:             成像位置，即传感器位置
%N_line:        主透镜采样率
%sen_d:         传感器直径
%sen_N:         传感器个数
%sen_L:         每个传感器重构出sen_L^2条直线
%nx:            场景x坐标
%ny:            场景y坐标
%CS:          编码参数

im=zeros(Sen.N,Sen.N,CS.M);
%%  物体信息
Kx=size(obj,1);
Ky=size(obj,2);
                                                                    
nx=linspace(-d_m*Cam.D/2,d_m*Cam.D/2,Kx);
ny=linspace(-d_m*Cam.D/2,d_m*Cam.D/2,Ky);
%% 相机成像过程
M_len=[1 0;-1/Cam.F 1];                                                         %主透镜折射
T=[1 Cam.v;0 1];                                                                %主透镜与微透镜之间传播

sen_N_1=1/Sen.d;                                                            %单位距离传感器个数

para_x=zeros(Cam.N_line,1);
para_rx=zeros(Cam.N_line,1);                                                    %光线在传感器上坐标
para_th=zeros(Cam.N_line,1);                                                    %光线与微透镜的夹角

para_y=zeros(Cam.N_line,1);
para_ry=zeros(Cam.N_line,1);
para_be=zeros(Cam.N_line,1);

n=linspace(-fix(Cam.D/2),fix(Cam.D/2),Cam.N_line);%透镜离散化
mask_n=fix((n+2)./(Cam.D/Sen.L))+1;
mask_n(Cam.N_line)=Sen.L;

for ix=1:Kx
    for jy=1:Ky
        if obj(ix,jy)~=0
            dx=nx(ix);                                                      %选择入射光在物体处的x坐标
            dy=ny(jy);                                                      %选择入射光在物体处的y坐标
            In=obj(ix,jy)/(Cam.N_line^2);                                       %每条光线的光强  此处有近似
            for i=1:Cam.N_line
                x=n(i);                                                     %透镜上离散坐标
                theta=atan((x-dx)/d);                                       %入射光与透镜的角度
                pq1_x=T*M_len*[x;theta];                                    %透镜的转换及移动距离v
                x1=pq1_x(1);
                para_th(i)=pq1_x(2);
                para_x(i)=sen_N_1*x1+fix(Sen.N/2)+1 ;                       %调整后的x2  1--4001
                para_rx(i)=round(para_x(i));                                %传感器坐标为整数
            end
            for j=1:Cam.N_line
                y=n(j);
                beta=atan((y-dy)/d);
                pq1_y=T*M_len*[y;beta];                                     %透镜的转换及移动距离v
                y1=pq1_y(1);
                para_be(j)=pq1_y(2);
                para_y(j)=sen_N_1*y1+fix(Sen.N/2)+1 ;                       %调整后的y2
                para_ry(j)=round(para_y(j));                                %传感器坐标为整数
            end
            for i=1:Cam.N_line
                for j=1:Cam.N_line
                    if ((n(i)^2+n(j)^2)<=(Cam.D/2)^2)&&(para_rx(i)<=Sen.N)&&(para_ry(j)<=Sen.N)&&(para_rx(i)>0)&&(para_ry(j)>0)
                        %((n(i)^2+n(j)^2)<=(D/2)^2)                                     主透镜圆形
                        %(para_rx(i)<=sen_N_total)&&(para_ry(j)<=sen_N_total)&&(para_rx(i)>0)&&(para_ry(j)>0) 在传感器范围内
                        rx=para_rx(i);
                        ry=para_ry(j);
                        midpara=im(rx,ry,:);
                        a_cs=reshape(CS.A(:,(mask_n(i)-1)*Sen.L+mask_n(j)),1,1,CS.M);
                        In1=midpara+In*a_cs*sqrt(cos(para_th(i))^2+cos(para_be(j))^2);
                        %In*a_cs((i-1)*N_line+j) 对光线强度进行编码
                        im(rx,ry,:)=In1;
                    end
                end
            end
            
        end
        
    end
end