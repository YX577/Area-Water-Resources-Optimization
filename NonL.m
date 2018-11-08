function [y1,y2]=NonL(DataStruct,Vector)
Species=DataStruct.Species;
Soiltype=DataStruct.Soiltype;
DataStruct =IrrProcess(DataStruct,Vector,DataStruct.Species,DataStruct.Soiltype,DataStruct.IrrNum);
Qd=zeros(1,Soiltype*Species);
for s=1:Species
    for t=1:Soiltype
        eval(['S=DataStruct.Crop',num2str(s),'.Soil',num2str(t),';']);
        [~,~,~,Qdrainage,~,~,~]=Conceptmodel(S.parameter,S.climate,S.Management,S.Initial);
        Qd((s-1)*Species,+t)=sum(Qdrainage)*S.Area;
    end
end
y1=0;
y2=sum(Qd);