function [SWC,ETa,Qdrainage,Qsupply,P,I,Yield] = Conceptmodel(Structure)
Par = Structure.Parameter;
Cli = Structure.Climate;
Man = Structure.Management;
Ini = Structure.Initial;

[Anwsers,Monitor,Input]=Process(Par,Cli,Man,Ini);

ETa=sum(Monitor(:,1));
Qdrainage=sum(Monitor(:,2));
Qsupply=sum(Monitor(:,2));
% ETc=Monitor(:,4);

P=sum(Input(:,1));
I=sum(Input(:,2));

SWC=Anwsers(:,1);
Yield = polyval(Par.cropparameter.Yield,I) /1000;% unit t/ha

end