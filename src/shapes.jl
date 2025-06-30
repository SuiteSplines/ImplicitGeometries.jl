export Rectangle, Circle
export Sphere, Box, Cylinder

# two dimensional shapes

struct Rectangle{T} <: Shape{2,T}
    b::SVector{2,T}
    function Rectangle(; w::T = 1.0, h::T = 1.0) where {T<:Real}
        @assert w > 0
        @assert h > 0
        new{T}(SVector(w/2, h/2))
    end
end

function (shape::Rectangle{T})(p::SVector{2,S}) where {T<:Real,S<:Real}
    d = (abs.(p) .- shape.b)
    norm(max.(d,0.0)) + min(max(d[1],d[2]), 0.0)
end

AbstractTrees.printnode(io::IO, node::Rectangle) = print(io, "$(typeof(node).name.wrapper) (w = $(2*node.b[1]), h = $(2*node.b[2]))")


struct Circle{T} <: Shape{2,T}
    r::T
    function Circle(; r::T = 1.0) where {T<:Real}
        @assert r > 0
        new{T}(r)
    end
end

function (shape::Circle{T})(p::SVector{2,S}) where {T<:Real,S<:Real}
    norm(p) - shape.r
end

AbstractTrees.printnode(io::IO, node::Circle) = print(io, "$(typeof(node).name.wrapper) (r = $(node.r))")



# three dimensional shapes

struct Sphere{T} <: Shape{3,T}
    r::T
    function Sphere(; r::T = 1.0) where {T<:Real}
        @assert r > 0
        new{T}(r)
    end
end

function (shape::Sphere{T})(p::SVector{3,S}) where {T<:Real,S<:Real}
    norm(p) - shape.r
end

AbstractTrees.printnode(io::IO, node::Sphere) = print(io, "$(typeof(node).name.wrapper) (r = $(node.r))")


struct Box{T} <: Shape{3,T}
    b::SVector{3,T}
    function Box(; w::T = 1.0, h::T = 1.0, d::T = 1.0) where {T<:Real}
        @assert w > 0
        @assert h > 0
        @assert d > 0
        new{T}(SVector(w/2, h/2, d/2))
    end
end

function (shape::Box{T})(p::SVector{3,S}) where {T<:Real,S<:Real}
    q = abs.(p) - shape.b
    norm(max.(q, 0.0)) + min(max(q[1], max(q[2], q[3])), 0.0)
end

AbstractTrees.printnode(io::IO, node::Box) = print(io, "$(typeof(node).name.wrapper) (w = $(2*node.b[1]), h = $(2*node.b[2]), d = $(2*node.b[3]))")

struct Cylinder{T} <: Shape{3,T}
    b::SVector{2,T}
    function Cylinder(; r::T = 1.0, h::T = 1.0) where {T<:Real}
        @assert r > 0
        @assert h > 0
        new{T}(SVector(r, h))
    end
end

function (shape::Cylinder{T})(p::SVector{3,S}) where {T<:Real,S<:Real}
    d = abs.(SVector(norm(SVector(p[1], p[3])), p[2])) - shape.b
    min(max(d[1], d[2]), 0.0) + norm(max.(d, 0.0))
end

AbstractTrees.printnode(io::IO, node::Cylinder) = print(io, "$(typeof(node).name.wrapper) (r = $(node.b[1]), h = $(node.b[2]))")


## AD ext poc
#maxcomp(v) = maximum(v)
#msign(v) = map(x -> x <= 0 ? -1.0 : 1.0, v)
#step(edge, x) = map((e, val) -> val < e ? 0.0 : 1.0, edge, x)
#function box_gradient(p::SVector{3,S}, rad::SVector{3,T}) where {S<:Real,T<:Real}
#    d = abs.(p) - rad
#    s = msign(p)
#    g = maxcomp(d)
#    
#    if g > 0.0
#        return s .* normalize(max.(d, 0.0))
#    else
#        d_yzx = SVector(d[2], d[3], d[1]) 
#        d_zxy = SVector(d[3], d[1], d[2]) 
#        d_xyz = d
#        return s .* (step(d_yzx, d_xyz) .* step(d_zxy, d_xyz))
#    end
#end
###
#
#function (shape::Box{T})(p::SVector{3, ForwardDiff.Dual{S,V,P}}) where {T<:Real, S, V, P}
#    vals = ForwardDiff.value.(p)
#    fval = shape(vals)
#    grad = box_gradient(vals, shape.b)
#    partials = sum(grad[i] * ForwardDiff.partials(p[i]) for i in 1:3)
#    return ForwardDiff.Dual{S}(fval, partials)
#end




