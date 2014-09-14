function im=LF_sim(obj,d,d_m,D,N_line,F,v,lens_d,lens_f,sen_N)
%2012 12 19 by lichao
%模拟场景obj在距离d处的光场成像
%用法：im=LF_sim(obj,d,d_m,D,N_line,F,v,lens_d,lens_f,sen_N)
%obj            场景
%d              场景距离
%d_m            场景是主透镜的多少倍
%D              主透镜直径
%N_line         主透镜上光学采样数
%F              主透镜焦距
%v              微透镜位置
%lens_d         微透镜直径
%lens_f         微透镜焦距
%sen_N_total    总的传感器个数
%sen_N          每个微透镜后传感器个数

disp('正在对场景进行光场成像模拟：');
sen_d=lens_d/sen_N;%传感器直径

n=linspace(-fix(D/2),fix(D/2),N_line);%透镜离散化

M_len=[1 0;-1/F 1];%主透镜折射
T=[1 v;0 1];%主透镜与微透镜之间传播
M_lens=[1 0;-1/lens_f,1];%微透镜折射矩阵
T_lens=[1,lens_f;0,1];%微透镜到传感器的传播
micr_N=fix(D/lens_d);%微透镜个数
im=zeros(micr_N,micr_N,sen_N,sen_N);%四维光场数据

micr_sen=micr_sen_center(D,micr_N,F,v);%求出微透镜子图像中心

para_x=zeros(N_line,1);
para_rx=zeros(N_line,1);%光线在传感器上坐标
para_th=zeros(N_line,1);%光线与微透镜的夹角
para_Nx=zeros(N_line,1);%光学位于第几个微透镜

para_y=zeros(N_line,1);
para_ry=zeros(N_line,1);
para_be=zeros(N_line,1);
para_Ny=zeros(N_line,1);

%%%%%%%%%%%%%%%%-------场景信息--------------------%%%%%%%%%%%%%%%%%%%%%
Kx=size(obj,1);
Ky=size(obj,2);

nx=linspace(-d_m*D/2,d_m*D/2,Kx);
ny=linspace(-d_m*D/2,d_m*D/2,Ky);

%%%%%%%%%%%%%%%-------模拟光场成像-obj-------------------%%%%%%%%%%%%%%%%%%%%%%
tic
k_num=0.1;
for ix=1:Kx
    for jy=1:Ky
        if obj(ix,jy)~=0
            dx=nx(ix);%选择入射光在物体处的x坐标
            dy=ny(jy);%选择入射光在物体处的y坐标
            In=obj(ix,jy)/(N_line^2);%每条光线的光强  此处有近似
            for i=1:N_line
                x=n(i); %透镜上离散坐标
                theta=atan((x-dx)/d);%入射光与透镜的角度
                
                pq1_x=T*M_len*[x;theta];%透镜的转换及移动距离v
                x1=pq1_x(1);
                %theta1=pq1_x(2);
                
                if x1>0                     %朝远离0的方向取整
                    lens_Nx=ceil(x1/lens_d);%第几个微透镜  0轴以上
                    para_Nx(i)=lens_Nx+fix(micr_N/2);
                elseif x1<0
                    lens_Nx=floor(x1/lens_d);%第几个微透镜 0轴以下
                    para_Nx(i)=lens_Nx+micr_N/2+1;
                elseif x1==0
                    lens_Nx=0;
                    para_Nx(i)=0;
                end
                
                if lens_Nx>0
                    s=lens_d*lens_Nx-0.5*lens_d;
                elseif lens_Nx<0
                    s=lens_d*lens_Nx+0.5*lens_d;
                elseif lens_Nx==0;
                    s=0;
                end
                pq2_x=T_lens*(M_lens*pq1_x+[0;s/lens_f]);%微透镜的转换作用及移动距离f
                x2=pq2_x(1);
                para_th(i)=pq2_x(2); %theta2;
                if (para_Nx(i)<=micr_N)&&(para_Nx(i)>0)
                    para_x(i)=x2+D/2-micr_sen(para_Nx(i));      %将x中心调到该微透镜子图像的中心
                    para_rx(i)=ceil((para_x(i)+sen_N/2*sen_d)/sen_d);%光线在微透镜子图像中对应的坐标
                else
                    para_x(i)=0;
                    para_rx(i)=0;
                end
            end
            
            for j=1:N_line
                y=n(j);
                beta=atan((y-dy)/d);
                
                pq1_y=T*M_len*[y;beta];%透镜的转换及移动距离v
                y1=pq1_y(1);
                
                if y1>0              %朝远离0的方向取整
                    lens_Ny=ceil(y1/lens_d);%第几个微透镜
                    para_Ny(j)=lens_Ny+fix(micr_N/2);
                elseif y1<0
                    lens_Ny=floor(y1/lens_d);%第几个微透镜
                    para_Ny(j)=lens_Ny+micr_N/2+1;
                elseif y1==0
                    lens_Ny=0;
                    para_Ny(j)=0;
                end
                if lens_Ny>0
                    s=lens_d*lens_Ny-0.5*lens_d;
                elseif lens_Ny<0
                    s=lens_d*lens_Ny+0.5*lens_d;
                elseif lens_Ny==0;
                    s=0;
                end
                pq2_y=T_lens*(M_lens*pq1_y+[0;s/lens_f]);%微透镜的转换作用及移动距离f
                y2=pq2_y(1);
                para_be(j)=pq2_y(2); %,beta2;
                if (para_Ny(j)>0)&&(para_Ny(j)<=micr_N)
                    para_y(j)=y2+D/2-micr_sen(para_Ny(j)) ;      %调整后的y2
                    para_ry(j)=ceil((para_y(j)+sen_N/2*sen_d)/sen_d);
                else
                    para_y(j)=0;
                    para_ry(j)=0;
                end
            end
            
            %((n(i)^2+n(j)^2)<=(D/2)^2) 主透镜圆形
            %(para_rx(i)<=sen_N_total)&&(para_ry(j)<=sen_N_total)&&(para_rx(i)>0)&&(para_ry(j)>0) 在传感器范围内
            
            for i=1:N_line
                for j=1:N_line
                    rx=para_rx(i);
                    ry=para_ry(j);
                    len_x=para_Nx(i);
                    len_y=para_Ny(j);
                    if ((n(i)^2+n(j)^2)<=(D/2)^2)&&(rx<=sen_N)&&(ry<=sen_N)&&(rx>0)&&(ry>0)&&(len_x~=0)&&(len_y~=0)
                        midpara=im(len_x,len_y,rx,ry);
                        In1=midpara+In*sqrt(cos(para_th(i))^2+cos(para_be(j))^2);
                        im(len_x,len_y,rx,ry)=In1;
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
