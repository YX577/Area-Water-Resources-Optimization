function ExcelOutput(result,Species,Soiltype,Name)
sheet='Total';
total=result.Total;
xlswrite(Name,{'WaterBalnce'},sheet,'A1');
xlswrite(Name,{'WUE',total.WUE},sheet,'A2');
xlswrite(Name,{'Qdrainage','dW','P','IrrAmount','ET'},sheet,'A3');
Component=[total.Qdrainage,total.dW,total.P,total.Irr,total.ETa];
xlswrite(Name,Component,sheet,'A4');

for s=1:Species
    for t=1:Soiltype
        eval(['Qd=result.Crop',num2str(s),'.Soil',num2str(t),'.Qdrainage;'])
        eval(['SWC=result.Crop',num2str(s),'.Soil',num2str(t),'.SWC;'])
        eval(['dW=result.Crop',num2str(s),'.Soil',num2str(t),'.dW;'])
        eval(['P=result.Crop',num2str(s),'.Soil',num2str(t),'.P;'])
        eval(['IrrAmount=result.Crop',num2str(s),'.Soil',num2str(t),'.IrriAmount;'])
        eval(['Schedule=result.Crop',num2str(s),'.Soil',num2str(t),'.Schedule;'])
        eval(['ET=result.Crop',num2str(s),'.Soil',num2str(t),'.ET;'])
        eval(['WUE=result.Crop',num2str(s),'.Soil',num2str(t),'.WUE;'])
        sheet=['Crop',num2str(s),'Soil',num2str(t)];
        xlswrite(Name,{'WaterBalnce'},sheet,'A1');
        xlswrite(Name,{'WUE',WUE},sheet,'A2');
        xlswrite(Name,{'Qdrainage','dW','P','IrrAmount','ET'},sheet,'A3');
        Component=[Qd,dW,P,IrrAmount,ET];
        xlswrite(Name,Component,sheet,'A4');
        xlswrite(Name,{'Schedule'},sheet,'A5');
        xlswrite(Name,Schedule,sheet,'A6');
        xlswrite(Name,{'SWC'},sheet,'A8');
        xlswrite(Name,SWC,sheet,'A9');   
    end
end