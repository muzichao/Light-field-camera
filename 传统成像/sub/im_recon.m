%2012 11 26 by lichao
%2D
%透镜+微透镜
%适用于近轴光学
%本子程序功能：从微透镜成的像中重构原始图像
%2012 12 13 修改
%添加了对微透镜后对应传感器的校正

function im_out=im_recon(im_out1,D,lens_d,sen_d,sen_coor)
%D对应主透镜直径
%lens_d 对应微透镜直径
%sen_d 对应传感器直径
%sen_coor 每个微透镜对应的传感器坐标
if nargin<5
   error('im_recon:NotEnoughInputs', 'Not enough input arguments.');
end  

disp('正在进行求和法图像重构：');


%% 参数信息
micr_N=fix(D/lens_d);%微透镜个数
sen_N_total=fix(D/sen_d);%传感器总个数

Nx=size(im_out1,1);
Ny=size(im_out1,2);
im_out=zeros(micr_N);

%% 校正传感器数据
if Nx==sen_N_total
     im0=im_out1;
elseif Nx==sen_N_total+1;
    im0=im_out1(1:Nx-1,1:Ny-1);
else
    disp('传感器和微透镜个数不匹配!');
    return;
end

%%  微透镜求和
for i=2:micr_N-1
    for j=2:micr_N-1
        im_out(i-1,j-1)=sum(sum(im0(sen_coor(i,1):sen_coor(i,2),sen_coor(j,1):sen_coor(j,2))));
    end
end


