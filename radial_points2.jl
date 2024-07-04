using Plots
using LinearAlgebra
plotly()


#Generating Points
function generate_points_on_sphere(n::Int)
    theta = 2π * rand(n)
    phi = 2π * rand(n)
    # x = cos.(theta) .* sin.(phi)
    # y = sin.(theta) .* sin.(phi)
    # z = cos.(phi)
    return [p2c(1.0, theta[i], phi[i]) for i in 1:n]
end


#Visualisation - Plotting points with a Unitsphere
function plot_points(points::Vector{<:Union{<:Vector{<:Number}, <:Tuple{<:Number, <:Number, <:Number}}}=generate_points_on_sphere(rand(1:10)))
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = cos.(u) * sin.(v)'
    y = sin.(u) * sin.(v)'
    z = ones(n) * cos.(v)'

    plotly()
    surface(x, y, z, alpha=0.7, color=:blue, label="Sphere")

    scatter3d!([Tuple(i) for i in points], color=:red, markersize=5, label="Points on Sphere")
    scatter!()
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    
    display(plot!())
end


#Coords Conversion
function c2p(x::Float64, y::Float64, z::Float64)
    r = sqrt(x^2 + y^2 + z^2)
    θ = atan(y, x)
    φ = acos(z / r)
    return [r, θ, φ]
end

function p2c(r::Float64, θ::Float64, φ::Float64)
    x = r * cos(θ) * sin(φ)
    y = r * sin(θ) * sin(φ)
    z = r * cos(φ)
    return [x, y, z]
end