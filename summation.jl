
include("expr2func.jl")
import Base.invokelatest
function printhello(word1, word2, word3=", Bye!")
    println(word1, word2, word3)
end
Base.invokelatest(printhello, )
##
function Σ(from::Number = 1, to::Number = from, expr = :(i), arg::Symbol = :(i), step::Number = 1)
    if typeof(expr) == Symbol
        total = ((from + to)*(to - from + 1)) ÷ 2
    else
        total = 0
        f = expr2func(expr, arg)
        for i in from:step:to
            total += Base.invokelatest(f, i)
        end
    end
    return total
end

function Σ2(from::Number = 1, to::Number = from, expr = :(i), arg::Symbol = :(i), step::Number = 1)
    if typeof(expr) == Symbol
        total = ((from + to)*(to - from + 1)) ÷ 2
    else
        total = eval(Meta.parse("sum($(expr) for $(arg) in $from:$step:$to)"))
    end
    return total
end

