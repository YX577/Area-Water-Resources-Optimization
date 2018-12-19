function [WUE, Yield] = Fitness(Schedule, Para)
Schedule = reshape(Schedule, 2, 4);
Sch = 0;
for i = 1 : 4
    Schedule(1, i) = Schedule(1, i) + Sch;
    Sch = Schedule(1, i);
end

Para.Management = Schedule; 
[~, ETa, ~, ~, ~, ~, Yield] = Conceptmodel(Para);
%dW = SWC(end) - SWC(1);
%ETa = sum(ETa);

WUE = ETa;
Yield = -Yield;

end 