export Rectangle, Circle, QuadraticBezier, QuadraticBezierSegment, Polygon
export Sphere, Box, Cylinder

"""
    struct Rectangle{T} <: Shape{2,T}

Signed distance function representing a rectangle.
"""
struct Rectangle{T} <: Shape{2,T}
    b::SVector{2,T}
    @doc """
        Rectangle(; w::T = 1.0, h::T = 1.0) where {T<:Real}

    Initialize [`Rectangle`](@ref) of width `w` and height `h`.
    """
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


"""
    struct Circle{T} <: Shape{2,T}

Signed distance function representing a circle.
"""
struct Circle{T} <: Shape{2,T}
    r::T
    @doc """
        Circle(; r::T = 1.0) where {T<:Real}

    Initialize [`Circle`](@ref) with radius `r`.
    """
    function Circle(; r::T = 1.0) where {T<:Real}
        @assert r > 0
        new{T}(r)
    end
end

function (shape::Circle{T})(p::SVector{2,S}) where {T<:Real,S<:Real}
    norm(p) - shape.r
end

AbstractTrees.printnode(io::IO, node::Circle) = print(io, "$(typeof(node).name.wrapper) (r = $(node.r))")



"""
    struct Sphere{T} <: Shape{3,T}

Signed distance function representing a sphere.
"""
struct Sphere{T} <: Shape{3,T}
    r::T
    @doc """
        Sphere(; r::T = 1.0) where {T<:Real}

    Initialize [`Sphere`](@ref) with radius `r`.
    """
    function Sphere(; r::T = 1.0) where {T<:Real}
        @assert r > 0
        new{T}(r)
    end
end

function (shape::Sphere{T})(p::SVector{3,S})::T where {T<:Real,S<:Real}
    norm(p) - shape.r
end

AbstractTrees.printnode(io::IO, node::Sphere) = print(io, "$(typeof(node).name.wrapper) (r = $(node.r))")


"""
    struct Box{T} <: Shape{3,T}

Signed distance function representing a box.
"""
struct Box{T} <: Shape{3,T}
    b::SVector{3,T}
    @doc """
        Box(; w::T = 1.0, h::T = 1.0, d::T = 1.0) where {T<:Real}

    Initialize [`Box`](@ref) of width `w`, height `h` and depth `d`.
    """
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

"""
    struct Cylinder{T} <: Shape{3,T}

Signed distance function representing a cylinder.
"""
struct Cylinder{T} <: Shape{3,T}
    b::SVector{2,T}
    @doc """
        Cylinder(; r::T = 1.0) where {T<:Real}

    Initialize [`Cylinder`](@ref) with radius `r` and height `h`.
    """
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

"""
    struct QuadraticBezierSegment{T} <: Shape{2,T}

Signed distance function defined by a quadratic Bezier segment.
"""
struct QuadraticBezierSegment{T} <: Shape{2,T}
    A::SVector{2,T}
    B::SVector{2,T}
    C::SVector{2,T}
    @doc """
        QuadraticBezierSegment(; A::SVector{2,T}, B::SVector{2,T}, C::SVector{2,T}) where {T<:Real}

    Initialize [`QuadraticBezierSegment`](@ref) with control points `A`, `B` and `C`.
    """
    function QuadraticBezierSegment(; A::SVector{2,T}, B::SVector{2,T}, C::SVector{2,T}) where {T<:Real}
        new{T}(A, B, C)
    end
end

function (shape::QuadraticBezierSegment{T})(p::SVector{2,S}) where {T<:Real,S<:Real}
    quadratic_bezier_signed_distance(p, shape.A, shape.B, shape.C)
end

AbstractTrees.printnode(io::IO, node::QuadraticBezierSegment) = print(io, "$(typeof(node).name.wrapper) (A = $(node.A), B = $(node.B), C = $(node.C))")

"""
    struct QuadraticBezier{T} <: Shape{2,T}

Signed distance function defined by a quadratic Bezier curve.
"""
struct QuadraticBezier{T,S<:QuadraticBezierSegment{T}} <: Shape{2,T}
    B::Vector{S}
    @doc """
        QuadraticBezier(; v::Vector{SVector{2,T}}) where {T<:Real}

    Initialize [`QuadraticBezier`](@ref). The control points for all Bezier segments
    are collected in the vector `v`. Typically, the first and the last control
    point will coincide. The orientation of each segment must be consistent.
    """
    function QuadraticBezier(; v::Vector{SVector{2,T}}) where {T<:Real}
        npts = length(v)
        @assert mod(npts, 3) == 0

        nseg = npts ÷ 3
        B = Vector{QuadraticBezierSegment{T}}(undef, nseg)
        for k = Base.OneTo(nseg)
            sind = 3(k-1) + 1
            B[k] = QuadraticBezierSegment(; A=v[sind], B=v[sind+1], C=v[sind+2])
        end
        new{T,QuadraticBezierSegment{T}}(B)
    end
end

function (shape::QuadraticBezier{T})(p::SVector{2,S}) where {T<:Real,S<:Real}
    d = Inf
    α = 0.0
    for b in shape.B
        d = min(d, abs(quadratic_bezier_signed_distance(p, b.A, b.B, b.C)))
        β = quadratic_bezier_winding_angle(p, b.A, b.B, b.C)
        (β == 0.0) && return 0.0 # point almost coincides with Bezier curve
        α += β
    end

    sign = round(Int, α / 2π) == 0 ? 1 : -1
    return sign * d
end

AbstractTrees.printnode(io::IO, node::QuadraticBezier) = print(io, "$(typeof(node).name.wrapper) (nseg = $(length(node.B)))")

"""
    struct Polygon{T} <: Shape{2,T}

Signed distance function representing a polygon.
"""
struct Polygon{T,S<:SVector{2,T}} <: Shape{2,T}
    v::Vector{S}
    @doc """
        Polygon(; v::Vector{SVector{2,T}}) where {T<:Real}

    Initialize [`Polygon`](@ref) through points `v`.
    """
    function Polygon(; v::Vector{SVector{2,T}}) where {T<:Real}
        new{T,SVector{2,T}}(v)
    end
end

function (shape::Polygon{T})(p::SVector{2,S}) where {T<:Real,S<:Real}
    num = length(shape.v)
    d = dot(p - shape.v[1], p - shape.v[1])
    s = 1.0

    for i in 1:num
        j = (i == 1) ? num : i - 1

        e = shape.v[j] - shape.v[i]
        w = p - shape.v[i]
        proj = clamp(dot(w, e) / dot(e, e), 0.0, 1.0)
        b = w - e * proj
        d = min(d, dot(b, b))

        cond1 = p[2] >= shape.v[i][2]
        cond2 = p[2] < shape.v[j][2]
        cond3 = (e[1] * w[2]) > (e[2] * w[1])

        if (cond1 && cond2 && cond3) || (!cond1 && !cond2 && !cond3)
            s = -s
        end
    end

    return s * sqrt(d)
end

AbstractTrees.printnode(io::IO, node::Polygon) = print(io, "$(typeof(node).name.wrapper) (npts = $(length(node.v)))")

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