function [number_of_objectives, number_of_decision_variable, min_range_of_decision_variable, max_range_of_decision_variable] = objective_description_function(Data)

%% function [number_of_objectives, number_of_decision_variables, min_range_of_decesion_variable, max_range_of_decesion_variable] = objective_description_function()
% This function is used to completely describe the objective functions and
% the range for the decision variable space etc. The user is prompted for
% inputing the number of objectives, numebr of decision variables, the
% maximum and minimum range for each decision variable and finally the
% function waits for the user to modify the evaluate_objective function to
% suit their need.

%  Copyright (c) 2009, Aravind Seshadri
%  All rights reserved.
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.
% Obtain the number of objective function
number_of_objectives = 2;
% Obtain the number of decision variables
District = Data.District;
Crop=Data.Crop;
Soil=Data.Soil;
number_of_decision_variable = 142 * 8;

min_range_of_decision_variable = zeros(1, number_of_decision_variable);
max_range_of_decision_variable = zeros(1, number_of_decision_variable);

Index = 1;
for d = 1: length(District)
    for c = 1 : length(Crop)
        for s = 1 : length(Soil)
            if(isfield(Data,District{d}))
                eval(['S = Data.',District{d},';'])
                if(isfield(S,Crop))
                    eval(['S = S.',Crop{c},';'])
                    if(isfield(S,Soil{s}))
                        eval(['S = S.',Soil{s},';'])
       
                        for i = 1 : 4
                            
                            min_range_of_decision_variable(8 * (Index - 1) + 2 * (i - 1) + 1) = S.Constraint.tmin;
                            min_range_of_decision_variable(8 * (Index - 1) + 2 * (i - 1) + 2) = S.Constraint.Imin;
                                
                            max_range_of_decision_variable(8 * (Index - 1) + 2 * (i - 1) + 1) = S.Constraint.tmax;
                            max_range_of_decision_variable(8 * (Index - 1) + 2 * (i - 1) + 2) = S.Constraint.Imax;
                        end 
                        Index = Index + 1;
                    end 
                end 
            end 
        end 
    end    
end

g = sprintf('\n Now edit the function named "evaluate_objective" appropriately to match your needs.\n Make sure that the number of objective functions and decision variables match your numerical input. \n Make each objective function as a corresponding array element. \n After editing do not forget to save. \n Press "c" and enter to continue... ');
% Prompt the user to edit the evaluate_objective function and wait until
% 'c' is pressed.
x = input(g, 's');
if isempty(x)
    x = 'x';
end
while x ~= 'c'
    clc
    x = input(g, 's');
    if isempty(x)
        x = 'x';
    end
end    
