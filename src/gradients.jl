export Normal, Gradient

"""
    struct Normal{Dim,T,S<:SDF{Dim,T}}

Vector field of normals of a signed distance function.
"""
struct Normal{Dim,T,S<:SDF{Dim,T}}
    shape::S
    h::T
    @doc """
        Normal(shape::S; h::T = 1e-4) where {Dim,T,S<:SDF{Dim,T}}

    Initialize [`Normal`](@ref) for a signed distance function `shape`.
    The parameter `h` controls the width of the finite difference stencil.
    """
    function Normal(shape::S; h::T = 1e-4) where {Dim,T,S<:SDF{Dim,T}}
        @assert h > eps(T)
        new{Dim,T,S}(shape, h)
    end
end

"""
    (op::Normal{2,T})(p::SVector{2,T}) where {T<:Real}
    (op::Normal{3,T})(p::SVector{3,T}) where {T<:Real}

Evaluate normals at point `p`.
"""
function (op::Normal{3,T})(p::SVector{3,T}) where {T<:Real}
    n = zero(SVector{3, T})
    n += SVector{3,T}( 1.0, -1.0, -1.0) * op.shape(p + op.h * SVector{3,T}( 1.0, -1.0, -1.0))
    n += SVector{3,T}(-1.0, -1.0,  1.0) * op.shape(p + op.h * SVector{3,T}(-1.0, -1.0,  1.0))
    n += SVector{3,T}(-1.0,  1.0, -1.0) * op.shape(p + op.h * SVector{3,T}(-1.0,  1.0, -1.0))
    n += SVector{3,T}( 1.0,  1.0,  1.0) * op.shape(p + op.h * SVector{3,T}( 1.0,  1.0,  1.0))
    return normalize(n)
end

function (op::Normal{2,T})(p::SVector{2,T}) where {T<:Real}
    n = zero(SVector{2, T})
    n += SVector{2,T}( 1.0, -1.0) * op.shape(p + op.h * SVector{2,T}( 1.0, -1.0))
    n += SVector{2,T}(-1.0, -1.0) * op.shape(p + op.h * SVector{2,T}(-1.0, -1.0))
    n += SVector{2,T}(-1.0,  1.0) * op.shape(p + op.h * SVector{2,T}(-1.0,  1.0))
    n += SVector{2,T}( 1.0,  1.0) * op.shape(p + op.h * SVector{2,T}( 1.0,  1.0))
    return normalize(n)
end

function Base.show(io::IO, op::Normal{Dim,T}) where {Dim,T}
    print(io, "$(typeof(op).name.wrapper){$Dim, $T}")
end

"""
    struct Gradient{Dim,T,S<:SDF{Dim,T}}

Gradient of a signed distance function.
"""
struct Gradient{Dim,T,S<:SDF{Dim,T}}
    shape::S
    h::T
    @doc """
        Gradient(shape::S; h::T = 1e-4) where {Dim,T,S<:SDF{Dim,T}}

    Initialize [`Gradient`](@ref) for a signed distance function `shape`.
    The parameter `h` controls the width of the finite difference stencil.
    """
    function Gradient(shape::S; h::T = 1e-4) where {Dim,T,S<:SDF{Dim,T}}
        @assert h > eps(T)
        new{Dim,T,S}(shape, h)
    end
end

"""
    (op::Normal{2,T})(p::SVector{2,T}) where {T<:Real}
    (op::Normal{3,T})(p::SVector{3,T}) where {T<:Real}

Evaluate gradient at point `p`.

Gradients are approximated by finite differences of order one
in three dimensions and order two in two dimensions. 
"""
function (op::Gradient{3,T})(p::SVector{3,T}) where {T<:Real}
    n = zero(SVector{3, T})
    n += SVector{3,T}( 1.0, -1.0, -1.0) * op.shape(p + op.h * SVector{3,T}( 1.0, -1.0, -1.0))
    n += SVector{3,T}(-1.0, -1.0,  1.0) * op.shape(p + op.h * SVector{3,T}(-1.0, -1.0,  1.0))
    n += SVector{3,T}(-1.0,  1.0, -1.0) * op.shape(p + op.h * SVector{3,T}(-1.0,  1.0, -1.0))
    n += SVector{3,T}( 1.0,  1.0,  1.0) * op.shape(p + op.h * SVector{3,T}( 1.0,  1.0,  1.0))
    return (1 / (4 * op.h)) * n
end

function (op::Gradient{2,T})(p::SVector{2,T}) where {T<:Real}
    n = zero(SVector{2, T})
    n += SVector{2,T}( 1.0, -1.0) * op.shape(p + op.h * SVector{2,T}( 1.0, -1.0))
    n += SVector{2,T}(-1.0, -1.0) * op.shape(p + op.h * SVector{2,T}(-1.0, -1.0))
    n += SVector{2,T}(-1.0,  1.0) * op.shape(p + op.h * SVector{2,T}(-1.0,  1.0))
    n += SVector{2,T}( 1.0,  1.0) * op.shape(p + op.h * SVector{2,T}( 1.0,  1.0))
    return (1 / (4 * op.h)) * n
end

function Base.show(io::IO, op::Gradient{Dim,T}) where {Dim,T}
    print(io, "$(typeof(op).name.wrapper){$Dim, $T}")
end