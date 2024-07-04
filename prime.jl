"""
    check_prime(number::Integer, return_factor::Boolean=false)

Checks whether the given `number` is prime or not.
Returns a Boolean value.

If `return_factor` is set to `true` then the first factor (except 1) is also returned. 

    #For 1 as input, 1 is returned as the factor

# Examples
```jldoctest
julia> check_prime(3)
true

julia> check_prime(10)
false

julia> check_prime(17)
true

julia> check_prime(BigInt(2)^100)
false

julia> check_prime(15, true)
(false, 3)

julia> is_prime, factor = check_prime(27, true); println(is_prime); println(factor)
false
3

``` 
"""
function check_prime(number::Int64, return_factor::Bool=false)
    factor = number
    if number == 1
        if return_factor
            return false, number
        else
            return false
        end

    elseif  number == 2
        if return_factor
            return true, number
        else
            return true
        end

    else
        if iseven(number)
            is_prime = false
            factor = 2

        else
            is_prime = true
            @fastmath search_range = 3:2:floor(Int64, sqrt(number)) #skip all the even numbers as the number is not even

            for num in search_range
                if number % num == 0
                    is_prime = false
                    factor = num
                    break

                end
            end
        end

        if return_factor
            return is_prime, factor
        else
            return is_prime
        end
    end
end
function check_prime(number::BigInt, return_factor::Bool=false)
    factor = number
    if number == 1
        if return_factor
            return false, number
        else
            return false
        end

    elseif  number == 2
        if return_factor
            return true, number
        else
            return true
        end

    else
        if iseven(number)
            is_prime = false
            factor = 2

        else
            is_prime = true
            @fastmath search_range = 3:2:floor(BigInt, sqrt(number)) #skip all the even numbers as the number is not even

            for num in search_range
                if number % num == 0
                    is_prime = false
                    factor = num
                    break

                end
            end
        end

        if return_factor
            return is_prime, factor
        else
            return is_prime
        end
    end
end



"""
    prime_factorize(number::Integer, return_type::DataType = Tuple)
    prime_factorize(number::Integer, return_type::UnionAll = Tuple)

Computes the prime factors of a given number.

You can have a single argument `number` .

You can have a second (optional) argument `return_type::DataType` .
>`return_type` can be set to `Expr` (Default), `String`, `Tuple`, `Dict`, `Vector` or `Matrix` (`Matrix` has an alias `Array`)

    #prime_factorize(1) returns 1


# Examples
```jldoctest
julia> prime_factorize(12)
2-element Vector{Tuple{Int64, Int64}}:
 (2, 2)
 (3, 1)

julia> prime_factorize(24, Dict)
 Dict{Int64, Int64} with 2 entries:
   2 => 3
   3 => 1

julia> prime_factorize(17, String)
 "17"

julia> prime_factorize(20, Expr)
 :(2 ^ 2 * 5)

julia> begin
       factors, powers = prime_factorize(BigInt(2)^100 - 1, Vector)
       println(factors)
       println(powers)
       end
 [3, 5, 11, 31, 41, 101, 251, 601, 1801, 4051, 8101, 268501]
 [1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
```
"""
function prime_factorize(number::Int64, return_type::DataType = Tuple)
    #1 is niether prime, not composite so get rid of that
    if number == 1
        return 1
    else
        prime_factors = Vector{Int64}()
        powers = Vector{Int64}()
        remaining = number
    #If I get rid of the evens, I can skip all the even numbers to check as a factor
        if iseven(remaining)
            push!(prime_factors, 2)
            push!(powers, 1)
            remaining /= 2
        end

        while iseven(remaining)
            powers[end] += 1
            remaining /= 2
        end

    #Now the general search for remaining bit of prime factors begins
        search_exhausted = false #flag to quit while loop
        if remaining == 1 #If the number was just composed of 2's, it has no more prime factors
            search_exhausted = true
        end
        @fastmath max_search = floor(Int64, sqrt(remaining)) #If the factor isn't upto the square root, then the number is prime!
        search_range = 3:2:max_search #skip all the even numbers as it has already been checked that the number is not even
        
    #Finally, the actual loop
        while search_exhausted != true

            if length(search_range) == 0 #This means the number is prime! eg: in case of 3 and 5, here the square root is less than 3, so the length of range = 0
                if remaining in prime_factors
                    powers[end] += 1
                else
                    push!(prime_factors, remaining)
                    push!(powers, 1)
                end
                search_exhausted = true
            end

            for num in search_range
                if remaining % num == 0
                    if num in prime_factors
                        powers[end] += 1
                    else
                        push!(prime_factors, num)
                        push!(powers, 1)
                    end
                    remaining /= num
                    @fastmath max_search = floor(Int64, sqrt(remaining))
                    search_range = num:2:max_search
                    break
                else
                    if num == search_range[end]
                        push!(prime_factors, remaining)
                        push!(powers, 1)
                        search_exhausted = true
                    end
                end
            end
        end
    #End of loop
        if return_type == Tuple
            return [(prime_factors[i], powers[i]) for i in 1:length(prime_factors)]
        else

            expr = "" #I figured the easiest way is to create a string. Expressions didn't seem to work for numbers like 2 * 3^2, here, 2 was already an Integer. Also, expressions are huge!
            factor_index = 1
            for factor in prime_factors
                str = string(factor)
                if powers[factor_index] != 1 
                    str *= "^$(powers[factor_index])"            
                end
                str *= " * "
                factor_index += 1
                expr *= str
            
            end

            expr = expr[1:end-3]
            if return_type == Expr
                expr = Meta.parse(expr)
            end
            return expr
        end
    end
