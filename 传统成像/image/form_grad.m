%2012 12 1 by lichao
%产生渐变数据，以便微透镜成像观察

clc
clear all
close all

N=101;
d=30;

data_grad=zeros(N);

for i=1:N
    data_grad(i,:)=mod(i,d);
end

figure
imshow(data_grad,[])

save data_grad data_grad