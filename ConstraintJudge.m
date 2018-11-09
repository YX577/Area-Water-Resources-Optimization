function Voilation = ConstriantJudge(DataStructure, Schedule)
District = Data.District;
Crop=Data.Crop;
Soil=Data.Soil;
Schedule = reshape(Schedule, 3, 4, 147);

Qs = 0
Qg = 0;
Index = 1;

for d = 1 : length(District)
    for c = 1 : length(Crop)
        for s = 1 : length(Soil)
            if(isfield(Data,District{d}))
                eval(['S = Data.',District{d},';'])
                if(isfield(S,Crop))
                    eval(['S = S.',Crop{c},';'])
                    if(isfield(S,Soil{s}))
                        eval(['S = S.',Soil{s},';'])
                        Sch = reshape(Schedule(:,:,Index),3,4)
                        eval(['Data.',District{d},'.',Crop{c},'.',Soil{s},'='... 
                        'IrrProcess(Data.',District{d}','.',Crop{c},'.',Soil{s},'Sch);']);
                        Qs = Qs + sum(Sch(2, :)) * S.Area;
                        Qg = Qg + sum(Sch(3, :)) * S.Area;
                        Index =Index + 1;
                    end
                end
            end
        end
    end
end

if((Qs <= QsMax) && (Qg <= QgMax))
    Voilation  = false.
else
    if((Qs <= QsMax) && (Qg > QgMax))
        Voilation = Qg - QgMax;
    else if(Qs > QsMax) && (Qg <= QgMax)
        Voilation = Qs - QsMax;
    else
        Voilation = sum(Qs + Qg) - sum(QsMax + QgMax);
    end
end

end