end
function prime_factorize(number::Int64, return_type::UnionAll = Tuple)
    #1 is niether prime, not composite so get rid of that
    if number == 1
        return 1
    else
        prime_factors = Vector{Int64}()
        powers = Vector{Int64}()
        remaining = number
    #If I get rid of the evens, I can skip all the even numbers to check as a factor
        if iseven(remaining)
            push!(prime_factors, 2)
            push!(powers, 1)
            remaining /= 2
        end

        while iseven(remaining)
            powers[end] += 1
            remaining /= 2
        end

    #Now the general search for remaining bit of prime factors begins
        search_exhausted = false #flag to quit while loop
        if remaining == 1 #If the number was just composed of 2's, it has no more prime factors
            search_exhausted = true
        end
        @fastmath max_search = floor(Int64, sqrt(remaining)) #If the factor isn't upto the square root, then the number is prime!
        search_range = 3:2:max_search #skip all the even numbers as it has already been checked that the number is not even
        
    #Finally, the actual loop
        while search_exhausted != true

            if length(search_range) == 0 #This means the number is prime! eg: in case of 3 and 5, here the square root is less than 3, so the length of range = 0
                if remaining in prime_factors
                    powers[end] += 1
                else
                    push!(prime_factors, remaining)
                    push!(powers, 1)
                end
                search_exhausted = true
            end

            for num in search_range
                if remaining % num == 0
                    if num in prime_factors
                        powers[end] += 1
                    else
                        push!(prime_factors, num)
                        push!(powers, 1)
                    end
                    remaining /= num
                    @fastmath max_search = floor(Int64, sqrt(remaining))
                    search_range = num:2:max_search
                    break
                else
                    if num == search_range[end]
                        push!(prime_factors, remaining)
                        push!(powers, 1)
                        search_exhausted = true
                    end
                end
            end
        end
    #End of loop

        if return_type == Vector 
            return prime_factors, powers
        elseif return_type == Matrix || return_type == Array
            return cat(prime_factors, powers, dims = 2)
        elseif return_type == Dict
            return Dict(prime_factors[i]=>powers[i] for i in 1:length(prime_factors))
        end
    end
end

function prime_factorize(number::BigInt, return_type::DataType = Tuple)
    #1 is niether prime, not composite so get rid of that
    if number == 1
        return 1
    else
        prime_factors = Vector{Int64}()
        powers = Vector{Int64}()
        remaining = number
    #If I get rid of the evens, I can skip all the even numbers to check as a factor
        if iseven(remaining)
            push!(prime_factors, 2)
            push!(powers, 1)
            remaining /= 2
        end

        while iseven(remaining)
            powers[end] += 1
            remaining /= 2
        end

    #Now the general search for remaining bit of prime factors begins
        search_exhausted = false #flag to quit while loop
        if remaining == 1 #If the number was just composed of 2's, it has no more prime factors
            search_exhausted = true
        end
        @fastmath max_search = floor(BigInt, sqrt(remaining)) #If the factor isn't upto the square root, then the number is prime!
        search_range = 3:2:max_search #skip all the even numbers as it has already been checked that the number is not even
        
    #Finally, the actual loop
        while search_exhausted != true

            if length(search_range) == 0 #This means the number is prime! eg: in case of 3 and 5, here the square root is less than 3, so the length of range = 0
                if remaining in prime_factors
                    powers[end] += 1
                else
                    push!(prime_factors, remaining)
                    push!(powers, 1)
                end
                search_exhausted = true
            end

            for num in search_range
                if remaining % num == 0
                    if num in prime_factors
                        powers[end] += 1
                    else
                        push!(prime_factors, num)
                        push!(powers, 1)
                    end
                    remaining /= num
                    @fastmath max_search = floor(BigInt, sqrt(remaining))
                    search_range = num:2:max_search
                    break
                else
                    if num == search_range[end]
                        push!(prime_factors, remaining)
                        push!(powers, 1)
                        search_exhausted = true
                    end
                end
            end
        end
    #End of loop
        if return_type == Tuple
            return [(prime_factors[i], powers[i]) for i in 1:length(prime_factors)]
        else

            expr = "" #I figured the easiest way is to create a string. Expressions didn't seem to work for numbers like 2 * 3^2, here, 2 was already an Integer. Also, expressions are huge!
            factor_index = 1
            for factor in prime_factors
                str = string(factor)
                if powers[factor_index] != 1 
                    str *= "^$(powers[factor_index])"            
                end
                str *= " * "
                factor_index += 1
                expr *= str
            
            end

            expr = expr[1:end-3]
            if return_type == Expr
                expr = Meta.parse(expr)
            end
            return expr
        end
    end
