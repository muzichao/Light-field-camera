function [out,out1]=select_2obj(obj)
%2012 12 19 by lichao
%选择两个不同深度额场景
%%%%%%---------两个物体-----%%%%%%%%%%
%%%%%%---------A和B---------%%%%%%%%%%
if obj==1
    out=zeros(500,500,3);
    A1=imread('A1.jpg');
    A1=double(A1);
    out(20:20-1+size(A1,1),20:20-1+size(A1,2),:)=A1;
    
    out1=zeros(500,500,3);
    B1=imread('B1.jpg');
    B1=double(B1);
    out1(480+1-size(B1,1):480,480+1-size(B1,2):480,:)=B1;
end
    

%%%%%%---------A和B---------%%%%%%%%%%

%%%%%%---------C和D---------%%%%%%%%%%
if obj==2
    out=zeros(500,500,3);
    C1=imread('C1.jpg');
    C1=double(C1);
    out(20:20-1+size(C1,1),480+1-size(C1,2):480,:)=C1;
    
    out1=zeros(500,500,3);
    D1=imread('D1.jpg');
    D1=double(D1);
    out1(480+1-size(D1,1):480,20:20-1+size(D1,1),:)=D1;
end
    

%%%%%%---------C和D---------%%%%%%%%%%