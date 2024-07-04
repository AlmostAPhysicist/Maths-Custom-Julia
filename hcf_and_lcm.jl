include("prime.jl")
#Check with 42 and 56

#The way I want this to work is to have a race in between the 2 numbers (Maybe extend this to more htan 2 numbers?)
#I will break down the numbers into factors, each time I get a factor from the main bunch, I check both the factor and the remaining portion to be a factor of the other number(s).
function hcf(number1::Int64, number2::Int64)
    common_factors_in_1 = Int64[]
    common_factors_in_2 = Int64[]
    winner = common_factors_in_1
    number1 = number1
    number2 = number2
    while true
        if number2 % number1 == 0
            push!(common_factors_in_1, number1)
            winner = common_factors_in_1
            break
        else
            factor = check_prime(number1, true)[2]
            if number2 % factor == 0
                push!(common_factors_in_1, factor)
            end
            number1 = number1 ÷ factor
        end
        if number1 % number2 == 0
            push!(common_factors_in_2, number2)
            winner = common_factors_in_2
            break
        else
            factor = check_prime(number2, true)[2]
            if number1 % factor == 0
                push!(common_factors_in_2, factor)
            end
            number2 = number2 ÷ factor
        end
    end
    return prod(winner)
end
    
function lcm_cstm(number1::Int64, number2::Int64)
    return number1 ÷ hcf(number1 , number2) * number2
end

