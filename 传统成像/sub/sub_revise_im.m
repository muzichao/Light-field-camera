%2012.11.25 by lichao
%用来消除透镜成像模拟的数字化导致的整行整列为0的情况
%im0 为透镜生成的图像
%im_full为消除0行，0列的图像

function im_full=sub_revise_im(im)
disp('正在消除图像的0行、0列：');

%% 参数
Nx=size(im,1);
Ny=size(im,2);

im0=[];
im_full=[];

%% 消除0行
for i=1:Nx
    if sum(im(i,:))~=0
        im0=cat(1,im0,im(i,:));
    end
end

%% 消除0列
for j=1:Ny
    if sum(im0(:,j))~=0
        im_full=cat(2,im_full,im0(:,j));
    end
end

%% 画图
if 0
    figure
    subplot(1,3,1); imshow(im,[]);title('输入图像')
    subplot(1,3,2); imshow(im0,[]);title('消除0行后')    
    subplot(1,3,3); imshow(im_full,[]);title('消除0行0列后')
end