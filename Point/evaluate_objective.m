function f = evaluate_objective(x, M, V, Data)
[f(1), f(2)] = Fitness(x(1 : V), Data); 
end
