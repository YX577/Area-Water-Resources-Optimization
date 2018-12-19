% This is the most out layer loop
pop = 20;
gen = 20;
t = 0;


Schedules = zeros(pop, 12, 9);
Iterms = zeros(pop, 6, 9);

% iterms = [dW,ETa,Qdrainage,Qsupply,P,I]

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

for t = 0 : 5
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
INDEX = 1;
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
    
        Schedule = nsga_2(Data, pop, gen);
        Schedules(:, :, INDEX) = Schedule;
        
        for k = 1 : pop
            iterms = ItermsCal(Schedule(k, :), Data);
            Iterms(k,:,INDEX) = iterms;
        end
        
        INDEX = INDEX+ 1;
    end
end

Name = ['Year', num2str(2016 - 15 + t),'.mat'];
save(Name, 'Schedules', 'Iterms');

end