function y = Qsupply(Wbuffer,Qdrainage,Wbufferhold)
%QSUPPLY 此处显示有关此函数的摘要
%   此处显示详细说明
if (Wbuffer+Qdrainage)>Wbufferhold
    y=Wbuffer+Qdrainage-Wbufferhold;
else
    y=0;
end
%y=Wbuffer+Qdrainage-Wbufferhold;
end

