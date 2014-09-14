%%
%2012 11 29 by lichao
%画一个101*101的圆环

%%
clc
clear all
close all

%%
N=101;
circle_data=zeros(N);

%%
for i=1:N
    for j=1:N
        if((i-round(N/2))^2+(j-round(N/2))^2<=40^2)&&((i-round(N/2))^2+(j-round(N/2))^2>=20^2)
            circle_data(i,j)=1;
        end
    end
end

figure
imshow(circle_data,[])


%%
circle_data1=circle_data;
for i=1:N
    for j=1:N
        if((i-90)^2+(j-90)^2<=10^2)
            circle_data1(i,j)=1;
        end
    end
end


figure
imshow(circle_data1,[])

%%
save circle_data circle_data
save circle_data1 circle_data1