function soil = SoilIni(soil, para)
%SOILINI 此处显示有关此函数的摘要
%   此处显示详细说明
soil.FCroot = para(1);
soil.Critical = para(2);
soil.PWP = para(3);
soil.a = para(4);
soil.b = para(5);
soil.FCbuffer = para(1);
end

