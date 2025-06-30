export Translation, Rotation, Onion, Ring, Scaling, Elongation
export Revolution, Extrusion
export BooleanNegative, ¬


struct Translation{Dim,T,S} <: Transformation{Dim,T}
    child::S
    q::SVector{Dim,T}
    function Translation(shape::S; dx::T = 0.0, dy::T = 0.0) where {T,S<:SDF{2,T}}
        new{2,T,S}(shape, SVector(dx, dy))
    end
    function Translation(shape::S; dx::T = 0.0, dy::T = 0.0, dz::T = 0.0) where {T,S<:SDF{3,T}}
        new{3,T,S}(shape, SVector(dx, dy, dz))
    end
end

function (op::Translation{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    op.child(p .- op.q)
end

AbstractTrees.printnode(io::IO, node::Translation{2,T}) where {T} = print(io, "$(typeof(node).name.wrapper) (dx = $(node.q[1]), dy = $(node.q[2]))")
AbstractTrees.printnode(io::IO, node::Translation{3,T}) where {T} = print(io, "$(typeof(node).name.wrapper) (dx = $(node.q[1]), dy = $(node.q[2]), dz = $(node.q[3]))")



struct Rotation{Dim,T,S,U<:NamedTuple,M<:SMatrix{Dim,Dim,T}} <: Transformation{Dim,T}
    child::S
    angles::U
    R::M
    q::SVector{Dim,T}
    function Rotation(op::S, angles::U, R::M, q::SVector{Dim,T}) where {Dim,T,S<:SDF{Dim,T},U<:NamedTuple,M<:SMatrix{Dim,Dim,T}}
        new{Dim,T,S,U,M}(op, angles, R, q)
    end
end

function Rotation(shape::S; θ::T = 0.0, dx::T = 0.0, dy::T = 0.0) where {T,S<:SDF{2,T}}
    R = SMatrix{2,2,T}(cos(θ), -sin(θ), sin(θ), cos(θ))
    Rotation(shape, (; θ), R, SVector(dx, dy))
end

function Rotation(shape::S; ϕ::T = 0.0, θ::T = 0.0, ψ::T = 0.0, dx::T = 0.0, dy::T = 0.0, dz::T = 0.0) where {T,S<:SDF{3,T}}
    R = SMatrix{3,3,T}(RotX(ϕ) * RotY(θ) * RotZ(ψ))
    Rotation(shape, (; ψ, θ, ϕ), R, SVector(dx, dy, dz))
end

function (op::Rotation{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    op.child(op.R * (p - op.q) + op.q)
end

rr2d(θ::T) where {T<:Real} = round(rad2deg(θ); digits=1)
AbstractTrees.printnode(io::IO, node::Rotation{2,T}) where {T} = print(io, "$(typeof(node).name.wrapper) (θ = $(rr2d(node.angles.θ))°, dx = $(node.q[1]), dy = $(node.q[2]))")
AbstractTrees.printnode(io::IO, node::Rotation{3,T}) where {T} = print(io, "$(typeof(node).name.wrapper) (ϕ = $(rr2d(node.angles.ϕ))°, θ = $(rr2d(node.angles.θ))°, ψ = $(rr2d(node.angles.ψ))°, dx = $(node.q[1]), dy = $(node.q[2]), dz = $(node.q[3]))")


struct Onion{Dim,T,S} <: Transformation{Dim,T}
    child::S
    r::T
    function Onion(op::S; r::T = 0.0) where {Dim,T,S<:SDF{Dim,T}}
        new{Dim,T,S}(op, r)
    end
end

function (op::Onion{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    abs(op.child(p)) - op.r
end

AbstractTrees.printnode(io::IO, node::Onion{Dim,T}) where {Dim,T} = print(io, "$(typeof(node).name.wrapper) (r = $(node.r))")


struct Ring{Dim,T,S} <: Transformation{Dim,T}
    child::S
    r::T
    function Ring(op::S; r::T = 0.0) where {Dim,T,S<:SDF{Dim,T}}
        new{Dim,T,S}(op, r)
    end
end

function (op::Ring{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    op.child(p) - op.r
end

AbstractTrees.printnode(io::IO, node::Ring{Dim,T}) where {Dim,T} = print(io, "$(typeof(node).name.wrapper) (r = $(node.r))")


struct BooleanNegative{Dim,T,S} <: Transformation{Dim,T}
    child::S
    function BooleanNegative(op::S) where {Dim,T,S<:SDF{Dim,T}}
        new{Dim,T,S}(op)
    end
end

function (op::BooleanNegative{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    -op.child(p)
end

function ¬(shape::S) where {Dim,T,S<:SDF{Dim,T}}
    BooleanNegative(shape)
end

AbstractTrees.printnode(io::IO, node::BooleanNegative{Dim,T}) where {Dim,T} = print(io, "$(typeof(node).name.wrapper)")


struct Scaling{Dim,T,S} <: Transformation{Dim,T}
    child::S
    s::T
    function Scaling(op::S; s::T = 1.0) where {Dim,T,S<:SDF{Dim,T}}
        new{Dim,T,S}(op, s)
    end
end

function (op::Scaling{Dim,T})(p::SVector{Dim,S}) where {Dim,T<:Real,S<:Real}
    op.child(p / op.s) * op.s
end

AbstractTrees.printnode(io::IO, node::Scaling{Dim,T}) where {Dim,T} = print(io, "$(typeof(node).name.wrapper) (s = $(node.s))")


struct Elongation{Dim,T,S} <: Transformation{Dim,T}
    child::S
    h::SVector{Dim,T}
    function Elongation(op::S; dx::T = 0.0, dy::T = 0.0, dz::T = 0.0) where {T,S<:SDF{3,T}}
        new{3,T,S}(op, SVector(dx, dy, dz))
    end
end

function (op::Elongation{3,T})(p::SVector{3,S}) where {T<:Real,S<:Real}
    q = abs.(p) - op.h
    op.child(max.(q, 0.0)) + min.(max(q[1], max(q[2], q[3])), 0.0)
end

AbstractTrees.printnode(io::IO, node::Elongation{3,T}) where {T} = print(io, "$(typeof(node).name.wrapper) (dx = $(node.h[1]), dy = $(node.h[2]), dz = $(node.h[3]))")


struct Revolution{T,S} <: Transformation{3,T}
    child::S
    o::T
    function Revolution(op::S; o::T = 1.0) where {T,S<:SDF{2,T}}
        @assert o ≥ 0
        new{T,S}(op, o)
    end
end

function (op::Revolution{T})(p::SVector{3,S}) where {T<:Real,S<:Real}
    q = SVector(sqrt(p[1]^2 + p[3]^2) - op.o, p[2])
    op.child(q)
end

AbstractTrees.printnode(io::IO, node::Revolution{T}) where {T} = print(io, "$(typeof(node).name.wrapper) (o = $(node.o))")


struct Extrusion{T,S} <: Transformation{3,T}
    child::S
    h::T
    function Extrusion(op::S; h::T = 1.0) where {T,S<:SDF{2,T}}
        @assert h > 0
        new{T,S}(op, h)
    end
end

function (op::Extrusion{T})(p::SVector{3,S}) where {T<:Real,S<:Real}
    d = op.child(SVector(p[1], p[2]))
    w = SVector(d, abs(p[3]) - op.h)
    min(max(w[1], w[2]), 0.0) + norm(max.(w, 0.0))
end

AbstractTrees.printnode(io::IO, node::Extrusion{T}) where {T} = print(io, "$(typeof(node).name.wrapper) (h = $(node.h))")
