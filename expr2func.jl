function expr2func(expr, arg)
    f = eval(Meta.parse("@eval $(arg) -> $(expr)"))
    return f
end


