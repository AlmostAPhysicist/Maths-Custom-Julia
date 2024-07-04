using Random

function generate_name(word_len_range::Tuple{Int64, Int64} = (4, 5))
    len_word = rand(word_len_range[1]:word_len_range[2])
    letters = ['a':'z'...,]
    shuffle!(letters)
    word_letters = [i for i in letters[1:len_word]]
    word = ""
    for letter in word_letters
        word *= letter
    end
    return word
end

function generate_name(word_len_range::Int64 = 5)
    len_word = word_len_range
    letters = ['a':'z'...,]
    shuffle!(letters)
    word_letters = [i for i in letters[1:len_word]]
    word = ""
    for letter in word_letters
        word *= letter
    end
    return word
end