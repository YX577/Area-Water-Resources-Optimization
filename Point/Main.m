% This is the most out layer loop
Schedules = zeros(50, 8, 9);
Data = struct();
Data.Initial;
Data.Constraint;

Data.Climate.Eto = ;
Data.Climate.Pre = ;

for i = 1 : 9

    Data = DataProcess(Soil, Crop);
    Schedule = nsga2(Data);
    Schedules(:, :, i) = Schedule;
end








