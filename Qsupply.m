function y = Qsupply(Wbuffer,Qdrainage,Wbufferhold)
%QSUPPLY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if (Wbuffer+Qdrainage)>Wbufferhold
    y=Wbuffer+Qdrainage-Wbufferhold;
else
    y=0;
end
%y=Wbuffer+Qdrainage-Wbufferhold;
end

