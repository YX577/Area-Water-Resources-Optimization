function [y] = dWroot(P,I,ETfield,Qdrainage,dt)
%DWROOT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
y=(P+I-ETfield-Qdrainage).*dt;
end

