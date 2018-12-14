function [number_of_objectives, number_of_decision_variable, min_range_of_decision_variable, max_range_of_decision_variable] = objective_description_function(Data)

number_of_objectives = 2;

min_range_of_decision_variable = zeros(1, 8);
max_range_of_decision_variable = zeros(1, 8);

Qs = Data.Constraint.QsMax;
Qg = Data.Constraint.QgMax;

for i = 1 : 4
    max_range_of_decision_variable(2 * (i - 1) + 1) = ;%time
    min_range_of_decision_variable(2 * (i - 1) + 1)= ;%time

    max_range_of_decision_variable(2 * i) = ;%amount
    min_range_of_decision_variable(2 * i) = ;%amount
end