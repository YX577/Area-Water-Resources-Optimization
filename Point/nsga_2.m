function Schedule = nsga_2(Data, pop,gen)
pop = round(pop);
gen = round(gen);
[M, V, min_range, max_range] = objective_description_function(Data);

chromosome = initialize_variables(pop, M, V, min_range, max_range, Data);

chromosome = non_domination_sort_mod(chromosome, M, V);

for i = 1 : gen

    pool = round(pop/2);
    tour = 2;
    
    parent_chromosome = tournament_selection(chromosome, pool, tour);

    mu = 20;
    mum = 20;
    offspring_chromosome = ...
        genetic_operator(parent_chromosome, ...
        M, V, mu, mum, min_range, max_range, Data);

    
    [main_pop,temp] = size(chromosome);
    [offspring_pop,temp] = size(offspring_chromosome);
    
    clear temp
    
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = ...
        offspring_chromosome;

    intermediate_chromosome = ...
        non_domination_sort_mod(intermediate_chromosome, M, V);
    
end
%% Result
% Save the result in ASCII text format.
% save solution.txt chromosome -ASCII

Schedule = chromosome;