function [parameter] = Parameter(a,b,FCroot,FCbuffer,PWP,Critical,Kc,RootZone,Ym,K,A,B,dt)
%PARAMETER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% a=0.11;
% b=2.5;
% % FCroot=0.25;
% % FCbuffer=0.25;
% PWP=0.07;
% Critical=0.09;
% RootZone=1000;

soilparameter.a=a;
soilparameter.b=b;
soilparameter.FCroot=FCroot;
soilparameter.FCbuffer=FCbuffer;
soilparameter.PWP=PWP;
soilparameter.Critical=Critical;


cropparameter.Kc=Kc;
cropparameter.RootZone=RootZone;
cropparameter.Ym=Ym;
cropparameter.K=K;
cropparameter.A=A;
cropparameter.B=B;

timeparameter.dt=dt;

In.soilparameter=soilparameter;
In.cropparameter=cropparameter;
In.timeparameter=timeparameter;


parameter=In;
end