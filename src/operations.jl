export BooleanUnion, BooleanIntersection, BooleanSubtraction, BooleanDifference
export SmoothMinimum, SmoothUnion, SmoothIntersection, SmoothSubtraction

abstract type BooleanOperation{Dim,T} <: Operation{Dim,T} end

AbstractTrees.printnode(io::IO, node::BooleanOperation{Dim,T}) where {Dim,T} = print(io, "$(typeof(node).name.wrapper)")


struct BooleanUnion{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    function BooleanUnion(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        new{Dim,T,S1,S2}((shape1, shape2))
    end
end

function Base.:∪(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
    BooleanUnion(shape1, shape2)
end

function (shape::BooleanUnion{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    min(shape.children[1](p), shape.children[2](p))
end


struct BooleanIntersection{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    function BooleanIntersection(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        new{Dim,T,S1,S2}((shape1, shape2))
    end
end

function Base.:∩(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
    BooleanIntersection(shape1, shape2)
end

function (shape::BooleanIntersection{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    max(shape.children[1](p), shape.children[2](p))
end



struct BooleanSubtraction{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    function BooleanSubtraction(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        new{Dim,T,S1,S2}((shape1, shape2))
    end
end

function Base.:-(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
    BooleanSubtraction(shape1, shape2)
end

function (shape::BooleanSubtraction{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    max(shape.children[1](p), -shape.children[2](p))
end

struct BooleanDifference{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    function BooleanDifference(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        new{Dim,T,S1,S2}((shape1, shape2))
    end
end

function Base.:\(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
    BooleanDifference(shape1, shape2)
end

function (shape::BooleanDifference{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    a = shape.children[1](p)
    b = shape.children[2](p)
    max(min(a, b), -max(a, b))
end


struct SmoothMinimum{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    k::T
    function SmoothMinimum(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        @assert k > 0
        new{Dim,T,S1,S2}((shape1, shape2), k)
    end
end

function (shape::SmoothMinimum{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    a = shape.children[1](p)
    b = shape.children[2](p)
    r = exp2(-a/shape.k) + exp2(-b/shape.k);
    -shape.k*log2(r)
end


struct SmoothUnion{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    k::T
    function SmoothUnion(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        @assert k > 0
        new{Dim,T,S1,S2}((shape1, shape2), k)
    end
end

function (shape::SmoothUnion{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    a = shape.children[1](p)
    b = shape.children[2](p)
    h = clamp(0.5 + 0.5 * (b - a) / shape.k, 0.0, 1.0)
    mix(b, a, h) - shape.k * h * (1.0 - h)
end

struct SmoothSubtraction{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    k::T
    function SmoothSubtraction(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        @assert k > 0
        new{Dim,T,S1,S2}((shape1, shape2), k)
    end
end

function (shape::SmoothSubtraction{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    a = shape.children[2](p)
    b = shape.children[1](p)
    h = clamp(0.5 - 0.5 * (b + a) / shape.k, 0.0, 1.0)
    mix(b, -a, h) + shape.k * h * (1.0 - h)
end

struct SmoothIntersection{Dim,T,S1,S2} <: BooleanOperation{Dim,T}
    children::Tuple{S1,S2}
    k::T
    function SmoothIntersection(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
        @assert k > 0
        new{Dim,T,S1,S2}((shape1, shape2), k)
    end
end

function (shape::SmoothIntersection{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    a = shape.children[1](p)
    b = shape.children[2](p)
    h = clamp(0.5 - 0.5 * (b - a) / shape.k, 0.0, 1.0)
    mix(b, a, h) + shape.k * h * (1.0 - h)
end