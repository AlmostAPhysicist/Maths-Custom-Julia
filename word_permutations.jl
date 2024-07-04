##Program to generate n lettered permutations of a given word



function generate_permutations(input_word, n=length(input_word), repetition::Bool = false)
    code_block = ""
    word_generation_line = "word = "
    ending_block = ""
    for i in 1:n
        i_string = string(i)
        if repetition
            value = Vector{Bool}()
        else
            value = "["
            for i_dash in 1:i-1
                value *= "letter" * string(i_dash) * ", "
            end
            value *= "]"
        end
        code_block *= "for letter" * i_string * " in multi_reduce_array(letters, $(value));\n"
        word_generation_line *= "letter" * i_string * " * "
    ending_block *= "end;\n"
    end
    word_generation_line = word_generation_line[1:end-3]
    word_generation_line *= ";\nif word ∉ words;\npush!(words, word);\nend;\n"
    code_block *= word_generation_line * ending_block
    code_block = Meta.parse(code_block)
    eval(quote
        letters = sort(Vector{Char}($(input_word)))
        words = Vector{String}()
        $(code_block)
        return words
    end)
    # return code_block
end

function reduce_array(list::Array, value::Any = nothing, reduce_all::Bool = false)
    if value === nothing || value ∉ list
        return list
    else
        list_copy = copy(list)
        if reduce_all
            splice!(list_copy, findall(isequal(value), list_copy))
        else
            splice!(list_copy, findfirst(isequal(value), list_copy))
        end

        return list_copy
    end
end
function multi_reduce_array(list::Array, values::Array = Vector{Bool}(), reduce_all::Bool = false)
    if length(values) == 0
        return list
    else
        list_copy = copy(list)
        for value in values
            list_copy = reduce_array(list_copy, value, reduce_all)
        end
        return list_copy
    end
end

function P(n, r) #Permutations nPr or P(n, r) = number of ways r items can be chosen and arranged in a set of n items
    return prod((n+1-r):n)
end

function C(n, r) #Combinations nCr or C(n, r) = number of ways to choose r items from a set of n items
    P(n, r)/factorial(r)
end

function divide_stack(stack, piles=1, min = 0)
    cuts = piles - 1
    cut_range = (0+min):(length(stack)-min)
    


