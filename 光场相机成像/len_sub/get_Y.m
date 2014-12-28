function y3=get_Y(x,y,x3)
%用法：y3=get_Y([x1,x2],[y1,y2],x3)
%(x1,y1)为一个点
%(x2,y2)为一个点
%本程序作用，求过上述两点的直线在x3处的值
if nargin<3
    disp('输入参数不够，请输入(x,y,x3)')
    return
end

p=polyfit([x(1) x(2)],[y(1) y(2)],1);
y3=p(1)*x3+p(2);