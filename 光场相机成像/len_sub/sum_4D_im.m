function  out_im=sum_4D_im(d,v,N_line,micr_N)
%2012 12 22 by lichao
%将R,G,B三通道的4D光场按微透镜求和重构
%out_im=sum_4D_im(d,v,N_line,micr_N)
%d        场景距离 用于load
%v        微透镜距离 由于load
%N_line   主透镜采样率
%micr_N   微透镜个数
%im       （micr_N,micr_N,sen_N,sen_N）前两个表示微透镜位置，后两个子图像坐标
out_im=zeros(micr_N,micr_N,3);

im=[];
for k=1:3
    load (sprintf('./dataRGB/im_d_%d_v_%d_Nline_%d_%d.mat',d,v,N_line,k),'im');
    for i=1:micr_N
        for j=1:micr_N
            out_im(i,j,k)=sum(sum(im(i,j,:,:)));
        end
    end
end