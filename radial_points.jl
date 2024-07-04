using Plots
using LinearAlgebra

#Generating Points
function generate_points_on_sphere(n::Int)
    theta = 2π * rand(n)
    phi = acos.(2 * rand(n) .- 1)
    x = cos.(theta) .* sin.(phi)
    y = sin.(theta) .* sin.(phi)
    z = cos.(phi)
    return hcat(x, y, z)
end


#Visualize Points with a sphere
function myplot(points::Matrix{Float64}=generate_points_on_sphere(rand(1:10)))
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = cos.(u) * sin.(v)'
    y = sin.(u) * sin.(v)'
    z = ones(n) * cos.(v)'

    plotly()
    surface(x, y, z, alpha=0.7, color=:blue, label="Sphere")

    scatter3d!(points[:, 1], points[:, 2], points[:, 3], color=:red, markersize=5, label="Points on Sphere")
    
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    
    display(plot!())
end

# Example usage
# points = generate_points_on_sphere(2)
# myplot(points)


#------------------------------------------------------------


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


#Calculating force
function magnitude_sq(vect)
    return sum(i*i for i in vect)
end

function calculate_repulsion_force!(p1::Vector{Float64}, p2::Vector{Float64}, force_factor::Float64=0.01)
    repulsive_force = (p2 .- p1).*(force_factor/max(magnitude_sq(p2-p1), 1e-6)) #krr̂/d^2    max(magnitude_sq(p2-p1), 1e-6) is to avoid division by zero
    return repulsive_force
end

function calculate_forces(points::Matrix{Float64}, point_index::Int, force_factor::Float64=0.01)
    n = size(points, 1)
    net_force = zeros(3)
    for i in 1:n
        if i != point_index
            net_force +=  calculate_repulsion_force!(points[point_index, :], points[i, :], force_factor)
        end
    end
    return net_force
end

#------------------
# function calculate_repulsion_force(points::Matrix{Float64}, point_index::Int, force_factor::Float64)
#     n = size(points, 1)
#     repulsion_force = zeros(3)
#     for i in 1:n
#         if i != point_index
#             r = points[i, :] - points[point_index, :]
#             r_norm = max(norm(r), 1e-6)  # Avoid division by zero or extremely small values
#             force = force_factor * r ./ r_norm^3  # Inverse cube law for repulsion
#             repulsion_force += force
#         end
#     end
#     return repulsion_force
# end

function update_radial_position_of_point!(points::Matrix{Float64}, point_index::Int, force_factor::Float64)
    point_polar = c2p(points[point_index, :]...)
    net_force_polar = c2p(calculate_forces(points, point_index, force_factor)...)
    for i in 2:3
        point_polar[i] = net_force_polar[i]
    end
    point = p2c(point_polar...)
    for j in 1:3
        points[point_index, j] = point[j]
    end
end



# function update_point_position_radial(points::Matrix{Float64}, point_index::Int, force_factor::Float64)
#     # Convert Cartesian coordinates to radial coordinates
#     r_old = norm(points[point_index, :])
#     alpha_old = atan(points[point_index, 2], points[point_index, 1])
#     phi_old = acos(points[point_index, 3] / r_old)
    
#     repulsion_force = calculate_repulsion_force(points, point_index, force_factor)
    
#     # Convert force vector to polar coordinates
#     r_force = norm(repulsion_force)
#     alpha_force = atan(repulsion_force[2], repulsion_force[1])
#     phi_force = acos(repulsion_force[3] / r_force)
    
#     # Update radial coordinates of the point
#     r_new = r_old + r_force
#     alpha_new = alpha_old + alpha_force * r_force
#     phi_new = phi_old + phi_force * r_force
    
#     # Convert radial coordinates back to Cartesian coordinates
#     points[point_index, 1] = r_new * cos(alpha_new) * sin(phi_new)
#     points[point_index, 2] = r_new * sin(alpha_new) * sin(phi_new)
#     points[point_index, 3] = r_new * cos(phi_new)
# end