end

function prime_factorize(number::BigInt, return_type::UnionAll = Tuple)
    #1 is niether prime, not composite so get rid of that
    if number == 1
        return 1
    else
        prime_factors = Vector{Int64}()
        powers = Vector{Int64}()
        remaining = number
    #If I get rid of the evens, I can skip all the even numbers to check as a factor
        if iseven(remaining)
            push!(prime_factors, 2)
            push!(powers, 1)
            remaining /= 2
        end

        while iseven(remaining)
            powers[end] += 1
            remaining /= 2
        end

    #Now the general search for remaining bit of prime factors begins
        search_exhausted = false #flag to quit while loop
        if remaining == 1 #If the number was just composed of 2's, it has no more prime factors
            search_exhausted = true
        end
        @fastmath max_search = floor(BigInt, sqrt(remaining)) #If the factor isn't upto the square root, then the number is prime!
        search_range = 3:2:max_search #skip all the even numbers as it has already been checked that the number is not even
        
    #Finally, the actual loop
        while search_exhausted != true

            if length(search_range) == 0 #This means the number is prime! eg: in case of 3 and 5, here the square root is less than 3, so the length of range = 0
                if remaining in prime_factors
                    powers[end] += 1
                else
                    push!(prime_factors, remaining)
                    push!(powers, 1)
                end
                search_exhausted = true
            end

            for num in search_range
                if remaining % num == 0
                    if num in prime_factors
                        powers[end] += 1
                    else
                        push!(prime_factors, num)
                        push!(powers, 1)
                    end
                    remaining /= num
                    @fastmath max_search = floor(BigInt, sqrt(remaining))
                    search_range = num:2:max_search
                    break
                else
                    if num == search_range[end]
                        push!(prime_factors, remaining)
                        push!(powers, 1)
                        search_exhausted = true
                    end
                end
            end
        end
    #End of loop

        if return_type == Vector 
            return prime_factors, powers
        elseif return_type == Matrix || return_type == Array
            return cat(prime_factors, powers, dims = 2)
        elseif return_type == Dict
            return Dict(prime_factors[i]=>powers[i] for i in 1:length(prime_factors))
        end
    end
end


function prime_fact_recc(number, prime_factor_list, prime_factor_exp_list)
    if number == 1 || number == 0 #I don't want the user to get an error message here, just return these numbers as factors even though they aren't prime, as they don't have a prime factor!
        if length(prime_factor_list) == 0
            push!(prime_factor_list, number)
            push!(prime_factor_exp_list, 1)
        end
        return prime_factor_list, prime_factor_exp_list
    else
        if iseven(number)
            update_factors(2, prime_factor_list, prime_factor_exp_list)
            prime_fact_recc(number ÷ 2, prime_factor_list, prime_factor_exp_list)
        else
            if length(prime_factor_list) == 0
                range = 3:2:floor(Int, sqrt(number))
            else
                if prime_factor_list[end] != 2
                    range = prime_factor_list[end]:2:floor(Int, sqrt(number))
                else
                    range = 3:2:floor(Int, sqrt(number))
                end
            end
            if length(range) == 0 #For 3 and 5
                if prime_factor_list[end] != number
                    push!(prime_factor_list, number)
                    push!(prime_factor_exp_list, 1)
                else
                    prime_factor_exp_list[end] += 1
                end
                prime_fact_recc(1, prime_factor_list, prime_factor_exp_list)
            else
                #If the factor isn't upto the square root, then the number is prime!
                for i in range #skip all the even numbers as it has already been checked that the number is not even
                    if number % i == 0
                        update_factors(i, prime_factor_list, prime_factor_exp_list)
                        prime_fact_recc(number ÷ i, prime_factor_list, prime_factor_exp_list)
                        break
                    else
                        if i == range[end] #Means the number was prime and no factors were found
                            push!(prime_factor_list, number)
                            push!(prime_factor_exp_list, 1)
                            prime_fact_recc(1, prime_factor_list, prime_factor_exp_list)
                        end
                    end
                end
            end
        end
    end
end


function update_factors(factor, prime_fact_list, prime_fact_exp_list)
    if length(prime_fact_list) == 0
        push!(prime_fact_list, factor)
        push!(prime_fact_exp_list, 1)
    else
        if prime_fact_list[end] == factor
            prime_fact_exp_list[end] += 1
        else
            push!(prime_fact_list, factor)
            push!(prime_fact_exp_list, 1)
        end
    end
end
