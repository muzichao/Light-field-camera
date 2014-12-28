function [nx,ny,error]=select_nx_ny(Kx,Ky,F,d,sen_N,D,d_D,d_m)
%% 是否呈现黑色网格化现象
error=0;
nx=zeros(1,Kx);
ny=zeros(1,Ky);
grad_num=menu('是否呈现黑色网格现象：','是','否','结束');

if grad_num==1
    %% 有黑色网格化现象
    % 因为每个传感器上对应的数字化场景的点的个数不为整数
    if (exist('d_D','var')==0)||(d_D==0)
        d_D=8;                                                             %场景是主透镜的多少倍
    end
    nx=linspace(-d_D*D/2,d_D*D/2,Kx);
    ny=linspace(-d_D*D/2,d_D*D/2,Ky);
    disp('呈现黑色网格现象：');
    disp(['场景是主透镜D的d_D倍，d_D=',num2str(d_D)]);
elseif grad_num==2
    %% 克服了黑色网格化现象
    % 使每个传感器上对应的场景中的数字化的点的个数为整数
    %v_re=F*d/(d-F)
    %sen_d/v_re=dd/d
    %dd=d*sen_d/v_re=d*(D/sen_N)*((d-F)/(F*d))=(D/sen_N)*(F-d)/F=(4/500)*(250-16)/16=0.117
    if (exist('d_m','var')==0)||(d_m==0)
        d_m=2;                                                             %每个传感器上对应场景中的点的个数
    end
    dd=(D/sen_N)*(d-F)/F;                                                  %表示每个场景间的最大间隔
    nx=linspace(-dd*Kx/(2*d_m),dd*Kx/(2*d_m),Kx);
    ny=linspace(-dd*Ky/(2*d_m),dd*Ky/(2*d_m),Ky);
    disp('不呈现黑色网格现象：');
    disp(['每个传感器对应的场景像素个数为：d_m=',num2str(d_m)]);
else
    error=1;
    return;
end