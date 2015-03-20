
%%
clc
clear all
close all

addpath('.\image');
addpath('.\sub');
addpath('.\CS-Code');
%%  参数
Cam.D=4;                                                                        %直径
Cam.F=16;                                                                       %焦距
d=400;                                                                      %物距
d_m=6;  
v_re=Cam.F*d/(d-Cam.F);  %像距
Cam.v=16;
Cam.N_line=11;                                                                  %对主透镜的离散化，每个点在主透镜有多少光线
Sen.N=500;                                                                  %传感器总个数
Sen.d=Cam.D/Sen.N;                                                              %传感器直径

obj=select_obj();                                                          %选择物体
if obj==0
    clearall
    disp('请重新选择参数！');
    break;
end

%% 压缩感知参数
Sen.L=11;% 每个传感器重构出sen_L^2条直线
CS.N=Sen.L^2;%压缩感知观测矩阵参数
CS.M=fix(CS.N*0.5);%压缩感知观测矩阵参数
rng('default')
CS.A=rand(CS.M,CS.N);


%% 模拟成像过程
tic
im=LF_sim(obj,d_m,d,Cam,Sen,CS);
t=toc;
disp(['模拟成像过程花费时间为：t=',num2str(t),'s']);


%% 压缩感知重构
tic
maxIters=10000;
im_2_to_4=zeros(size(im,1),size(im,2),Sen.L,Sen.L);
for i=1:size(im,1)
    for j=1:size(im,2)       
        if sum(im(i,j,:))~=0
            y=reshape(im(i,j,:),size(im,3),1);
            [sols, iters, activationHist] = SolveOMP(CS.A, y, CS.N, maxIters);
            %reshape(sols,Sen.L,Sen.L)'
            im_2_to_4(i,j,:,:)=reshape(sols,Sen.L,Sen.L)';
        end
    end
end
t=toc;
disp(['CS重构时间为：t=',num2str(t),'s']);

%%  重聚焦
tic
im_rec=LF_refocuse(im_2_to_4,v_re,Cam,Sen);
t=toc;
disp(['重聚焦时间为：t=',num2str(t),'s']);


%% 消除0行、0列
im_full=sub_revise_im(im_rec);

%% 图像逆置
im_full_final=sub_reversal_im(im_full);

%% figure
figure
subplot(1,2,1),imshow(obj,[]);title('原始图像');
subplot(1,2,2),imshow(abs(im_rec),[]);title('重构图像')

figure
imshow(im(:,:,CS.M),[]);title('观测图像')

figure
imshow(im_full,[]);title('消除0行0列的图像');

figure
imshow(im_full_final,[]);title('最终图像');



