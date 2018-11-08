function DataStruct = DataStructProcess(GrowingCycle,Species,Soiltype,IrrNum,Climatetype,Area,...
    Qmax,Qmin,IrrMin,IrrMax,Tmin,Tmax,P,Emax_Wood,Emin_Wood,Area_Wood,Emax_Grass,Emin_Grass,Area_Grass,...
    ETo,Kc,PRE,Soil,ThetaBuffer_Initial, ThetaRoot_Initial,WaterTable_Initial,RootZone)
%DATASTRUCTPROCESS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%% �����Ż���Ҫ�����ݽṹ

DataStruct=struct();
DataStruct.GrowingCycle=GrowingCycle;% ��������ʱ������λ���죩
DataStruct.Species=Species;%���������������������ֲݵ�
DataStruct.Soiltype=Soiltype;%������������
DataStruct.IrrNum=IrrNum;%�ٶ����Ĵ�ˮ
DataStruct.Climatetype=Climatetype;%�������͵�����
DataStruct.Qmax=Qmax;
DataStruct.Qmin=Qmin;
%% ������n���������ͣ������������ʵ�ֲ���

Climate=[];
for d=1:DataStruct.GrowingCycle
    In.ETo=ETo(d);
    In.P=PRE(d);
    Climate=[Climate,In];
end

%% ��4����������

for t=1:DataStruct.Soiltype
    eval(['soilparameter',num2str(t),'.FCroot=Soil(',num2str(t),',1);'])
    eval(['soilparameter',num2str(t),'.Critical=Soil(',num2str(t),',2);'])
    eval(['soilparameter',num2str(t),'.PWP=Soil(',num2str(t),',3);'])
    eval(['soilparameter',num2str(t),'.FCbuffer=Soil(',num2str(t),',1);'])
    eval(['soilparameter',num2str(t),'.a=Soil(',num2str(t),',4);'])
    eval(['soilparameter',num2str(t),'.b=Soil(',num2str(t),',5);'])
end

for t=1:DataStruct.Soiltype
    eval(['initial',num2str(t),'.ThetaRoot=ThetaRoot_Initial(',num2str(t),');'])
    eval(['initial',num2str(t),'.ThetaBuffer=ThetaBuffer_Initial(',num2str(t),');'])
    eval(['initial',num2str(t),'.WaterTable=WaterTable_Initial(',num2str(t),');'])
    
    
    
    
end

%% ��4������

for t=1:DataStruct.Soiltype
    eval(['cropparameter',num2str(t),'.Kc=Kc(',num2str(t),',:);'])
    eval(['cropparameter',num2str(t),'.RootZone=RootZone(',num2str(t),');'])
end

%% ʱ�����ֻ��һ��
timeparameter.dt=1;

%% ��װ�ṹ��

for s=1:DataStruct.Species
    for t=1:DataStruct.Soiltype
        eval(['parameter.cropparameter=cropparameter',num2str(s),';'])
        eval(['parameter.soilparameter=soilparameter',num2str(t),';'])
        parameter.timeparameter=timeparameter;
        Constraints.tmax=Tmax(s,t);
        Constraints.tmin=Tmin(s,t);
        Constraints.Imax=IrrMax(s,t);
        Constraints.Imin=IrrMin(s,t);
        eval(['DataStruct.Crop',num2str(s),'.Soil',num2str(t),'.parameter=parameter;'])
        eval(['DataStruct.Crop',num2str(s),'.Soil',num2str(t),'.climate=Climate;'])
        eval(['DataStruct.Crop',num2str(s),'.Soil',num2str(t),'.Initial=initial',num2str(t),';'])
        eval(['DataStruct.Crop',num2str(s),'.Soil',num2str(t),'.Area=Area(s,t);'])
        eval(['DataStruct.Crop',num2str(s),'.Soil',num2str(t),'.Constraints=Constraints;'])
    end
end

DataStruct.Wood.Constraints.Emax=Emax_Wood;
DataStruct.Wood.Constraints.Emin=Emin_Wood;
DataStruct.Wood.P=P;
DataStruct.Wood.Area=Area_Wood;

DataStruct.Grass.Constraints.Emax=Emax_Grass;
DataStruct.Grass.Constraints.Emin=Emin_Grass;
DataStruct.Grass.P=P;
DataStruct.Grass.Area=Area_Grass;







