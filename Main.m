%% 建立优化需要的数据结构
%% 一些系统参数
clear
clc
GrowingCycle=183;% 生育期长（单位：天）
Species=4;%作物种类数量
Soiltype=4;%土壤类型数量
Climatetype=1;%天气类型数量
IrrNum=4;%灌水次数

Qmax=9*10^17;%最大引水量
Qmin=8.5*10^17;

beta_wood_min=0.0971;%林地下限beta值
beta_wood_max=0.7563;%林地上限beta值
beta_grass_min=0.098;%草地下限beta值
beta_grass_max=0.413;%草地上限beta值
Index=1;%改变目标函数在这里，1代表总引水量为分母，2代表农田引水量


%%
%load 0622;%加载数据
load 0622

year=2013;
Nowadays;

load Schedule
IrrMin=30*ones(4,4);
P=sum(PRE);
E=sum(ETo);

%% 调整了林草地蒸发的下限，与给出值和降雨量做了比较，取较大值
if(P>beta_wood_min*E)
    Emin_Wood=P;
else
    Emin_Wood=beta_wood_min*E;
end
Emax_Wood=beta_wood_max*E;
Area_Wood=89918347223600; %林地面积（单位同作物面积）

if(P>beta_grass_min*E)
    Emin_Grass=P;
else
    Emin_Grass=beta_grass_min*E;
end
Emax_Grass=beta_grass_max*E;
Area_Grass=96465076021500;%草地面积（单位同作物面积）

%% 以下为构建数据结构

DataStruct = DataStructProcess(GrowingCycle,Species,Soiltype,IrrNum,Climatetype,Area,...
    Qmax,Qmin,IrrMin,IrrMax,Tmin,Tmax,P,Emax_Wood,Emin_Wood,Area_Wood,Emax_Grass,Emin_Grass,Area_Grass,...
    ETo,Kc,PRE,Soil,ThetaBuffer_Initial, ThetaRoot_Initial,WaterTable_Initial,RootZone);

%% 初始化决策变量组成的矩阵，使决策变量的向量大小更直观
Vector=zeros(1,DataStruct.Species*DataStruct.Soiltype*DataStruct.IrrNum*2+2);

%% 处理总灌水量的约束
A=zeros(2,DataStruct.IrrNum,DataStruct.Species*DataStruct.Soiltype);
for s=1:Species % 因为有两种是林草地
    for t=1:Soiltype
        eval(['S=DataStruct.Crop',num2str(s),'.Soil',num2str(t),';']);
        for irr=1:IrrNum
            %假设同种作物灌水时上下限是相同的
            A(2,irr,(s-1)*Soiltype+t)=S.Area;
        end
    end
end

A=A(:)';
A=[A DataStruct.Wood.Area DataStruct.Grass.Area];
A=[A;-A];
b=[(DataStruct.Qmax+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area);...
    -(DataStruct.Qmin+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area)];

%% 处理决策变量取值范围的约束
LB=zeros(2,DataStruct.IrrNum,DataStruct.Species*DataStruct.Soiltype);
UB=zeros(2,DataStruct.IrrNum,DataStruct.Species*DataStruct.Soiltype);
for s=1:Species % 因为有一种是林草地
    for t=1:Soiltype
        eval(['S=DataStruct.Crop',num2str(s),'.Soil',num2str(t),'.Constraints;']);
        for irr=1:IrrNum
            %假设同种作物灌水时上下限是相同的
            LB(1,irr,(s-1)*Soiltype+t)=S.tmin;
            LB(2,irr,(s-1)*Soiltype+t)=S.Imin;
            UB(1,irr,(s-1)*Soiltype+t)=S.tmax;
            UB(2,irr,(s-1)*Soiltype+t)=S.Imax;
        end
    end
end

LB=LB(:)';
LB=[LB,DataStruct.Wood.Constraints.Emin,DataStruct.Grass.Constraints.Emin];
UB=UB(:)';
UB=[UB,DataStruct.Wood.Constraints.Emax,DataStruct.Grass.Constraints.Emax];

Aeq=[];
beq=[];
nonlcon=[];
IntCon=1:(DataStruct.Species*DataStruct.Soiltype*DataStruct.IrrNum*2);
%%适应度函数
fun=@(Vector) -Fitness(DataStruct,Vector,Index);

initial=schedule;
initial(end-1)=DataStruct.Wood.Constraints.Emin;
initial(end)=DataStruct.Grass.Constraints.Emin;

Initial=ones(100,1)*initial;



nvars=length(Vector);
options=gaoptimset('InitialPopulation',Initial,'Populationsize',100,'UseParallel',true,'Generations',5000000);
%% 用true可能会有问题 报错时改为false


S=ga(fun,nvars,A,b,Aeq,beq,LB,UB,nonlcon,IntCon,options);

WUE=-fun(S);
result=Result(DataStruct,S);
%% result使用方法
%通过result.Crop1.Soil1来访问result的内容
%包含IrriAmount ET Schedule dW Qdrainage P等内容
%通过result.Crop1.Soil1.IrriAmount的方式进行访问