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