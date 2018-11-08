function [ WUE, Yield ] = Fitness_Sub( DataStructure, Schedule,  District, Crop, Soil)
%FITNESS_SUB 此处显示有关此函数的摘要
%   此处显示详细说明
eval(['Sub = DataStructure.',District, '.','.',Crop, '.', Soil,';'])
[ET,dW,I] = Conceptmodel(Sub);




end

