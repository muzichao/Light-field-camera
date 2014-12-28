function im_full=sub_revise3_im(im)
%2012 12 20 by lichao
%将RGB图像边缘的0行0列删除
%用法：im_full=sub_revise3_im(im)
%im RGB图像

disp('正在消除图像边缘的0行、0列：')
Nx=size(im,1);
Ny=size(im,2);

i=1;
i_up=1;%初始为1，防止没有黑色边缘是不存在i_up;
while(sum(im(i,:,1))==0)
    i_up=i+1;
    i=i+1;
end

i=Nx;
i_down=Nx;
while(sum(im(i,:,1))==0)
    i_down=i-1;
    i=i-1;
end

j=1;
j_left=1;
while(sum(im(:,j,1))==0)
    j_left=j+1;
    j=j+1;
end

j=Ny;
j_right=Ny;
while(sum(im(:,j,1))==0)
    j_right=j-1;
    j=j-1;
end

im_full=im(i_up:i_down,j_left:j_right,:);