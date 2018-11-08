load 0806
load ScenariosETPRE
Str = zeros(3,3);
for YYY = 1 : 3
    Str(1,:) = 'Wet';
    Str(2,:) = 'Dry';
    Str(3,:) = 'Nor';
    eval(['pre=PRE_',Str(YYY,:),'(91:91+182);']);
    eval(['eto=ET0_',Str(YYY,:),'(91:91+182);']);  
    pre(find(isnan(pre)))=0;
    GrowingCycle=183;% �����ڳ�����λ���죩
    Species=4;%������������
    Soiltype=4;%������������
    Climatetype=1;%������������
    IrrNum=4;%��ˮ����
    
    for Q=50:5:150
    


    Qmax=Q/100*10^18;%�����ˮ��
    Qmin=(Q/100-0.05)*10^18;

    beta_wood_min=0.0971;%�ֵ�����betaֵ
    beta_wood_max=0.7563;%�ֵ�����betaֵ
    beta_grass_min=0.098;%�ݵ�����betaֵ
    beta_grass_max=0.413;%�ݵ�����betaֵ

    Quota=[520,520,520,790];

    Index=1;%�ı�Ŀ�꺯�������1��������ˮ��Ϊ��ĸ��2����ũ����ˮ��


    %%
    IrrMin=ones(4,4);
    %IrrMax=IrrMax*10;
    P=sum(pre);
    E=sum(eto);

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
        eto,Kc,pre,Soil,ThetaBuffer_Initial, ThetaRoot_Initial,WaterTable_Initial,RootZone);

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

    % ��ˮ�����Լ��
    Aa=zeros(Species*Soiltype,Species*Soiltype*IrrNum*2+2);
    bb=zeros(Species*Soiltype,1);

    for s=1:Species % ��Ϊ���������ֲݵ�
        for t=1:Soiltype
            bb((s-1)*Species+t)=Quota(s);
        
            for irr=1:IrrNum
                %����ͬ�������ˮʱ����������ͬ��
                Aa((s-1)*Soiltype+t,(s-1)*Soiltype+t+irr*2)=1;
            end
        end
    end
    A=A(:)';
    A=[A DataStruct.Wood.Area DataStruct.Grass.Area];

    A=[A;-A;Aa];
    b=[(DataStruct.Qmax+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area);...
        -(DataStruct.Qmin+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area);bb];
    Gar=DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area;
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
    fun=@(Vector) Fitness(DataStruct,Vector,Index);

    initial=schedule;
    initial(end-1)=DataStruct.Wood.Constraints.Emin;
    initial(end)=DataStruct.Grass.Constraints.Emin;

    Co=Qmax/(A(1,:)*initial'-Gar);

    for inde=2:2:(size(initial,2)-2)
        initial(inde)=floor(initial(inde)*Co);
    end

    Initial=ones(100,1)*initial;



    nvars=length(Vector);
    options=gaoptimset('InitialPopulation',Initial,'Populationsize',100,'UseParallel',true,'Generations',5000000000000);

    %options=gaoptimset('Populationsize',100,'UseParallel',true,'Generations',5000000000000);
    %% ��true���ܻ������� ����ʱ��Ϊfalse


    %S=gamultiobj(fun,nvars,A,b,Aeq,beq,LB,UB,nonlcon,options);
    Sch=ga(fun,nvars,A,b,Aeq,beq,LB,UB,nonlcon,IntCon,options);

    WUE=fun(Sch);
    result=Result(DataStruct,Sch);
    %% resultʹ�÷���
    %ͨ��result.Crop1.Soil1������result������
    %����IrriAmount ET Schedule dW Qdrainage P������
    %ͨ��result.Crop1.Soil1.IrriAmount�ķ�ʽ���з���

    Name_Year=['Result',Str(YYY,:),num2str(Q-5),'-',num2str(Q),'.mat'];

    save(Name_Year)
    end
end
