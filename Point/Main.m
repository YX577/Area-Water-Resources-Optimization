% This is the most out layer loop
Schedules = zeros(50, 12, 9);
Data = struct();

load PRE;
load ETo;
load YIELD;
load Maize;
load Wheat;
load Others;
load Soil;
load IMAX;
load ZhangYe;

t = 0;
%t = 0 ±íÊ¾2001Äê
pre = PRE{end - 15 + t};
pre(find(isnan(pre))) = 0;
eto = ETo{end - 15 + t};

if(mod((2001 + t),4))
    pre = pre(90 : 90 + 183);
    eto = eto(90 : 90 + 183);
else
    pre = pre(91 : 91 + 183);
    eto = eto(91 : 91 + 183);
end

initial =struct();
soil = struct();
crop = struct();
constraints = struct();
Data.Parameter.timeparameter.dt = 1;

for i = 1 : 3
    for j = 1: 3
        switch i
            case 1
                Cycle = find(Wheat);
                Kc = Wheat(Cycle);
            case 2
                Cycle = find(Maize);
                Kc = Maize(Cycle);
            case 3
                Cycle = find(Others);
                Kc = Others(Cycle);
        end
        
        switch j
            case 1
                Para = Soil(1, :);
            case 2
                Para = Soil(2, :);
            case 3
                Para = Soil(4, :);
        end
        Data.Climate.ETo = eto(Cycle);
        Data.Climate.P = pre(Cycle);
    
        soil = SoilIni(soil, Para);
        crop = CroIni(crop, Kc, YIELD(i, :));
        constraints = ConIni(constraints,IMAX(i));
        initial = Initialize(initial, soil); 
    
        Data = DataProcess(soil, crop, constraints, initial, Data);
    
        Schedule = nsga_2(Data, 50, 50);
        Schedules(:, :, i) = Schedule;
    end
end

for i = 1 : 9
    figure(i);
    plot(-Scheudules(:, 9, i), -Schedules(:, 10, i),'x');
end

    






