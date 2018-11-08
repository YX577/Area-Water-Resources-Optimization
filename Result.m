function result = Result(DataStruct,Vector)
Species=DataStruct.Species;
Soiltype=DataStruct.Soiltype;
DataStruct =IrrProcess(DataStruct,Vector,DataStruct.Species,DataStruct.Soiltype,DataStruct.IrrNum);
Schedule=reshape(Vector(1:end-2),[2,DataStruct.IrrNum,DataStruct.Species*DataStruct.Soiltype]);
result=struct();

dW_Total=0;
ETa_Total=0;
Qd_Total=0;
I_Total=0;
P_Total=0;
for d = 1 : District
    for s=1:Species
        for t=1:Soiltype
            eval(['S=DataStruct.District',num2str(d),'Crop',num2str(s),'.Soil',num2str(t),';']);

            [SWC,ETa,ETc,Qdrainage,Qsupply,P,I]=Conceptmodel(S.parameter,S.climate,S.Management,S.Initial);
            %ETsum((s-1)*Soiltype+t)=sum(ET*S.Area);
            %Q((s-1)*Soiltype+t)=sum(I*S.Area);      
      
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.IrriAmount=sum(I);']);%*S.Area;']);
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.ET=sum(ETa);']);%*S.Area;']);
            sch=Schedule(:,:,(s-1)*Soiltype+t);
            for k=2:DataStruct.IrrNum
                sch(1,k)=sch(1,k-1)+sch(1,k);
            end
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.Schedule=sch;']);
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.dW=(SWC(end)-SWC(1))*1000;']);%*S.Area;']);
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.Qdrainage=sum(Qdrainage);'])%;*S.Area;']);
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.P=sum(P);']);%*S.Area;']);
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.Qsupply=sum(Qsupply);'])%;*S.Area;']);
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.SWC=SWC;'])
        
            WUE=(sum(ETa)-sum(P))/(sum(I));
        
            eval(['result.Crop',num2str(s),'.Soil',num2str(t),'.WUE=WUE;'])
            dW_Total=dW_Total+(SWC(end)-SWC(1))*S.Area;
            Qd_Total=Qd_Total+sum(Qdrainage)*S.Area;
            I_Total=I_Total +sum(I)*S.Area;
            P_Total=P_Total+ sum(P)*S.Area;
            ETa_Total=ETa_Total+sum(ETa)*S.Area;
     
        end
    end
end
result.Wood.P=DataStruct.Wood.P;%*DataStruct.Wood.Area;
result.Wood.I=(Vector(end-1)-DataStruct.Wood.P);%*DataStruct.Wood.Area;
result.Grass.P=DataStruct.Grass.P;%*DataStruct.Grass.Area;
result.Grass.I=(Vector(end)-DataStruct.Grass.P);%*DataStruct.Grass.Area; 


P_Total=P_Total+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area;
I_Total=I_Total+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area;
ETa_Total=ETa_Total+DataStruct.Wood.P*DataStruct.Wood.Area+DataStruct.Grass.P*DataStruct.Grass.Area;

result.Total.ETa=ETa_Total;
result.Total.Qdrainage=Qd_Total;
result.Total.dW=dW_Total;
result.Total.P=P_Total;
result.Total.Irr=I_Total;
result.Total.WUE=(ETa_Total-P_Total+Qd_Total*(Qd_Total<0))/(I_Total-dW_Total*(dW_Total<0));


end
