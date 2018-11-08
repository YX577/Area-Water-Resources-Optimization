%% �����Ż���Ҫ�����ݽṹ
%% һЩϵͳ����
clear
clc
GrowingCycle=183;% �����ڳ�����λ���죩
Species=4;%������������
Soiltype=4;%������������
Climatetype=1;%������������
IrrNum=4;%��ˮ����

Qmax=9*10^17;%�����ˮ��
Qmin=8.5*10^17;

beta_wood_min=0.0971;%�ֵ�����betaֵ
beta_wood_max=0.7563;%�ֵ�����betaֵ
beta_grass_min=0.098;%�ݵ�����betaֵ
beta_grass_max=0.413;%�ݵ�����betaֵ
Index=1;%�ı�Ŀ�꺯�������1��������ˮ��Ϊ��ĸ��2����ũ����ˮ��


%%
%load 0622;%��������
load 0622

year=2013;
Nowadays;

load Schedule
IrrMin=30*ones(4,4);
P=sum(PRE);
E=sum(ETo);

%% �������ֲݵ����������ޣ������ֵ�ͽ��������˱Ƚϣ�ȡ�ϴ�ֵ
if(P>beta_wood_min*E)
    Emin_Wood=P;
else
    Emin_Wood=beta_wood_min*E;
end
Emax_Wood=beta_wood_max*E;
Area_Wood=89918347223600; %�ֵ��������λͬ���������

if(P>beta_grass_min*E)
    Emin_Grass=P;
else
    Emin_Grass=beta_grass_min*E;
end
Emax_Grass=beta_grass_max*E;
Area_Grass=96465076021500;%�ݵ��������λͬ���������

%% ����Ϊ�������ݽṹ

DataStruct = DataStructProcess(GrowingCycle,Species,Soiltype,IrrNum,Climatetype,Area,...
    Qmax,Qmin,IrrMin,IrrMax,Tmin,Tmax,P,Emax_Wood,Emin_Wood,Area_Wood,Emax_Grass,Emin_Grass,Area_Grass,...
    ETo,Kc,PRE,Soil,ThetaBuffer_Initial, ThetaRoot_Initial,WaterTable_Initial,RootZone);

%% ��ʼ�����߱�����ɵľ���ʹ���߱�����������С��ֱ��
Vector=zeros(1,DataStruct.Species*DataStruct.Soiltype*DataStruct.IrrNum*2+2);

%% �����ܹ�ˮ����Լ��
A=zeros(2,DataStruct.IrrNum,DataStruct.Species*DataStruct.Soiltype);
for s=1:Species % ��Ϊ���������ֲݵ�
    for t=1:Soiltype
        eval(['S=DataStruct.Crop',num2str(s),'.Soil',num2str(t),';']);
        for irr=1:IrrNum
            %����ͬ�������ˮʱ����������ͬ��
            A(2,irr,(s-1)*Soiltype+t)=S.Area;
        end
    end
end

A=A(:)';
A=[A DataStruct.Wood.Area DataStruct.Grass.Area];
A=[A;-A];
b=[(DataStruct.Qmax+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area);...
    -(DataStruct.Qmin+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area)];

%% ������߱���ȡֵ��Χ��Լ��
LB=zeros(2,DataStruct.IrrNum,DataStruct.Species*DataStruct.Soiltype);
UB=zeros(2,DataStruct.IrrNum,DataStruct.Species*DataStruct.Soiltype);
for s=1:Species % ��Ϊ��һ�����ֲݵ�
    for t=1:Soiltype
        eval(['S=DataStruct.Crop',num2str(s),'.Soil',num2str(t),'.Constraints;']);
        for irr=1:IrrNum
            %����ͬ�������ˮʱ����������ͬ��
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
%%��Ӧ�Ⱥ���
fun=@(Vector) -Fitness(DataStruct,Vector,Index);

initial=schedule;
initial(end-1)=DataStruct.Wood.Constraints.Emin;
initial(end)=DataStruct.Grass.Constraints.Emin;

Initial=ones(100,1)*initial;



nvars=length(Vector);
options=gaoptimset('InitialPopulation',Initial,'Populationsize',100,'UseParallel',true,'Generations',5000000);
%% ��true���ܻ������� ����ʱ��Ϊfalse


S=ga(fun,nvars,A,b,Aeq,beq,LB,UB,nonlcon,IntCon,options);

WUE=-fun(S);
result=Result(DataStruct,S);
%% resultʹ�÷���
%ͨ��result.Crop1.Soil1������result������
%����IrriAmount ET Schedule dW Qdrainage P������
%ͨ��result.Crop1.Soil1.IrriAmount�ķ�ʽ���з���