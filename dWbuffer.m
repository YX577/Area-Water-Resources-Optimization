function [y] = dWbuffer(Qsupply,Qdrainage,dt)
%W 此处显示有关此函数的摘要
%   此处显示详细说明

y=(-Qsupply+Qdrainage).*dt;


end

