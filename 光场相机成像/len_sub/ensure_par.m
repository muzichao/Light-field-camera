function error=ensure_par(v,N_line,d_m,object_num,d,d2)
%2012 12 20 by lichao
%用于确认参数信息是否准确
%用法：error=ensure_par[v,N_line,d_m,object_num,d,d2]
%v             微透镜位置
%N_line        主透镜采样率
%d_m           场景放大倍数
%object_num    场景数
%d             场景1的距离
%d2            场景2的距离
error=0;
if nargin<=5
    error=1;
    disp('请输入足够的参数：')
    return;
end


par_menu=menu('确认下列数据是否正确：',['微透镜距离：v=',num2str(v)],['场景个数:object_num=',num2str(object_num)],...
    ['场景1的距离：d=',num2str(d)],['场景2的距离：d2=',num2str(d2)],['主透镜采样率：N_line=',num2str(N_line)],['场景放大倍数：d_m=',num2str(d_m)],'否','是');
if par_menu<=7
    error=1;
    return;
else   
    disp(['可调参数(微透镜位置):v=',num2str(v)]);
    disp(['可调参数（主透镜采样率）:N_line=',num2str(N_line)]);
    disp(['可调参数（场景放大倍数）:d_m=',num2str(d_m)]);
    disp(['可调参数（场景1距离）:d=',num2str(d)]);
    disp(['可调参数（场景2距离）:d2=',num2str(d2)]);
end