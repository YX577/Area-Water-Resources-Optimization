function iterms = ItermsCal(Schedule,Para)
Schedule = Schedule(1 : 8);
Schedule = reshape(Schedule, 2, 4);
Sch = 0;
for i = 1 : 4
    Schedule(1, i) = Schedule(1, i) + Sch;
    Sch = Schedule(1, i);
end

iterms = zeros(1, 6);

Para.Management = Schedule; 
[SWC, iterms(2), iterms(3), iterms(4), iterms(5), iterms(6), ~] = Conceptmodel(Para);

iterms(1) = (SWC(end) - SWC(1)) * 1000;
end