function simulate_points_on_sphere_radial(n::Int, iterations::Int, force_factor::Float64=0.01)
    points = generate_points_on_sphere(n)
    for _ in 1:iterations
        myplot(points)
        yield()
        for i in 1:n
            update_radial_position_of_point!(points, i, force_factor)
        end
    end
    return points
end

# Example usage
n = 2
iterations = 100
force_factor = 0.1
points_final = simulate_points_on_sphere_radial(n, iterations, force_factor)

myplot(points_final)

function update(
    p1 = [1.0 0 0],
    p2 = [1 1 1]./sqrt(3),
    force_factor = 0.01,
    iterations = 100
    )
    for i in 1:iterations
        points = [p1;p2]
        myplot(points)
        yield()
        f_on_1 = calculate_repulsion_force!(transpose(p2)[:], transpose(p1)[:])
        repulsive_force = (transpose(p1)[:] .- transpose(p2)[:]).*(force_factor/max(magnitude_sq(transpose(p1)[:]-transpose(p2)[:]), 1e-6)) #krr̂/d^2    max(magnitude_sq(p2-p1), 1e-6) is to avoid division by zero
        p1 = transpose(p2c(1.0, c2p(repulsive_force...)[2:3]...))[:]
    end
end

update()
repulsive_force = (transpose(p1)[:] .- transpose(p2)[:]).*(force_factor/max(magnitude_sq(transpose(p1)[:]-transpose(p2)[:]), 1e-6)) #krr̂/d^2    max(magnitude_sq(p2-p1), 1e-6) is
p1 = transpose(p2c(1.0, c2p(repulsive_force...)[2:3]...))
p1 = [1.0 0.0 0.0]
copy(p1)[:, :]






#-----------------------------------------------

#Visualisation - Plotting points with Unitsphere
function myplot(points::Vector{Vector{Float64}}=generate_points_on_sphere(rand(1:10)))
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = cos.(u) * sin.(v)'
    y = sin.(u) * sin.(v)'
    z = ones(n) * cos.(v)'

    plotly()
    surface(x, y, z, alpha=0.9, color="#283d53", label="Sphere")

    scatter3d!([Tuple(i) for i in points]..., color="#d8e9e6", markersize=5, label="Points on Sphere", showaxis = false, legend=false, colorbar=false)
    # scatter!()
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    
    display(plot!())
end

points = [[1,2,3], [4,5,6]]
myplot([[1.0,0.0,0.0]])
scatter3d!(
    (3,2,1)
)

myplot([1 2 3])
display(plot!())

function generate_points_on_sphere(n::Int)
    theta = 2π * rand(n)
    phi = 2π * rand(n)
    # x = cos.(theta) .* sin.(phi)
    # y = sin.(theta) .* sin.(phi)
    # z = cos.(phi)
    return [p2c(1.0, theta[i], phi[i]) for i in 1:n]
end
function plot_points(points::Vector{<:Vector{<:Number}}=generate_points_on_sphere(rand(1:10)))
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = cos.(u) * sin.(v)'
    y = sin.(u) * sin.(v)'
    z = ones(n) * cos.(v)'

    plotly()
    surface(x, y, z, alpha=0.9, color="#283d53", label="Sphere")

    scatter3d!([Tuple(i) for i in points], color="#37867e", markersize=100/2, label="Points on Sphere", marker=:Circle)
    scatter!()
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    
    display(plot!())
end
plot_points([(0,0,0)])





using Plots
gr()
function circle(x, y, r=1; n=30)
    θ = 0:360÷n:360
    Plots.Shape(r*sind.(θ) .+ x, r*cosd.(θ) .+ y)
end

function move_circles!(circles; Δ=0.01)
    for c in circles
        dx = Δ*(2rand() - 1)
        dy = Δ*(2rand() - 1)
        c.x .+= dx
        c.y .+= dy
    end
    nothing
end

nframes = 100
ncircles = 1000

circles = circle.([i*rand(ncircles) for i in (1, 1, 0.01)]...)

