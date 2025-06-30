export SDF, Shape, Operation, Transformation

abstract type SDF{Dim,T} end

abstract type Shape{Dim,T} <: SDF{Dim,T} end
abstract type Operation{Dim,T} <: SDF{Dim,T} end
abstract type Transformation{Dim,T} <: SDF{Dim,T} end

function Base.show(io::IO, node::SDF{Dim,T}) where {Dim,T}
    print(io, "$(typeof(node).name.wrapper){$Dim, $T}")
end

AbstractTrees.children(node::SDF) = SDF[]
AbstractTrees.children(node::Transformation) = [node.child]
AbstractTrees.children(node::Operation) = node.children
