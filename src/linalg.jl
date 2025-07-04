"""
    mix(a::T, b::T, t::T) where {T<:Real}

Interpolate linearly between `a` and `b` in the parameter
space `t ∈ [0,1]`.
"""
@inline mix(a::T, b::T, t::T) where {T<:Real} = a * (1 - t) + b * t