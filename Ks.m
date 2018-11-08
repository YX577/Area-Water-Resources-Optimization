function [y] = Ks(theta,thetaw,thetaf)
%KS 此处显示有关此函数的摘要
%   此处显示详细说明
if theta>thetaw
    Aw=(theta-thetaw)./(thetaf-thetaw)*100;
    y=log(Aw+1)./log(101);
else
    y=0;
end
end

