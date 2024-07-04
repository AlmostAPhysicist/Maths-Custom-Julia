using GLMakie, GeometryBasics
include("map2.jl")
include("../General/clear_line.jl")


sample_space = 1000000
resolution = (1000, 1000)
# stroke_width = 0.05


x_range = (0, resolution[1])
y_range = (0, resolution[2])
origin = resolution ./ 2
radius = resolution[1]/2

# outer_c = decompose(Point2f, Circle(Point2f(0), 1))
# inner_c = decompose(Point2f, Circle(Point2f(0), 1 - 1*stroke_width))
# Circle_stroke = Polygon(outer_c, [inner_c])

canvas = Scene(resolution=(1000, 1000), camera=campixel!, backgroundcolor="#20262e")

circle = scatter!(canvas, origin, marker=Circle, markersize=radius*2, color="#d8e9e6")
dots_inside = Vector{Scatter{Tuple{Vector{Point{2, Float32}}}}}()
dots_outside = Vector{Scatter{Tuple{Vector{Point{2, Float32}}}}}()

for i in 1:sample_space
    point = random_point(x_range, y_range)
    if distance(point, origin) <= radius
        dot = scatter!(canvas, point, marker=Circle, markersize=5, color="#37867e")
        push!(dots_inside, dot)
    else
        dot = scatter!(canvas, point, marker=Circle, markersize=5, color="#283d53")
        push!(dots_outside, dot)
    end
    yield()
    # sleep(0.05)
    in_total_ratio = length(dots_inside)/(length(dots_inside) + length(dots_outside))
    approximation = 4*in_total_ratio
    clear_line()
    print(approximation)
end


function random_point(x_range::Tuple, y_range::Tuple)
    return (map2(rand(), (0, 1), x_range), map2(rand(), (0, 1), y_range))
end
function distance(point1, point2)
    dist = 0.0     
    if length(point1) > length(point2)
        point2 = [point2...,]
        push!(point2, zeros(length(point1)-length(point2))...)
    elseif length(point2) > length(point1)
        point1 = [point1...,]
        push!(point1, zeros(length(point2)-length(point1))...)
    end
    for i in eachindex(point1)
        dist += (point1[i] - point2[i])*(point1[i] - point2[i])
    end
    dist = sqrt(dist)
    return dist
end

