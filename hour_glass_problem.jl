#Problem:
#To form an output:
#1 2 3 4 5 6
# 7 8 9 0 9
#  0 9 0 9
#   0 9 0
#    9 0
#     9
#    0 9
#   0 9 0
#  9 0 9 0
# 9 0 9 8 7
#6 5 4 3 2 1
# i.e n sided triangular hourglass with 1:9 numbers followed by alternating 0 and 9s

#Generative Functions
function generate_data(n)
    data = Vector{Int64}()
    size = n*(n+1)/2
    if size <= 9
        push!(data, 1:n...)
    else
        push!(data, 1:9...)
        push!(data, (0, 9)...)
        for i in 1:(size - n)
            push!(data, alternate((-1)^i))
        end
    end
    return data
end
function f(x, n)
    return (n - abs(n-x))
end
function alternate(x)
    if x == -1
        return 0
    elseif x == 1
        return 9
    end
end
function calc_line_data(line_number, n, data)
    pseudo_x = f(line_number, n)
    init_space = (pseudo_x - 1)
    line_data = data[Int((2n-pseudo_x+1)*pseudo_x/2 - (n-pseudo_x) ) : Int((2n-pseudo_x+1)*pseudo_x/2)]
    if sign(n - line_number) == -1
        reverse!(line_data)
    end
    return line_data, init_space
end

# Layout Functions
function line_layout(line_data, init_space)
    print(" "^init_space)
    for i in line_data
        print(i, " ")
    end
    print("\n")
end
function layout(n) #Main Function
    data = generate_data(n)
    for line in 1:2n-1
        # line_data, init_space = calc_line_data(line, n, data)
        line_layout(calc_line_data(line, n, data)...)
    end
end
