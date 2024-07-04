include("word_permutations.jl")


word = "ABCDEF"

total_pairs = generate_permutations(word, 2)
reduced_pair = []


function str2pair(str)
    return tuple([i for i in str]...)
end

function swap(pair)
    return (pair[2], pair[1])
end

for i in total_pairs
    if swap(str2pair(i)) ∉ reduced_pair
        push!(reduced_pair, str2pair(i))
    end
end
