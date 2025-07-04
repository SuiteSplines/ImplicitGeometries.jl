function quadratic_bezier_midpoint_subdivide(A::SVector{Dim,T}, B::SVector{Dim,T}, C::SVector{Dim,T}) where {Dim,T<:Real}
    AB = (A + B) / 2
    BC = (B + C) / 2
    ABC = (AB + BC) / 2
    return (A, AB, ABC), (ABC, BC, C)
end

function quadratic_bezier_normalized_angle(v::SVector{2,T}, w::SVector{2,T}) where {T}
    θ = atan(w[2], w[1]) - atan(v[2], v[1])
    θ > π && return θ -= 2π
    θ <= -π && return θ += 2π
    return θ
end

function quadratic_bezier_winding_angle(p::SVector{2,T}, A::SVector{2,T}, B::SVector{2,T}, C::SVector{2,T}; tol::T=1e-5) where {T}
    # Adapted from "On computing a winding number for Bezier splines" (Bogusław Jackowski)
    # https://www.gust.org.pl/bachotex/2011-en/presentations/JackowskiB_3b_2011

    r0 = norm(p - A)
    r1 = norm(p - C)

    if min(r0, r1) < tol
        return 0.0 # p almost coincides with Bezier segment
    end

    v = norm(B - A) + norm(C - B)
    if v > r0 && v > r1
        (A1, B1, C1), (A2, B2, C2) = quadratic_bezier_midpoint_subdivide(A, B, C)
        return quadratic_bezier_winding_angle(p, A1, B1, C1; tol=tol) + quadratic_bezier_winding_angle(p, A2, B2, C2; tol=tol)
    else
        v0 = A - p
        v1 = C - p
        return quadratic_bezier_normalized_angle(v0, v1)
    end
end

function quadratic_bezier_winding_number(winding_angles::Vector{T}; tol::T=1e-8) where {T}
    any(α -> isapprox(α, 0.0; atol=tol), winding_angles) && return 0
    α = sum(winding_angles)
    n = round(Int, α / 2π)
end

function quadratic_bezier_signed_distance(p::SVector{2,T}, A::SVector{2,T}, B::SVector{2,T}, C::SVector{2,T}) where {T}
    # Adapted from "Signed Distance to a Quadratic Bezier Curve" (Adam Simmons (@adamjsimmons) 2025)
    # https://www.shadertoy.com/view/ltXSDB // License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

    # todo: cleanup, test and optimize...

    mid = B * 2.0
    if abs(mid[1] - A[1] - C[1]) < 1e-6 && abs(mid[2] - A[2] - C[2]) < 1e-6
        B += SVector(1e-4, 1e-4)
    end

    a = B - A
    b = A - B * 2.0 + C
    c = a * 2.0
    d = A - p

    bb = dot(b, b)
    k = SVector(3 * dot(a, b), 2 * dot(a, a) + dot(d, b), dot(d, a)) / bb
    a_, b_, c_ = k

    p_ = b_ - a_^2 / 3.0
    p3 = p_^3
    q = a_ * (2a_^2 - 9b_) / 27.0 + c_
    delta = q^2 + 4.0 * p3 / 27.0
    offset = -a_ / 3.0

    t = if delta >= 0.0
        z = sqrt(delta)
        x = ((SVector(z, -z) .- q) ./ 2.0)
        uv = sign.(x) .* abs.(x).^(1/3)
        SVector(offset + uv[1] + uv[2], 0.0, 0.0)
    else
        v = acos(-sqrt(-27.0 / p3) * q / 2.0) / 3.0
        m = cos(v)
        n = sin(v) * √3
        SVector(m + m, -n - m, n - m) .* sqrt(-p_ / 3.0) .+ offset
    end

    dis = typemax(Float64)
    for ti in clamp.(t, 0.0, 1.0)
        pos = A + (c + b * ti) * ti
        dis = min(dis, norm(pos - p))
    end

    ab = B - A
    ac = C - A
    ap = p - A
    det = ac[1] * ab[2] - ab[1] * ac[2]
    bary = SVector(ap[1] * ab[2] - ab[1] * ap[2], ac[1] * ap[2] - ap[1] * ac[2]) / det
    d = SVector(bary[2] * 0.5, 0.0) .+ 1.0 .- bary[1] .- bary[2]

    tc1 = sign((B[2] - A[2]) * (p[1] - A[1]) - (B[1] - A[1]) * (p[2] -  A[2]))
    tc2 = sign((C[2] - B[2]) * (p[1] - B[1]) - (C[1] - B[1]) * (p[2] - B[2]))
    tc3 = sign((C[2] - A[2]) * (B[1] - A[1]) - (C[1] - A[1]) * (B[2] - A[2]))

    s1 = tc1 * tc2
    t_sign = if d[1] - d[2] < 0.0
        if s1 < 0.0
            -1.0
        else
            1.0
        end
    else
        sign(d[1]^2 - d[2])
    end

    return dis * t_sign * tc3
end