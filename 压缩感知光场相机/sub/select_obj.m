function obj=select_obj()
%2012 12 24 by lichao
%功能：选择主透镜前场景
%用法：obj=select_obj()

obj_num=menu('请选择场景：','hough','十101','五点','finger','结束');
if obj_num>4
    obj=0;
end


%%%%%---------Img.jpg---------%%%%%%%%%%
if obj_num==1
    load hough_data hough_data
    obj=double(hough_data);
end
%%%%%---------Img.jpg---------%%%%%%%%%%


%%%%%---------"十"---------%%%%%%%%%%
if obj_num==2
    load ten_data ten_data  %101*101
    obj=ten_data;
end
%%%%%---------"十"---------%%%%%%%%%%


%%%%%---------五点---------%%%%%%%%%%
if obj_num==3
    obj=zeros(101);
    obj(51,51)=100;
    obj(21,21)=100;
    obj(81,81)=100;
    obj(21,81)=100;
    obj(81,21)=100;
end
%%%%%---------五点---------%%%%%%%%%%


%%%%%---------指纹---------%%%%%%%%%%
if obj_num==4
    load finger_data finger_data
    obj=double(finger_data);
end
%%%%%---------指纹---------%%%%%%%%%%


