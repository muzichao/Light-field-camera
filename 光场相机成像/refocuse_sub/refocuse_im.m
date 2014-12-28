function im_re=refocuse_im(D,alpha,d,v,Nline,micr_N,sen_N)
%2012 12 20 by lichao
%对RGB图像分别按R、G、B三通道进行重聚焦
%用法：im_rec=refocuse_im(D,micr_N,sen_N,sen_N_total,sen_coor)
%D              主透镜直径
%alpha          v_re/v理想重聚焦系数
%d              场景距离，用来load
%v              微透镜位置
%Nline          主透镜光线采样数
%micr_N         微透镜个数
%sen_N          每个微透镜后传感器个数
%sen_N_total    传感器总个数
%sen_coor       校正后的每个微透镜对应的传感器坐标

disp('正在进行数字重聚焦：');

im=zeros(micr_N,micr_N,sen_N,sen_N);
im_re=zeros(micr_N,micr_N,3);
KK_num=3;

uv=linspace(0,D,sen_N);%主透镜离散化，微透镜后像素对应的主透镜位置

k=1:1:micr_N;
xy=(k-0.5)*D/micr_N;%透镜中心坐标

ijuv_xy=fliplr(uv);%将主透镜离散化的坐标逆置，以便与微透镜后像素对应
xy_re=zeros(sen_N,micr_N);%记录调整后的x（或y）坐标
%rxy_re=zeros(sen_N,micr_N);%记录调整后的光线对应的微透镜坐标x（或y）


%%%主透镜上一个点对应micr_N个微透镜，将其进行几何变换，调整位置
%%%一个点对应一行，一行中的某个点对应一个微透镜
for ijuv=1:sen_N
    xy_re(ijuv,:)=xy*alpha-(alpha-1)*ijuv_xy(ijuv);
end
rxy_re=ceil(xy_re*micr_N/D);


for kk=1:KK_num %R、G、B
    load (sprintf('./dataRGB/im_d_%d_v_%d_Nline_%d_%d.mat',d,v,Nline,kk),'im');%分别load R、G、Ｂ
    fprintf_RGB(kk,2);
    
    for iu=1:sen_N %主透镜离散
        for jv=1:sen_N  %主透镜离散
            for i=1:micr_N  %主透镜上的每个点都对应所有的微透镜
                for j=1:micr_N
                    rxy_rea=rxy_re(iu,i);%一条光线在重聚焦面的x坐标
                    rxy_reb=rxy_re(jv,j);%一条光线在重聚焦面的y坐标
                    if(rxy_rea>0)&&(rxy_rea<=micr_N)&&(rxy_reb>0)&&(rxy_reb<=micr_N)
                        im_re(rxy_rea,rxy_reb,kk)=im_re(rxy_rea,rxy_reb,kk)+im(i,j,iu,jv);
                    end
                end
            end
        end
    end
end

