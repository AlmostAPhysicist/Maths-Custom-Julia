function find_divisors(num, list::Vector{Int64})
    for i in 1:(num-1)
        if num%i == 0
            push!(list, i)
        end
    end
    return nothing
end
function find_divisor_sum(num, sum::Number=Int64(0))
    for i in 1:(num-1)
        if num%i == 0
            sum += i
        end
    end
    return sum
end
function generate_data(start::Number, final::Number)
    for i in start:final
        Sum = find_divisor_sum(i)
        if Sum == i
            print("\n", "-"^50)
            print("\n", i, "\t:\t", Sum, "\t")
            print("#"^10, "\t Perfect")
            print("\n", "-"^50)
        elseif Sum > i
            print("\n", "-"^50)
            print("\n", i, "\t:\t", Sum, "\t")
            print(">"^10)
            print("\n", "-"^50)
        else
            print("\n", i, "\t:\t", Sum, "\t")
        end
    end
    return nothing
end
function generate_data(final::Number)
    generate_data(1, final)
    return nothing
end


i = 1
while true
    if find_divisor_sum(i) >= i
        if i % 2 == 1
            print("\n", i, "\t:\t", Sum, "\t")
        end
    end
end
find_divisor_sum(198_585_576_189)