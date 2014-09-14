function fprintf_RGB(kk,varr)
%2012 12 20 by lichao
%分别显示处理的RGB

if exist('varr','var')==0
    switch kk
        case 1
            fprintf('\n一（R）:\n正在对图像R分量进行处理：\n');
        case 2
            fprintf('\n二（G）：\n正在对图像G分量进行处理：\n');
        case 3
            fprintf('\n三（B）：\n正在对图像B分量进行处理：\n');
    end
else
    switch kk
        case 1
            disp('正在对图像R分量光线进行调整：');
        case 2
            disp('正在对图像G分量光线进行调整：');
        case 3
            disp('正在对图像B分量光线进行调整：');
    end
end