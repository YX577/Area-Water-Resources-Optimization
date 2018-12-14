function initial = Initialize(initial, soil)
%INITIALIZE 此处显示有关此函数的摘要
%   此处显示详细说明
initial.ThetaRoot = soil.FCroot;
initial.ThetaBuffer = soil.FCbuffer;
initial.WaterTable = 6000;
end