plot_kwargs = (aspect_ratio=:equal, fontfamily="Helvetica", legend=false, line=nothing,
    color=:black, grid=false, xlim=(0,1), ylim=(0,1), axis = false, showaxis = false, colorbar=false)

anim = @animate for _ in 1:nframes
    move_circles!(circles)
    plot(circles; plot_kwargs...)
end
gif(anim, "anim.gif")




function plot_my_points(points::Vector{<:Vector{<:Number}}=generate_points_on_sphere(rand(1:10)))
    plotly()
    # n = 100
    # u = range(-π, π; length = n)
    # v = range(0, π; length = n)
    # x = cos.(u) * sin.(v)'
    # y = sin.(u) * sin.(v)'
    # z = ones(n) * cos.(v)'

    # surface(x, y, z, alpha=0.9, color="#283d53", label="Sphere")

    scatter3d!([Tuple(i) for i in points], color="#d8e9e6", markersize=5, label="Points on Sphere", markerstrokecolor="#283d53")
    scatter!()
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    
    display(plot!())
end
function plot_sphere(radius=1)
    plotly()
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = radius * cos.(u) * sin.(v)'
    y = radius * sin.(u) * sin.(v)'
    z = radius * ones(n) * cos.(v)'

    surface!(x, y, z, alpha=0.9, color="#283d53", label="Sphere")
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    display(plot!())
end

scatter3d()
plot_sphere(2)
plot_my_points()
plot3d()






#_________________________________________________


using Plots
using LinearAlgebra
plotly()


#Generating Points
function generate_points_on_sphere(n::Int, radius=1)
    theta = 2π * rand(n)
    phi = 2π * rand(n)
    # x = cos.(theta) .* sin.(phi)
    # y = sin.(theta) .* sin.(phi)
    # z = cos.(phi)
    return [p2c(radius, theta[i], phi[i]) for i in 1:n]
end


#Visualisation - Plotting points with Unitsphere
function plot_points!(points::Vector{<:Vector{<:Number}}=generate_points_on_sphere(rand(1:10)))
    plotly()
    scatter3d!([Tuple(i) for i in points], color="#d8e9e6", markersize=5, label="Points on Sphere", markerstrokecolor="#283d53")
    scatter!()
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    
    display(plot!())
end
function plot_sphere!(radius=1)
    plotly()
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = radius * cos.(u) * sin.(v)'
    y = radius * sin.(u) * sin.(v)'
    z = radius * ones(n) * cos.(v)'

    surface!(x, y, z, alpha=0.9, color="#283d53", label="Sphere")
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    display(plot!())
end


#Coords Conversion
function c2p(x::Number, y::Number, z::Number)
    r = sqrt(x^2 + y^2 + z^2)
    θ = atan(y, x)
    φ = acos(z / r)
    return [r, θ, φ]
end

function p2c(r::Number, θ::Number, φ::Number)
    x = r * cos(θ) * sin(φ)
    y = r * sin(θ) * sin(φ)
    z = r * cos(φ)
    return [x, y, z]
end

#Example usage of Plotting
plot3d() #Create an empty plot, set attributes like axis, showaxis, ticks, legend, colorbar, etc if your want
plot_sphere!()
plot_points!([(1,2,3), (0,1,0)])


#----------------Mark1----------------------
using Plots
using LinearAlgebra
plotly()

#COMPUTATIONAL FUNCTIONS


#Generating Points
function generate_points_on_sphere1(n::Int, radius::Number=1)
    theta = 2π * rand(n)
    phi = 2π * rand(n)
    # x = cos.(theta) .* sin.(phi)
    # y = sin.(theta) .* sin.(phi)
    # z = cos.(phi)
    return [p2c(radius, theta[i], phi[i]) for i in 1:n]
end

#Coords Conversion
function c2p(x::Number, y::Number, z::Number)
    r = sqrt(x^2 + y^2 + z^2)
    θ = atan(y, x)
    φ = acos(z / r)
    return [r, θ, φ]
end

function p2c(r::Number, θ::Number, φ::Number)
    x = r * cos(θ) * sin(φ)
    y = r * sin(θ) * sin(φ)
    z = r * cos(φ)
    return [x, y, z]
