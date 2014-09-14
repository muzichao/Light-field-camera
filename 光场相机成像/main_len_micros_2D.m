%2012 11 26 by lichao
%2012 12 1 修改
%2012 12 13 修改，添加了微透镜后传感器的调整
%2012 12 19修改
%2012 12 22修改 添加了传感器子图像的中心修正
%2维简化
%透镜+微透镜阵列

%疑问：微透镜是否符合近轴光学 符合，由F，lens_d,等参数可计算最大角

%距透镜d的物体，在透镜后v处成的像
%适用与近轴光学，即物体离透镜的距离远大于焦距

%可分别令v=16,17,0,17.093,15.84

addpath(genpath('.\image'));
addpath(genpath('.\image2'));
addpath(genpath('.\data'));
addpath(genpath('.\dataRGB'));
addpath(genpath('.\len_sub'));

clearall

%%%%%%%%%%%%%%%%%%---------物体信息--------------%%%%%%%%%%%%%%%%%%%%%%
[obj,obj1,d,d2,object_num,error]=select_object();
if error==1
    clearall
    break;
elseif object_num==1
    clear obj1
end

%%%%%%%%%%%%%%%%%%---------相机参数信息----------------%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%----------可调参数---------------%%%%%%%%%%
v=16;%像距  默认16
N_line=81;%对主透镜的离散化，每个点在主透镜有多少光线  默认81
d_m=18;%物体是透镜的多少倍

error=ensure_par(v,N_line,d_m,object_num,d,d2);
if error==1
    clearall
    disp('请重新调整参数！');
    break;
end

%%%%%%%%%%----------固定参数---------------%%%%%%%%%%
D=4;%直径
F=16;%焦距  f-num=4
lens_d=0.02;%微透镜直径
sen_N=20;%每个微透镜后传感器个数

lens_f=lens_d*F/D;%微透镜焦距
lens_v=lens_f+v; %传感器位置
micr_N=ceil(D/lens_d);%微透镜个数
sen_N_total=micr_N*sen_N;%传感器总个数
sen_d=lens_d/sen_N;%传感器直径

if mod(sen_N_total,2)==0
    sen_N_total=sen_N_total+1;
end

im_max=zeros(3,1);%分别保存R，G，B的最大值，以便转换为uint8型，以节省内存

%%%%%%%%%%%%%%%%%%----------相机传输过程参数------------%%%%%%%%%%%%%%%%%%%%%
tic
for k=1:3
    if object_num==1
        fprintf_RGB(k);%字符串打印
        obje=obj(:,:,k);
        im=LF_sim(obje,d,d_m,D,N_line,F,v,lens_d,lens_f,sen_N);
        im_max(k)=max(max(max(max(im))));
    elseif object_num==2
        fprintf_RGB(k); %字符串打印
        obje=obj(:,:,k);
        im=LF_sim(obje,d,d_m,D,N_line,F,v,lens_d,lens_f,sen_N);
        obje=obj1(:,:,k);
        im=im+LF_sim(obje,d2,d_m,D,N_line,F,v,lens_d,lens_f,sen_N);
        im_max(k)=max(max(max(max(im))));
    end
    
    save (sprintf('./dataRGB/im_d_%d_v_%d_Nline_%d_%d.mat',d,v,N_line,k),'im');
    
end
t=toc;
fprintf(['\n模拟光场传输时间为：t=',num2str(t),'s\n']);

%%  画出原始图像
figure
if object_num==1
    imshow(uint8(obj),[]);title('obj——场景')
elseif object_num==2
    subplot(1,2,1),imshow(uint8(obj),[]);title('obj——第一个场景');
    subplot(1,2,2),imshow(uint8(obj1),[]);title('obj1——第二个场景');
end
fprintf('\n已画出场景图像！\n');

%%  画出传感器成像
clear im
%im_RGB=zeros(micr_N*sen_N,micr_N*sen_N,3);
%im_RGB=uint8(im_RGB);
im_RGB=reshape4to2_im(d,v,N_line,micr_N,sen_N,im_max);

figure
warning off all
imshow(im_RGB,[]);title('传感器图像im');
warning on all

imwrite(im_RGB,sprintf('./dataRGB/im_d_%d_v_%d_Nline_%d_RGB.jpg',d,v,N_line));%将微透镜图像保存为im_RGB.jpg

fprintf('\n已画出传感器图像！\n');

%% 原始数据求和重构后的图像
im_micr=sum_4D_im(d,v,N_line,micr_N);
max_im_micr=max(max(max(im_micr)));
im_micr=uint8(im_micr/max_im_micr*255);
figure
imshow(im_micr,[]);title('原始数据求和重构：');
fprintf('\n已画出原始数据重构图像!\n');
disp('The end!');

