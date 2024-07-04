using DataStructures
using Primes

function compare!(i::Int64, factor_set::Set{Int64}, seq::SortedDict{Int64,Set{Int64},Base.Order.ForwardOrdering})
    if ndigits(i) == length(factor_set)
        seq[i] = factor_set
    end
end

function generate(n::Int64, seq=SortedDict{Int64,Set{Int64}}(), start::Int64=1)
    for i in start:10^n
        compare!(i, factor(Set, i), seq)
    end
    return seq
end

function gen_seq(n::Int64, seq=SortedDict{Int64,Set{Int64}}(), start::Int64=1)
    for i in start:10^n
        if ndigits(i) == length(factor(Set, i))
            seq[i] = factor(Set, i)
        end
    end
    return seq
end
