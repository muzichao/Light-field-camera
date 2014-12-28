function [obj,obj2,d,d2,object_num,error]=select_object()
%2012 12 20 by lichao
%用于选择场景
%用法：[obj,obj1,d,d2,object_num,error]=select_object()
%obj        场景1
%obj2       场景2
%d          场景1距离
%d2         场景2距离
%object_num 场景数量
%error      结束选择
error=0;
obj=[];
obj2=[];
d=0;
d2=0;
object_num=menu('请选择物体个数：','一个物体','两个物体','结束');

if object_num==1
    object=menu('请选择成像面：','lena256','lena512','Baboon512','Peppers512','circle_card','lena101','一点','结束');
    if object<=7
        obj=select_obj(object);
        d=250;%物距
    else
        error=1;
        return;

    end
elseif object_num==2
    object2=menu('请选择成像面：','A和B','C和D','结束');
    if object2<=2
        [obj,obj2]=select_2obj(object2);
        d=250;
        d2=400;
    else
        error=1;
        return;
    end
elseif object_num==3
    error=1;
    return;

end