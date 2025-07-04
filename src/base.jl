export SDF, Shape, Operation, Transformation

"""
    abstract type SDF{Dim,T}

A signed distance function (SDF) represents a geometry implicitly by giving the signed
distance from any point in space to the surface of the geometry.

For a region Ω in ℝⁿ with boundary ∂Ω, the signed distance function ϕ(x) returns:

- a negative value if x is inside Ω,
- zero if x lies on the boundary ∂Ω,
- a positive value if x is outside Ω.

Strictly speaking, the value of ϕ(x) is equal to the shortest (Euclidean) distance to the boundary ∂Ω,
with a sign that indicates whether the point is inside or outside the region Ω.

Note, that not all operations implemented in `ImplicitGeometries.jl` return a true signed distance
function. The (Euclidean) distance property is not always preserved.

All data types subtyping [`SDF`](@ref) are intended to act as functors. They are
callable with a single argument of type `SVector{Dim,T}` where `Dim` is the dimension
of the domain and `T` is the used number type.
"""
abstract type SDF{Dim,T} end

"""
    abstract type Shape{Dim,T} <: SDF{Dim,T}

Signed distance functions describing primitive shapes subtype this.
"""
abstract type Shape{Dim,T} <: SDF{Dim,T} end

"""
    abstract type Operation{Dim,T} <: SDF{Dim,T}

Operations on two or more signed distance functions subtype this.
"""
abstract type Operation{Dim,T} <: SDF{Dim,T} end

"""
    abstract type Transformation{Dim,T} <: SDF{Dim,T}

Transformations of a signed distance function subtype this.
"""
abstract type Transformation{Dim,T} <: SDF{Dim,T} end

function Base.show(io::IO, node::SDF{Dim,T}) where {Dim,T}
    print(io, "$(typeof(node).name.wrapper){$Dim, $T}")
end

AbstractTrees.children(node::SDF) = SDF[]
AbstractTrees.children(node::Transformation) = [node.child]
AbstractTrees.children(node::Operation) = node.children
