square(x) = x * x

function factorial(x)
    answer = 1
    for i in 1:x
        answer *= i
    end
    return answer
end

function nth_prime(n)
    prime = 1
    sum1 = 0
    for i in 1:(2^n)
        sum2 = 0
        for j in 1:i
            sum2 += floor(square(cospi((factorial(j-1) + 1)/j)))
        end
        sum1 += floor((n/sum2)^(1/n))
    end
    prime += sum1
    return prime
end

include("prime.jl")
function nth_prime_2(n)
    if n == 0
        return nothing
    else
        primes = 0
        index = 1
        while primes < n
            index += 1
            if check_prime(index)
                primes += 1
            end
        end
        return index
    end
end
            
