function [y] = dWbuffer(Qsupply,Qdrainage,dt)
%W �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

y=(-Qsupply+Qdrainage).*dt;


end