end

#--Maximizing istance between points--

#Calculating force
function magnitude_sq(vect::Vector{<:Number})
    return sum(i*i for i in vect)
end

function force_on_1_d2_2(
    p1::Vector{<:Number}, 
    p2::Vector{<:Number}, 
    force_factor::Number
    )
    return (p1 .- p2).*(force_factor/max(magnitude_sq(p1-p2), 1e-6)) #krr̂/d^2    max(magnitude_sq(p2-p1), 1e-6) is to avoid division by zero
end

function calculate_net_force_on_point(
    points::Vector{<:Vector{<:Number}}, 
    point_index::Int, 
    force_factor::Number
    )
    net_force = zeros(3)
    for i in 1:length(points)
        if i != point_index
            net_force += force_on_1_d2_2(points[point_index], points[i], force_factor)
        end
    end
    return net_force
end

function apply_net_force!(
    points::Vector{<:Vector{<:Number}}, 
    point_index::Int,
    net_force::Vector{<:Number}, 
    radius::Number
    )
    points[point_index] = p2c(radius, c2p((points[point_index] .+ net_force)...)[2:3]...)
end

function update_all_points!(
    points::Vector{<:Vector{<:Number}},
    force_factor::Number,
    radius::Number
    )
    net_forces = Vector{Vector{Number}}()
    for point_index in 1:length(points)
        push!(net_forces, calculate_net_force_on_point(points, point_index, force_factor))
    end
    for point_index in 1:length(points)
        apply_net_force!(points, point_index, net_forces[point_index], radius)
    end
end

function evolve_space!(
    points::Vector{<:Vector{<:Number}},
    iterations::Int,
    force_factor::Number, 
    radius::Number,
    show_evolution::Bool=true,
    min_time::Number=10
    )
    for _ in 1:iterations
        update_all_points!(points, force_factor, radius)
    end
    if show_evolution == true
        plot_points!(points)
        display(plot!())
        yield()
        sleep(min_time/iterations)

    end
end
        




#Visualisation - Plotting points with Unitsphere
function plot_points!(points::Vector{<:Vector{<:Number}}=generate_points_on_sphere(rand(1:10)))
    plotly()
    scatter3d!([Tuple(i) for i in points], color="#ff884b", markersize=5, label="Points on Sphere", markerstrokecolor="#283d53")
    scatter!()
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    
    display(plot!())
end
function plot_sphere!(radius=1)
    plotly()
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = radius * cos.(u) * sin.(v)'
    y = radius * sin.(u) * sin.(v)'
    z = radius * ones(n) * cos.(v)'

    surface!(x, y, z, alpha=0.9, color="#283d53", label="Sphere")
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
    title!("Points on a Sphere")
    display(plot!())
end




#Example usage of Plotting
plot3d() #Create an empty plot, set attributes like axis, showaxis, ticks, legend, colorbar, etc if your want
plot_sphere!()
plot_points!([(1,2,3), (0,1,0)])


#-------------------------------------
function main(number_of_points::Int=4, iterations::Int=100, force_factor::Number=0.01, show_evolution::Bool=true, min_time::Number=10, radius::Number=1)
    points = generate_points_on_sphere1(number_of_points)
    plot3d() #Create an Empty setting
    plot_sphere!(radius)
    plot_points!(points)
    # evolve_space!(points, iterations, force_factor, radius, show_evolution, min_time)
    return points
end


n = 5
points = main(n)


#___________
# plot3d()
# plot_sphere!()
# # points = [[1,0,0], 1/sqrt(3)*[1,1,1]]
# plot_points!(points)



f1=calculate_net_force_on_point(points, 1, 1)
forces = Vector{Vector{Number}}()
for i in 1:n
    push!(forces, calculate_net_force_on_point(points, i, 1))
end
forces
for i in 1:n
    apply_net_force!(points, i, forces[i], 1)
end
points
plot3d();plot_sphere!()
plot_points!(points)

#-----------


update_all_points!(points, 0.1, 0.1)

display(plot3d!())
main()