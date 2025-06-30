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