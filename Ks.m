function [y] = Ks(theta,thetaw,thetaf)
%KS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if theta>thetaw
    Aw=(theta-thetaw)./(thetaf-thetaw)*100;
    y=log(Aw+1)./log(101);
else
    y=0;
end
end

