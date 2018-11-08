function [Anwsers,Monitor,Input] = Process(Parameter,Climate,Management,Initial)
%PROCESS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
Days=length(Climate.ETo);
Current=Initial;
irr=1;
num=length(Management);
Anwsers=zeros(Days,3);
Monitor=zeros(Days,3);
Input=zeros(Days,2);
for d=1:Days
    
    %% �����ˮ
    Irr = 0;
    P = Climate.P(d);
    ETo = Climate.ETo(d);
    
    if irr <= num
        if d == Management(1, irr)
            Irr = Management(2, irr);
        end
    end
 
    %% ��������ϵ��Kc���������Root Zone
    
    % ��ֵ��������
    
    parameter = Parameter;
    parameter.cropparameter.Kc = Parameter.cropparameter.Kc(d);
        
    %% �����ǰ״̬ 
    
    Anwsers(d,1)=Current.ThetaRoot;
    Anwsers(d,2)=Current.ThetaBuffer;
    Anwsers(d,3)=Current.WaterTable;
    
    Input(d,1)=Climate.P(d);
    
    %% ��������
    
    [Current,Inter]=NextState(parameter,Current,ETo,P,Irr);
    
    %% ����м������ET��
    
    Monitor(d,1)=Inter.ETa;
    Monitor(d,2)=Inter.Qdrainage;
    Monitor(d,3)=Inter.Qsupply;
    Monitor(d,4)=Inter.ETc;
    
end