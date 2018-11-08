function Data = WeatherProcess( Data, P, ETo )
%WEATHERPROCESS 此处显示有关此函数的摘要
%   此处显示详细说明
District = Data.District;
CropSpeices = Data.Crop;
SoilType = Data.Soil;

for d = 1 : length(District)
    for c = 1: length(CropSpeices)
        for s = 1: length(SoilType)
            if(isfield(Data,District{d}))
                eval(['S = Data.',District{d},';'])
                if(isfield(S,CropSpeices))
                    eval(['S = S.',CropSpeices{c},';'])
                    if(isfield(S,SoilType{s}))
                        eval(['Data.',District{d},'.',CropSpeices{c},'.',SoilType{s},'.Climate.P = P;'])
                        eval(['Data.',District{d},'.',CropSpeices{c},'.',SoilType{s},'.Climate.ETo = ETo;'])
                    end
                end
            end
        end
    end
end



end

