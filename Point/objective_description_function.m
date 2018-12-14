function [number_of_objectives, number_of_decision_variables, min_range_of_decesion_variable, max_range_of_decesion_variable] = objective_description_function(Data)
number_of_objectives = 2;
number_of_decision_variables = 8;
min_range_of_decesion_variable = zeros(1, 8);
max_range_of_decesion_variable = zeros(1, 8);

for i = 1 : 4
    min_range_of_decesion_variable(2 * (i - 1) + 1) = Data.Constraints.tmin;
    min_range_of_decesion_variable(2 * i) = Data.Constraints.Imin;
    max_range_of_decesion_variable(2 * (i - 1) + 1) = Data.Constraints.tmax;
    max_range_of_decesion_variable(2 * i) = Data.Constraints.Imax;
end