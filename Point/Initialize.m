function initial = Initialize(initial, soil)
%INITIALIZE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
initial.ThetaRoot = soil.FCroot;
initial.ThetaBuffer = soil.FCbuffer;
initial.WaterTable = 6000;
end

