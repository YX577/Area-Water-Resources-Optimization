function [ WUE, Yield ] = Fitness_Sub( DataStructure, Schedule,  District, Crop, Soil)
%FITNESS_SUB �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
eval(['Sub = DataStructure.',District, '.','.',Crop, '.', Soil,';'])
[ET,dW,I] = Conceptmodel(Sub);




end

