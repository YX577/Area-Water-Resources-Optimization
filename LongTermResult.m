for YEAR=3
    if YEAR==1
        year='Wet';
    else if YEAR==2
            year='Nor';
        else
            year='Dry';
        end
    end
        
    for Q=50:5:150
        load (['Result',year,num2str(Q-5),'-',num2str(Q)]);
        Name=[year,num2str(Q-5),'-',num2str(Q),'.xlsx'];
        ExcelOutput(result,Species,Soiltype,Name);
    end
end   