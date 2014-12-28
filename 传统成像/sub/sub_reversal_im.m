%2012.11.25 by lichao
%将图像按对角反转

function im_out=sub_reversal_im(im)
disp('正在进行图像反转：');

%% 参数
Nx=size(im,1);
Ny=size(im,2);
im_out=zeros(Nx,Ny);

%% 翻转
for i=1:Nx
    for j=1:Ny
        im_out(Nx+1-i,Ny+1-j)=im(i,j);
    end
end

%% 画图
if 0
    figure
    subplot(1,2,1),imshow(im,[]) 
    title('实际成像')
    subplot(1,2,2),imshow(im_out,[])  
    title('反转后的图像')
end