%2012 11 26 by lichao
%2012 11 29 修改
%2012 11 30 修改
%2D——4D
%透镜+微透镜
%适用于近轴光学

%本子程序功能：从微透镜成的像中重构出4D光场
%2012 12 13 修改 添加了微透镜后传感器的校正

function im_out=im_reshape2to4(im,micr_N,sen_N_total,sen_N,sen_coor)

if nargin<5
   error('im_recon:NotEnoughInputs', 'Not enough input arguments.');
end  

disp('正在将2维转4维：');


%% 参数信息
%sen_N每个微透镜后传感器个数
%micr_N微透镜个数
%sen_N_total传感器总个数

Nx=size(im,1);
Ny=size(im,2);
im_out=zeros(micr_N,micr_N,sen_N,sen_N);

%% 校正传感器数据
if Nx==sen_N_total
     im0=im;
elseif Nx==sen_N_total+1;
    im0=im(1:Nx-1,1:Ny-1);
else
    disp('传感器和微透镜个数不匹配!');
    return;
end

%%  转换为4_D
for i=2:micr_N-1
    for j=2:micr_N-1
        im_out(i-1,j-1,:,:)=im0(sen_coor(i,1):sen_coor(i,2),sen_coor(j,1):sen_coor(j,2));
    end
end


