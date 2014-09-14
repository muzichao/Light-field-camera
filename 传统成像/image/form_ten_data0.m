%2012 12 1 by lichao
%产生大矩阵的十

clc
clear all
close all

N=1001;

ten_data0=zeros(N);

ten_data0(460:540,:)=1;
ten_data0(:,460:540)=1;

figure
imshow(ten_data0,[])

save ten_data0 ten_data0