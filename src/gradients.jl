export Normal, Gradient

struct Normal{Dim,T,S<:SDF{Dim,T}}
    shape::S
    h::T
    function Normal(shape::S; h = 1e-4) where {Dim,T,S<:SDF{Dim,T}}
        @assert h > eps(T)
        new{Dim,T,S}(shape, h)
    end
end

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

struct Gradient{Dim,T,S<:SDF{Dim,T}}
    shape::S
    h::T
    function Gradient(shape::S; h = 1e-4) where {Dim,T,S<:SDF{Dim,T}}
        @assert h > eps(T)
        new{Dim,T,S}(shape, h)
    end
end

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