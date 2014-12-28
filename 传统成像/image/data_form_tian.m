%2012 12 9 by lichao
%产生尺寸更大，且覆盖整幅图范围更多的图
%产生“田”字
clc
clear all
close all

N=401;

a=zeros(N);

a(1:10,:)=1;
a(392:401,:)=1;


a(196:205,:)=1;

a=a+a';

figure
imshow(a,[]);

data_tian=a;

save data_tian data_tian