load Data

% District = [
% {'AnYang'}; %: �������
% 
% {'BanQiao'}; %: ���Ź���
% 
% {'DaMan'}; %: ��������
% 
% {'HongYaZi'}; %: �����ӹ���
% 
% {'HuaZhaiZi'}; %: ��կ�ӹ���
% 
% {'LiYuanHe'}; %: ��԰�ӹ���
% 
% {'LiaoQuan'}; %: ޤȪ����
% 
% {'LiuBa'}; %: ���ӹ���
% 
% {'LuoCheng'}; %: �޳ǹ���
% 
% {'PingChuan'}; %: ƽ������
% 
% {'ShaHe'}; %: ɳ�ӹ���
% 
% {'ShangSan'}; %: ��������
% 
% {'XiJun';} %: ��������
% 
% {'XinBa';} %: �°ӹ���
% 
% {'YaNuan'} ; %: Ѽů����
% 
% {'YingKe'}; %: ӯ�ƹ���
% 
% {'YouLian'}; %: ��������
% ];
% Soil = [{'T1'};{'T2'};{'T3'};{'T4'}];
% Crop = [{'Maize'};{'Wheat'};{'Others'}];
% 
% for d = 1 : length(District)
%     for c = 1: length(CropSpeices)
%         for s = 1: length(SoilType)
%             switch c
%                 case 1
%                     eval(['Data.',char(District{d}),'.',char(Crop{c}),'.',char(Soil{s}),'.Parameter = Maize;'])
%                 case 2
%                     eval(['Data.',char(District{d}),'.',char(Crop{c}),'.',char(Soil{s}),'.Parameter = Wheat;'])
%                 case 3
%                     eval(['Data.',char(District{d}),'.',char(Crop{c}),'.',char(Soil{s}),'.Parameter = Others;'])
%             end
%             
%             %eval(['Data.',char(District{d}),'.',char(Crop{c}),'.',char(Soil{s}),'.Climate.P = Maize;'])
%             
%             %eval(['Data.',char(District{d}),'.',char(Crop{c}),'.',char(Soil{s}),'.Climate.ETo = Maize;'])
%         end
%     end
% end
for i = 1: 142
    district = lower(char(DataO(i, 5)));
    for j = 1: 17
        if(strcmp(district,lower(char(District(j)))))
            break;
        end
    end
    
    crop = lower(cell2mat(DataO(i, 8)));
    
    soil = lower(char(DataO(i, 6)));
    for l = 1: 4
        if(strcmp(soil,lower(char(SoilType(l)))))
            break;
        end
    end
    
    
    S.Area = cell2mat(DataO(i, 10));
    
    switch crop
        case 1
            Sp.cropparameter.Kc = Maize;
            Sp.cropparameter.Yield = [-0.0065	11.115	-543.92];
        case lower('Wheat')
            Sp.cropparameter.Kc = Wheat;
            Sp.cropparameter.Yield = [-0.0065	11.115	-543.92];
        case 3
            Sp.cropparameter.Kc = Others;
            Sp.cropparameter.Yield = [-0.008975	65.102275	-104857.325];
    end
    
    Sp.cropparameter.RootZone = 1000;
   
    Sp.timeparameter.dt = 1;
  
    soiln = 0;
    
    switch soil 
        case 't1'
            S.Initial.ThetaRoot = 0.2785;
            S.Initial.ThetaBuffer = 0.2785;
            soiln = 1;
        case 't2'
            S.Initial.ThetaRoot = 0.2789;
            S.Initial.ThetaBuffer = 0.2789;
            soiln = 2;
        case 't3'
            S.Initial.ThetaRoot = 0.272223770870485;
            S.Initial.ThetaBuffer = 0.272223770870485;
            soiln = 3;
        case 't4'
            S.Initial.ThetaRoot = [0.269898589214070];
            S.Initial.ThetaBuffer = [0.269898589214070];
            soiln = 4;
    end       

    soils.FCroot = Soil(soiln,1);
    soils.Critical= Soil(soiln,2);
    soils.PWP= Soil(soiln,3);
    soils.FCbuffer= Soil(soiln,2);
    soils.a= Soil(soiln,4);
    soils.b= Soil(soiln,5);
   
    Sp.soilparameter = soils; 
    S.Initial.WaterTable = 6000;
    
    S.Parameter = Sp;

    S.Constraint.tmax = 45;
    S.Constraint.tmin = 1;
    
    switch crop
        case 1
            S.Constraint.Imax = 225;
            S.Constraint.Imin = 112;
        case 2
            S.Constraint.Imax = 150;
            S.Constraint.Imin = 62;
        case 3
            S.Constraint.Imax = 175;
            S.Constraint.Imin =125;
    end 
    
    S.Management.Schedule = zeros(3,4);
    S.Management.ys = ;
    S.Management.yg = ;
    
    eval(['Data.',char(District{j}),'.', char(CropSpeices{crop}),'.'...
        ,char(SoilType{l}),'=S;']);
end
Data.District = District;
Data.Crop = CropSpeices;
Data.Soil = SoilType; 
Data.Constraint.Qs = ;
Data.Constraint.Qg = ;

Data = WeatherProcess(Data, PRE, ETo);
Data = ConstraintProcess(Data,)
    
    
    






