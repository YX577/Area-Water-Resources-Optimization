function soil = SoilIni(soil, para)
%SOILINI �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
soil.FCroot = para(1);
soil.Critical = para(2);
soil.PWP = para(3);
soil.a = para(4);
soil.b = para(5);
soil.FCbuffer = para(1);
end

