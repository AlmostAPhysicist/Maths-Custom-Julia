function generate_permutations(input_list, length_to_generate, repetition::Bool)
    permutations = []
    if repetition
        generate_permutations_helper([], input_list, length_to_generate, permutations)
    else
        generate_permutations_no_repetition([], input_list, length_to_generate, permutations)
    end
    return permutations
end

function generate_permutations_helper(current_list, input_list, length_to_generate, permutations)
    if length(current_list) == length_to_generate
        if current_list ∉ permutations
            push!(permutations, current_list)
        end
        return
    end
    
    for i in eachindex(input_list)
        generate_permutations_helper([current_list..., input_list[i]], input_list, length_to_generate, permutations)
    end
end

function generate_permutations_no_repetition(current_list, input_list, length_to_generate, permutations)
    if length(current_list) == length_to_generate
        if current_list ∉ permutations
            push!(permutations, current_list)
        end
        return
    end
    
    for i in eachindex(input_list)
        generate_permutations_no_repetition([current_list..., input_list[i]], input_list[i+1:end], length_to_generate, permutations)
    end
end

function P(n, r) #Permutations nPr or P(n, r) = number of ways r items can be chosen and arranged in a set of n items
    return prod((n+1-r):n)
end

function C(n, r) #Combinations nCr or C(n, r) = number of ways to choose r items from a set of n items
    P(n, r)/factorial(r)
end

function count_correct(n, m)
    sets = generate_permutations([1,2,3,4], n, true)
    counter = 0
    for i in sets
        counts = count(isequal(1), i)
        if counts > 0
            counter +=  counts
            println(i)
        end
    end
    println("counter = ", counter)
    println("probability = ", counter/length(sets))
end
