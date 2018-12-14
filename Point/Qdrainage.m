function [y] = Qdrainage(a,b,Wroot,Wroothold,Wrootcritical)
%% This function is to calculate the Qdrainage
% a b FC Wrootcritical are all parameters
% The Wroot is a current state
% if (Wroot-Wrootcritical)<0
%     y=0;
% else
%     y=a.*(Wroot./Wroothold).^b.*(Wroot-Wrootcritical);
% end
y=a.*(Wroot./Wroothold).^b.*(Wroot-Wrootcritical);
end

