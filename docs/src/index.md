```@meta
CurrentModule = ImplicitGeometries
```
# ImplicitGeometries.jl

This package enables construction of implicit geometries by composition of
primitive shapes described by signed distance functions. It supports
evaluation of gradients and normals of such implicit representations.

To represent the construction tree structure, parts of the
[AbstractTrees.jl](https://juliacollections.github.io/AbstractTrees.jl/stable/)
interface are implemented.

The [articles](https://iquilezles.org/articles/) by Inigo Quilez are a great resource about implicit geometry representations via signed distance functions. This package uses ideas presented in these
articles.

```@docs
SDF
```

## Shapes

Types subtyping [`Shape`](@ref) serve as building blocks for construction of
more complex geometries. These are typically true signed distance functions, i.e. they
return the minimal Euclidean distance to the shape boundary.

The following primitive shapes are currently implemented:

- [`Rectangle`](@ref)
- [`Circle`](@ref)
- [`Box`](@ref)
- [`Sphere`](@ref)
- [`Cylinder`](@ref)
- [`QuadraticBezierSegment`](@ref)
- [`QuadraticBezier`](@ref)
- [`Polygon`](@ref)

```@docs
Shape
Rectangle
Rectangle(; w::T = 1.0, h::T = 1.0) where {T<:Real}
Circle
Circle(; r::T = 1.0) where {T<:Real}
Box
Box(; w::T = 1.0, h::T = 1.0, d::T = 1.0) where {T<:Real}
Sphere
Sphere(; r::T = 1.0) where {T<:Real}
Cylinder
Cylinder(; r::T = 1.0, h::T = 1.0) where {T<:Real}
QuadraticBezierSegment
QuadraticBezierSegment(; A::SVector{2,T}, B::SVector{2,T}, C::SVector{2,T}) where {T<:Real}
QuadraticBezier
QuadraticBezier(; A::SVector{2,T}, B::SVector{2,T}, C::SVector{2,T}) where {T<:Real}
Polygon
Polygon(; v::Vector{SVector{2,T}}) where {T<:Real}
```

## Operations

Types subtyping [`Operation`](@ref) are compositions of two or more signed distance functions.
Not all operations are described by a true signed distance function.

The following operations are currently implemented:

- [`BooleanUnion`](@ref), [`Base.:∪`](@ref)
- [`BooleanIntersection`](@ref), [`Base.:∩`](@ref)
- [`BooleanSubtraction`](@ref), [`Base.:-`](@ref)
- [`BooleanDifference`](@ref), [`Base.:\`](@ref)
- [`SmoothMinimum`](@ref)
- [`SmoothUnion`](@ref)
- [`SmoothIntersection`](@ref)
- [`SmoothSubtraction`](@ref)

```@docs
Operation
BooleanOperation
BooleanUnion
BooleanUnion(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
Base.:∪
BooleanIntersection
BooleanIntersection(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
Base.:∩
BooleanSubtraction
BooleanSubtraction(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
Base.:-
BooleanDifference
BooleanDifference(shape1::S1, shape2::S2) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
Base.:\
SmoothMinimum
SmoothMinimum(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
SmoothUnion
SmoothUnion(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
SmoothIntersection
SmoothIntersection(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
SmoothSubtraction
SmoothSubtraction(shape1::S1, shape2::S2; k::T = 0.1) where {Dim,T,S1<:SDF{Dim,T},S2<:SDF{Dim,T}}
```

## Transformations

Types subtyping [`Transformation`](@ref) operate on a single signed distance function. Most
transformations are described by a true signed distance function.

The following transformations are currently implemented:

- [`Translation`](@ref)
- [`Rotation`](@ref)
- [`Onion`](@ref)
- [`Ring`](@ref)
- [`Scaling`](@ref)
- [`Elongation`](@ref)
- [`Revolution`](@ref)
- [`Extrusion`](@ref)
- [`BooleanNegative`](@ref)

```@docs
Transformation
Translation
Translation(shape::S; dx::T = 0.0, dy::T = 0.0) where {T,S<:SDF{2,T}}
Rotation
Rotation(shape::S; θ::T = 0.0, dx::T = 0.0, dy::T = 0.0) where {T,S<:SDF{2,T}}
Onion
Onion(op::S; r::T = 0.0) where {Dim,T,S<:SDF{Dim,T}}
Ring
Ring(op::S; r::T = 0.0) where {Dim,T,S<:SDF{Dim,T}}
Scaling
Scaling(op::S; s::T = 1.0) where {Dim,T,S<:SDF{Dim,T}}
Elongation
Elongation(op::S; dx::T = 0.0, dy::T = 0.0, dz::T = 0.0) where {T,S<:SDF{3,T}}
Revolution
Revolution(op::S; o::T = 1.0) where {T,S<:SDF{2,T}}
Extrusion
Extrusion(op::S; h::T = 1.0) where {T,S<:SDF{2,T}}
BooleanNegative
BooleanNegative(op::S) where {Dim,T,S<:SDF{Dim,T}}
¬
```

## Gradients

`ImplicitGeometries.jl` supports evaluation of gradients of signed distance functions.
Currently, the gradients in two dimensions are approximated by second order finite differences
with a 4-point cross stencil. The gradients in three dimensions are approximated by first order
finite differences with a 4-point tetrahedron stencil. The [`Gradient`](@ref) is a functor similar
to [`SDF`](@ref). It can be evaluated a some position `p`.

```@docs
Gradient
Gradient(shape::S; h::T = 1e-4) where {Dim,T,S<:SDF{Dim,T}}
```

!!! tip "Automatic differentiation"

    [Automatic differentiation](https://en.wikipedia.org/wiki/Automatic_differentiation) can also be used to evaluate gradients of signed distance functions and, depending on the application,
    might also be preferable to the finite differencing used in [`Gradient`](@ref). In the following
    example we use [`Zygote.jl`](https://github.com/FluxML/Zygote.jl) to evaluate the gradient using
    automatic differentiation.

    ```julia-repl
    julia> using Zygote, StaticArrays

    julia> geometry = Ring(Rectangle() - Circle(; r=0.25); r=0.1);

    julia> print_tree(geometry)
    Ring (r = 0.1)
    └─ BooleanSubtraction
        ├─ Rectangle (w = 1.0, h = 1.0)
        └─ Circle (r = 0.25)

    julia> Zygote.gradient(geometry, p)[1]
    2-element SVector{2, Float64} with indices SOneTo(2):
    0.7071067811865476
    0.7071067811865476

    julia> Gradient(geometry)(p)
    2-element SVector{2, Float64} with indices SOneTo(2):
    0.7071067811870169
    0.7071067811881271
    ```

    **Note:** [`ForwardDiff.jl`](https://github.com/JuliaDiff/ForwardDiff.jl) seems to struggle with
    some signed distance functions.

## Normals

A normal on the boundary of a region described by a constant levelset of a signed distance function
is nothing more than the normalized [`Gradient`](@ref) evaluated on that boundary.
The same approximations as in [`Gradient`](@ref) are used here.

```@docs
Normal
Normal(shape::S; h::T = 1e-4) where {Dim,T,S<:SDF{Dim,T}}
```