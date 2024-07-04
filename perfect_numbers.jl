#A perfect number, a positive integer that is equal to the sum of its proper divisors. The smallest perfect number is 6, which is the sum of 1, 2, and 3.



function check_perfect(number::Int64, return_divisors=false)
    if return_divisors
        proper_divisors = Vector{Int64}()
    end
    divisor_sum = 0
    for i in 1:(number ÷ 2)
        if number % i == 0
            if return_divisors
                push!(proper_divisors, i)
            end
            divisor_sum += i
        end
    end
    if return_divisors
        return (divisor_sum == number), proper_divisors
    else
        return  (divisor_sum == number)
    end
end
