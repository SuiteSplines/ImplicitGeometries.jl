using ImplicitGeometries

@testset "Rectangle" begin
    shape = Rectangle(; w=2.0, h=3.0)

    @test isapprox(shape(SVector(1.0, 1.5)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(1.0, -1.5)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-1.0, 1.5)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-1.0, -1.5)), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Circle" begin
    shape = Circle(; r=2.0)

    @test isapprox(shape(SVector(2.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, 2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, -2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), 2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), -2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2cos(π/4), 2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2cos(π/4), -2sin(π/4))), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Box" begin
    shape = Box(; w=2.0, h=3.0, d=4.0)

    @test isapprox(shape(SVector( 1.0,  1.5,  2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-1.0,  1.5,  2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector( 1.0, -1.5,  2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-1.0, -1.5,  2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector( 1.0,  1.5, -2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-1.0,  1.5, -2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector( 1.0, -1.5, -2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-1.0, -1.5, -2.0)), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Sphere" begin
    shape = Sphere(; r=2.0)

    @test isapprox(shape(SVector(2.0, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, 2.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, 0.0, 2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2.0, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, -2.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, 0.0, -2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), 2sin(π/4), 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), 0.0, 2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, 2cos(π/4), 2sin(π/4))), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Cylinder" begin
    shape = Cylinder(; r=2.0, h=3.0)

    @test isapprox(shape(SVector(2.0, -1.5, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, -1.5, 2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2.0, -1.5, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, -1.5, -2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), -1.5, 2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), -1.5, -2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2cos(π/4), -1.5, 2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2cos(π/4), -1.5, -2sin(π/4))), 0.0, atol=1e-12)

    @test isapprox(shape(SVector(2.0, 1.5, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, 1.5, 2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2.0, 1.5, 0.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(0.0, 1.5, -2.0)), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), 1.5, 2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(2cos(π/4), 1.5, -2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2cos(π/4), 1.5, 2sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(shape(SVector(-2cos(π/4), 1.5, -2sin(π/4))), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Polygon" begin
    # corners
    v = [
        SVector(-1.0, -1.0),
        SVector( 1.0, -1.0),
        SVector( 1.0,  1.0),
        SVector( 0.0,  2.0),
        SVector(-1.0,  1.0),
    ]

    # polygon
    shape = Polygon(; v=v)

    # test corners
    for p in v
        @test shape(p) == 0.0
    end

    # test center
    @test shape(sum(v)/length(v)) == -1.0

    # midpoints
    for k = Base.OneTo(length(v) - 1)
        p = (v[k] + v[k+1]) / 2
        @test shape(p) == 0.0
    end

    # step in normal direction on edge 1-5
    Δ = 0.42
    t = (v[5] - v[1])
    r = (v[5] + v[1]) / 2
    n = SVector(-t[2], t[1]) / norm(t)
    p = r + Δ*n
    @test isapprox(shape(p), Δ; atol=1e-12)

    # step in normal direction on edge 4-3
    Δ = 0.42
    t = (v[3] - v[4])
    r = (v[3] + v[4]) / 2
    n = SVector(-t[2], t[1]) / norm(t)
    p = r + Δ*n
    @test isapprox(shape(p), Δ; atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Bezier segment" begin
    A = SVector(-1.0, 0.0)
    B = SVector( 0.0, 1.0)
    C = SVector( 1.0, 0.0)
    shape = QuadraticBezierSegment(; A=A, B=B, C=C)

    @test shape(A) ==  0.0
    @test shape(B) == -0.5
    @test shape(C) ==  0.0
    @test isapprox(shape(SVector(0.0,0.0)), 0.5, atol=1e-12)
end

@testset "Bezier multisegment" begin
    ctrlpts = [
        SVector(-1.0,  0.0), 0.0 .* SVector(-1.0,  1.0), SVector( 0.0,  1.0),
        SVector( 0.0,  1.0), 0.0 .* SVector( 1.0,  1.0), SVector( 1.0,  0.0),
        SVector( 1.0,  0.0), 0.0 .* SVector( 1.0, -1.0), SVector( 0.0, -1.0),
        SVector( 0.0, -1.0), 0.0 .* SVector(-1.0, -1.0), SVector(-1.0,  0.0),
    ]

    shape = QuadraticBezier(; v=ctrlpts)

    # test at interpolated control points
    for k in [1, 3, 4, 6, 7, 9, 10, 12]
        @test shape(ctrlpts[k]) == 0.0
    end
    
    # midpoints between interpolated control points (outside!)
    p1 = (ctrlpts[1] + ctrlpts[3]) / 2
    p2 = (ctrlpts[4] + ctrlpts[6]) / 2
    p3 = (ctrlpts[7] + ctrlpts[9]) / 2
    p4 = (ctrlpts[10] + ctrlpts[12]) / 2
    @test shape(p1) == shape(p2) == shape(p3) == shape(p4) > 0.0

    # evaluate Bezier explicitly and test
    bfun(t, A, B, C) = (1-t)*((1-t)*A + t*B) + t*((1-t)*B + t*C)
    for t in LinRange(0.0, 1.0, 10)
        p = bfun(t, ctrlpts[1], ctrlpts[2], ctrlpts[3])
        @test isapprox(shape(p), 0.0, atol=1e-12)
    end
end