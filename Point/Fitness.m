function [WUE, Yield] = Fitness(Schedule, Para)
Schedule = reshape(Schedule, 2, 4);
Para.Management. 
[SWC,ETa,Qdrainage,Qsupply,P,I,Yield] = Conceptmodel(Para);
dW = SWC(end) - SWC(1);

WUE = ET / (Pre + Irr + dW);

end 