function [WUE,Yield] = Fitness_Area(Data,Schedule)
District = Data.District;
Crop=Data.Crop;
Soil=Data.Soil;

Schedule = reshape(Schedule,2,4,147);
PRE = 0;
Irr = 0;
ET = 0;
dW = 0;
Y = 0;
Index = 1;
for d = 1: length(District)
    for c = 1 : length(Crop)
        for s = 1 : length(Soil)
           if(isfield(Data,District{d}))
                eval(['S = Data.',District{d},';'])
                if(isfield(S,Crop))
                    eval(['S = S.',Crop{c},';'])
                    if(isfield(S,Soil{s}))
                        eval(['S = S.',Soil{s},';'])
                        S = IrrProcess(S,reshape(Schedule(:,:,Index),2,4));

                        Area = S.Area;
                        [SWC,ETa,Qdrainage,Qsupply,P,I,Yield] = Conceptmodel(S);
                        dW = dW + (SWC(end) - SWC(1)) * Area;
                        ET = ET + ETa * Area;
                        PRE = PRE + P * Area;
                        Irr = Irr + I *Area;
                        Y = Y + Yield * Area;
                        Index =Index + 1;
                    end
                end
            end 
        end
    end
end

WUE = ET /(PRE + Irr + dW);
% Yield 单位需要注意
end