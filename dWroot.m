function [y] = dWroot(P,I,ETfield,Qdrainage,dt)
%DWROOT 此处显示有关此函数的摘要
%   此处显示详细说明
y=(P+I-ETfield-Qdrainage).*dt;
end

