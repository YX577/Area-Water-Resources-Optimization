function Data = DataProcess(Soil, Crop, Constraints, Initial, Data)
Data.Parameter.cropparameter = Crop;    
Data.Parameter.soilparameter = Soil;
Data.Constraints = Constraints;
Data.Initial = Initial;
end