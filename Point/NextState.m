function [Next,Inter] = NextState(parameter,currentstate,ETo,P,I)
%% CHANGE This function is to culculate the value of moisture change
%% currentstate means the state of the moisture in the current day, the Wrootzone should be included

%% Parameter Extract

% Soil Parameter
a=parameter.soilparameter.a;
b=parameter.soilparameter.b;
FCroot=parameter.soilparameter.FCroot;
FCbuffer=parameter.soilparameter.FCbuffer;
Critical=parameter.soilparameter.Critical;
PWP=parameter.soilparameter.PWP;

% Crop Parameter
Kc=parameter.cropparameter.Kc;
RootZone=parameter.cropparameter.RootZone;

% Time Parameter
dt=parameter.timeparameter.dt;

%% Current State Extract
ThetaRoot=currentstate.ThetaRoot;
ThetaBuffer=currentstate.ThetaBuffer;
WaterTable=currentstate.WaterTable;

%% Some Inter-parameter Calculation
Wroot=ThetaRoot.*RootZone;
Wbuffer=ThetaBuffer.*(WaterTable-RootZone);
Wroothold=FCroot.*RootZone;
Wrootcritical=Critical.*RootZone;

%% Water banlance calculation
qdrainage=Qdrainage(a,b,Wroot,Wroothold,Wrootcritical);

ETc=ETo*Kc;
ks=Ks(ThetaRoot,PWP,FCroot);
etfield=ETfield(ks,Kc,ETo);

dwroot=dWroot(P,I,etfield,qdrainage,dt);

Wbufferhold=FCbuffer*(WaterTable-RootZone);
qsupply=Qsupply(Wbuffer,qdrainage,Wbufferhold);
dwbuffer=dWbuffer(qsupply,qdrainage,dt);

%% Data output
Next.ThetaRoot=(Wroot+dwroot)/RootZone;
Next.ThetaBuffer=(Wbuffer+dwbuffer)/(WaterTable-RootZone);
Next.WaterTable=WaterTable;
% Next.WaterTable=;

Inter.ETa=etfield;
Inter.Qsupply=qsupply;
Inter.Qdrainage=qdrainage;
Inter.ETc=ETc;
end