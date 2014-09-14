function out=select_obj(obj)
% 2012 12 19 by lichao
%Ñ¡Ôñ³¡¾°

%%%%%%---------lena256---------%%%%%%%%%%
if obj==1
    out=imread('lena.jpg'); %256
    out=double(out);
end
%%%%%%---------lena256---------%%%%%%%%%%

%%%%%%---------lena512---------%%%%%%%%%%
if obj==2
    out=imread('lenaRGB.tif');  %512*512
    out=double(out);
end
%%%%%%---------lena512---------%%%%%%%%%%


%%%%%%---------Baboon512---------%%%%%%%%%%
if obj==3
    out=imread('BaboonRGB.tif');
    out=double(out);
end
%%%%%%---------Baboon512---------%%%%%%%%%%


%%%%%%---------Peppers---------%%%%%%%%%%
if obj==4
    out=imread('PeppersRGB.tif');
    out=double(out);
end
%%%%%%---------Peppers---------%%%%%%%%%%

%%%%%%---------circle_card---------%%%%%%%%%%
if obj==5
    out=imread('circle_card.jpg');
    out=double(out);
end
%%%%%%---------circle_card---------%%%%%%%%%%

%%%%%%---------lena101---------%%%%%%%%%%
if obj==6
    out=imread('lena101.jpg'); %101
    out=double(out);
end
%%%%%%---------lena256---------%%%%%%%%%%

if obj==7
    out=zeros(101,101,3);
    out(51,51,:)=1;
end
