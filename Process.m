function [Anwsers,Monitor,Input] = Process(Parameter,Climate,Management,Initial)
%PROCESS 此处显示有关此函数的摘要
%   此处显示详细说明
Days=length(Climate.ETo);
Current=Initial;
irr=1;
num=length(Management);
Anwsers=zeros(Days,3);
Monitor=zeros(Days,3);
Input=zeros(Days,2);
for d=1:Days
    
    %% 处理灌水
    Irr = 0;
    P = Climate.P(d);
    ETo = Climate.ETo(d);
    
    if irr <= num
        if d == Management(1, irr)
            Irr = Management(2, irr);
        end
    end
 
    %% 处理作物系数Kc与根区长度Root Zone
    
    % 定值参数处理
    
    parameter = Parameter;
    parameter.cropparameter.Kc = Parameter.cropparameter.Kc(d);
        
    %% 输出当前状态 
    
    Anwsers(d,1)=Current.ThetaRoot;
    Anwsers(d,2)=Current.ThetaBuffer;
    Anwsers(d,3)=Current.WaterTable;
    
    Input(d,1)=Climate.P(d);
    
    %% 计算主体
    
    [Current,Inter]=NextState(parameter,Current,ETo,P,Irr);
    
    %% 输出中间变量如ET等
    
    Monitor(d,1)=Inter.ETa;
    Monitor(d,2)=Inter.Qdrainage;
    Monitor(d,3)=Inter.Qsupply;
    Monitor(d,4)=Inter.ETc;
    
end