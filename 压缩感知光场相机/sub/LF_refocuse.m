function im1=LF_refocuse(obj,v_re,Cam,Sen)
%2013 7 29 by lichao
%功能：压缩感知光场重聚焦
%用法：im1=LF_refocuse(obj,v_re,Cam，Sen)
%obj:               场景
%Cam.d:             场景距离主透镜的距离
%Cam.D:             主透镜直径
%Cam.v:             成像位置，即传感器位置
%Cam.N_line:        主透镜采样率
%Sen.d:             传感器直径
%Sen.N:             传感器个数
%Sen.L              每个传感器重构的光线数
%v_re               重聚焦位置

im1=zeros(Sen.N);
%%  物体信息
Kx=size(obj,1);                                                            %四维光场的第一维  对应传感器坐标
Ky=size(obj,2);                                                            %四维光场的第二维  对应传感器坐标
sen_N_1=1/Sen.d;                                                           %单位距离传感器个数

%% 相机重聚焦过程
mask_d=Cam.D/Sen.L;
n=linspace(-(Cam.D-mask_d)/2,(Cam.D-mask_d)/2,Sen.L);
%n=linspace(-fix(Cam.D/2),fix(Cam.D/2),Sen.L);
for ix=1:Kx
    for jy=1:Ky
        if sum(sum(obj(ix,jy,:,:)))~=0
            para_x=-Cam.D/2+(ix-0.5)*Sen.d ;                                   %此传感器对应的x坐标
            para_y=-Cam.D/2+(jy-0.5)*Sen.d ;                                   %此传感器对应的y坐标
            
            para_rx=(-n+para_x)/Cam.v*v_re+n;%求光线重聚焦对应的x坐标
            prx=para_rx*sen_N_1+fix(Sen.N/2)+1;%求光线重聚焦对应的传感器x坐标

            para_ry=(-n+para_y)/Cam.v*v_re+n;%求光线重聚焦对应的y坐标
            pry=para_ry*sen_N_1+fix(Sen.N/2)+1;%求光线重聚焦对应的传感器y坐标      
            
            for i=1:Sen.L
                for j=1:Sen.L
                    if ((n(i)^2+n(j)^2)<=(Cam.D/2)^2)&&(prx(i)<=Sen.N)&&(pry(j)<=Sen.N)&&(obj(ix,jy,i,j)>0)
                        rx=round(prx(i));
                        ry=round(pry(j));
                        midpara=im1(rx,ry);
                        im1(rx,ry)=midpara+obj(ix,jy,i,j);
                    end
                end
            end
            
        end
    end
end

