#A function that maps values form 1 range to values from another range

DEFAULT_MAP_RANGE = (0, 1)

function map2(value, range_from::Tuple, range_to::Tuple= DEFAULT_MAP_RANGE, round_to=nothing)
    return round2(range_to[1] + ((value - range_from[1]) * (range_to[2] - range_to[1]) / (range_from[2] - range_from[1])), round_to)
end

function round2(value, to=nothing)
    if to === nothing
        return value
    elseif to == 0
        return 0
    else
        remainder = value % to
        if abs(remainder) < abs(to / 2) #i.e. if |remainder| is closer to 0, away from |to|
            # return (to)*(value ÷ to)
            return (value - remainder)
        
        elseif abs(remainder) > abs(to / 2) #i.e. if |remainder| is closer to |to|, away from 0
            # return ((to)*(value ÷ to) + abs(to))
            return (value + sign(1*value)*(abs(to) - abs(remainder))) 

        else #i.e. if remainder is equal to to/2
            if iseven(modf(value)[2])
                # return ((to)*(value ÷ to) + abs(to))
                return (value - remainder)

            else
                # return (to)*(value ÷ to)
                return (value + sign(1*value) * (abs(to) - abs(remainder)))
            end
        end
    end
end


function intfloat(number)
    if modf(number)[2] == number
        try
            return Int(number) 
        catch
            return BigInt(number)
        end
    else
        return number
    end
end


