function im_out=im_recon3(D,d,v,N_line,lens_d)
%2012 11 26 by lichao
%2012 12 13 修改
%添加了对微透镜后对应传感器的校正
%2012 12 20 修改
%由灰度图像到RGB图像
%对RGB型光场原始图像按R、G、B三通道分别进行求和重构
%适用于近轴光学
%im_out=im_recon3(D,d,v,N_line,lens_d)
%D          对应主透镜直径
%d          场景距离，用来load
%v          微透镜位置
%Nline      主透镜上光线采样数
%lens_d     对应微透镜直径


if nargin<5
   error('im_recon:NotEnoughInputs', 'Not enough input arguments.');
end  

fprintf('\n正在对RGB型光场原始图像进行求和法重构：\n');


%% 参数信息
micr_N=fix(D/lens_d);%微透镜个数
im_out=zeros(micr_N,micr_N,3);
im=[];

%%  微透镜求和
for k=1:3
    load (sprintf('./dataRGB/im_d_%d_v_%d_Nline_%d_%d.mat',d,v,N_line,k),'im');
    for i=1:micr_N
        for j=1:micr_N
            im_out(i,j,k)=sum(sum(im(i,j,:,:)));
        end
    end
end



