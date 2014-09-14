%2012 12 18 by lichao
%数字重聚焦
%2012 12 19 修改
%2012 12 20 修改


addpath(genpath('.\image'));
addpath(genpath('.\image2'));
addpath(genpath('.\data'));
addpath(genpath('.\dataRGB'));
addpath(genpath('.\refocuse_sub'));

clearall

%% 参数信息
F=16;%主透镜焦距
%%%%%%%%%%----------可调参数---------------%%%%%%%%%%
v=16;  %默认16
d=250;%场景的位置，用于load
d_re=260;%重聚焦位置
N_line=81;%默认81，用于load

par_menu=menu('确认下列数据是否正确：',['微透镜距离：v=',num2str(v)],['场景距离：d=',num2str(d)],...
    ['重聚焦位置：d_re=',num2str(d_re)],['主透镜采样率：N_line=',num2str(N_line)],'否','是');

if par_menu<=5
    clearall
    disp('请重新调整参数！');
    break;
end

v_re=F*d_re/(d_re-F);    %理想聚焦位置
alpha=v_re/v;        %也可以直接调节参数alpha

disp(['可调参数（微透镜位置）:v=',num2str(v)]);
disp(['可调参数（主透镜采样率）:N_line=',num2str(N_line)]);
disp(['可调参数（场景位置）:d=',num2str(d)]);
disp(['可调参数（聚焦位置）:d_re=',num2str(d_re)]);
%%%%%%%%%%----------可调参数---------------%%%%%%%%%%

D=4;%主透镜直径
lens_d=0.02;
sen_N=20;%每个微透镜后传感器个数
sen_d=lens_d/sen_N;
micr_N=fix(D/lens_d);%微透镜个数
sen_N_total=fix(D/sen_d);%传感器总个数
KK_num=3;            %RGB图像，三个分量


%% 计算每个微透镜对应的校正的传感器坐标
sen_coor=sen_adjust(D,micr_N,F,v,sen_N);

%% 对RGB图像数字重聚焦
fprintf('\n第一步：\n');
tic
im_re=refocuse_im(D,alpha,d,v,N_line,micr_N,sen_N);
t=toc;
fprintf(['\n数字重聚焦时间为:t=',num2str(t),'s\n']);

im_re=im_re/max(max(max(im_re)));%归一化
%% 对图像进行重构，微透镜求和
im_rec=im_recon3(D,d,v,N_line,lens_d); %利用im_recon3对光场原始数据求和重构
im_rec=im_rec/max(max(max(im_rec)));%归一化

figure
subplot(1,2,1),imshow(im_rec,[]);
title('重聚焦前：求和法重建的图像');
subplot(1,2,2),imshow(im_re,[]);
title('重聚焦后：求和法重建的图像');

fprintf('\n已重构完成！\n');

%% 去除图像中无效的黑色边缘
fprintf('\n第二步：\n');

fprintf('\n正在去除重聚焦图像的无效边缘：\n')
im_full=sub_revise3_im(im_rec);
fprintf('\n正在去除原始图像的无效边缘：\n')
im_re_full=sub_revise3_im(im_re);

figure
subplot(1,2,1),imshow(im_full,[]);title('重聚焦前：消除0行0列的图像');
subplot(1,2,2),imshow(im_re_full,[]);title('重聚焦后：消除0行0列的图像');

fprintf('\n已去除无效边缘！\n');
%% 图像反转，修正相机成反相问题
fprintf('\n第三步：\n');

fprintf('\n正在对聚焦前重构图像进行反转：\n')
im_full_final=sub_reversal3_im(im_full);
fprintf('\n正在对聚焦后重构图像进行反转：\n')
im_re_full_final=sub_reversal3_im(im_re_full);

figure
subplot(1,2,1),imshow(im_full_final,[]);title('重聚焦前：最终图像');
subplot(1,2,2),imshow(im_re_full_final,[]);title('重聚焦后：最终图像');

fprintf('\n图像已逆置!\n');


%% 画出传感器图像
figure

im_RGB=imread(sprintf('./dataRGB/im_d_%d_v_%d_Nline_%d_RGB.jpg',d,v,N_line));
warning off all  %因传感器图像过大imshow会出现warning，此处将warning关掉
imshow(im_RGB,[]);title('传感器图像im');
warning on all
clear im_RGB

fprintf('\n已画出传感器图像！\n');
%% 结束               
fprintf('\nThe end!\n');     