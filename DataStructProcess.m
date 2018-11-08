function DataStruct = DataStructProcess(GrowingCycle,Species,Soiltype,IrrNum,Climatetype,Area,...
    Qmax,Qmin,IrrMin,IrrMax,Tmin,Tmax,P,Emax_Wood,Emin_Wood,Area_Wood,Emax_Grass,Emin_Grass,Area_Grass,...
    ETo,Kc,PRE,Soil,ThetaBuffer_Initial, ThetaRoot_Initial,WaterTable_Initial,RootZone)
%DATASTRUCTPROCESS 此处显示有关此函数的摘要
%   此处显示详细说明
%% 构建优化需要的数据结构

DataStruct=struct();
DataStruct.GrowingCycle=GrowingCycle;% 总生育期时长（单位：天）
DataStruct.Species=Species;%作物种类数量，不包含林草地
DataStruct.Soiltype=Soiltype;%土壤种类数量
DataStruct.IrrNum=IrrNum;%假定灌四次水
DataStruct.Climatetype=Climatetype;%天气类型的数量
DataStruct.Qmax=Qmax;
DataStruct.Qmin=Qmin;
%% 假设有n种天气类型，但是这个程序实现不了

Climate=[];
for d=1:DataStruct.GrowingCycle
    In.ETo=ETo(d);
    In.P=PRE(d);
    Climate=[Climate,In];
end

%% 有4种土壤类型

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

%% 有4种作物

for t=1:DataStruct.Soiltype
    eval(['cropparameter',num2str(t),'.Kc=Kc(',num2str(t),',:);'])
    eval(['cropparameter',num2str(t),'.RootZone=RootZone(',num2str(t),');'])
end

%% 时间参数只有一个
timeparameter.dt=1;

%% 组装结构体

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







