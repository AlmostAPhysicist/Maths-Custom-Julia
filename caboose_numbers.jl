using Primes
function check_num(num, show::Bool=false)
    if isprime(num)
        flag = true
        for i in 0:num-1
            if isprime(i^2 - i + num) == false
                flag = false
                break
            end
        end
        if show == true
            if flag == true
                for i in 0:num-1
                    println("$(i)^2 - $i + $(num) = $(i^2) - $i + $(num) = $(i^2-i+num)\n")
                end
            end
        end
        return flag
    else
        return false
    end
end


function compute(last, show::Bool=false)
    for i in 1:last
        if check_num(i, show)
            println(i)
            println("------------------------------")
        end
    end
end


function compute(first, last, show::Bool=false)
    for i in first:last
        if check_num(i, show)
            println(i)
            println("------------------------------")
        end
    end
end