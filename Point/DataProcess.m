function Data = DataProcess(Soil, Crop, Data)
Data.Parameter.cropparameter.Kc = Crop.Kc;
Data.Parameter.cropparameter.Yield = Crop.Yield;    
Data.Parameter.soilparameter = Soil;
end