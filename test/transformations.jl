using ImplicitGeometries
using StaticArrays

@testset "Translation" begin
    rect = Translation(Rectangle(); dx = 0.1, dy = 0.2)
    @test isapprox(rect(SVector(0.6, 0.7)), 0.0, atol=1e-12)

    box = Translation(Box(); dx = 0.1, dy = 0.2, dz = 0.3)
    @test isapprox(box(SVector(0.6, 0.7, 0.8)), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, rect) == nothing
    @test print_tree(devnull, box) == nothing
end

@testset "Scaling" begin
    box = Scaling(Box(); s=2.0)
    @test isapprox(box(SVector(1.0, 1.0, 1.0)), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, box) == nothing
end

@testset "Rotation" begin
    rectangle = Rotation(Rectangle(; w=0.25); θ = Float64(π), dx = -1.0, dy = 0.0)
    @test isapprox(rectangle(SVector(-2.125, 0.5)), 0.0, atol=1e-12)

    box = Rotation(Box(; w=0.25); ψ = Float64(π), dx = -1.0, dy = 0.0, dz = 0.0)
    @test isapprox(box(SVector(-2.125, 0.5, 0.0)), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, rectangle) == nothing
    @test print_tree(devnull, box) == nothing
end

@testset "Onion" begin
    rect = Onion(Rectangle(); r = 0.2)
    @test isapprox(rect(SVector(0.0, 0.7)), 0.0, atol=1e-12)
    @test isapprox(rect(SVector(0.5, 0.5)), -0.2, atol=1e-12)
    @test isapprox(rect(SVector(0.3, 0.3)), 0.0, atol=1e-12)
    @test rect(SVector(0.7, 0.7)) > 0

    # test AbstractTrees integration
    @test print_tree(devnull, rect) == nothing
end

@testset "Ring" begin
    rect = Ring(Rectangle(); r = 0.2)
    @test isapprox(rect(SVector(0.0, 0.7)), 0.0, atol=1e-12)
    @test isapprox(rect(SVector(0.5, 0.5)), -0.2, atol=1e-12)
    @test rect(SVector(0.7, 0.7)) > 0

    # test AbstractTrees integration
    @test print_tree(devnull, rect) == nothing
end

@testset "Boolean negative" begin
    rect = Rectangle()
    rectneg = BooleanNegative(rect)
    @test isapprox(rectneg(SVector(0.5, 0.5)), 0.0, atol=1e-12)
    @test rectneg(SVector(0.25, 0.25)) > 0
    @test rectneg(SVector(0.7, 0.7)) < 0

    rectneg = ¬rect
    @test isapprox(rectneg(SVector(0.5, 0.5)), 0.0, atol=1e-12)
    @test rectneg(SVector(0.25, 0.25)) > 0
    @test rectneg(SVector(0.7, 0.7)) < 0

    # test AbstractTrees integration
    @test print_tree(devnull, rectneg) == nothing
end

@testset "Elongation" begin
    box = Elongation(Cylinder(; h=0.25); dx=1.0)

    # lef side
    @test isapprox(box(SVector(-2.0, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(box(SVector(-1.0, 0.0, 1.0)), 0.0, atol=1e-12)
    @test isapprox(box(SVector(-1.0, 0.0, -1.0)), 0.0, atol=1e-12)
    @test isapprox(box(SVector(-1.0-cos(pi/4), 0.0, sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(box(SVector(-1.0-cos(pi/4), 0.0, -sin(π/4))), 0.0, atol=1e-12)

    # right side
    @test isapprox(box(SVector(2.0, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(box(SVector(1.0, 0.0, 1.0)), 0.0, atol=1e-12)
    @test isapprox(box(SVector(1.0, 0.0, -1.0)), 0.0, atol=1e-12)
    @test isapprox(box(SVector(1.0+cos(pi/4), 0.0, sin(π/4))), 0.0, atol=1e-12)
    @test isapprox(box(SVector(1.0+cos(pi/4), 0.0, -sin(π/4))), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, box) == nothing
end

@testset "Revolution" begin
    r = 0.25
    circle = Circle(; r=r)
    torus = Revolution(circle, o=2.0)

    @test isapprox(torus(SVector(2.0+r, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(2.0-r, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(2.0, r, 0.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(2.0, -r, 0.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(-2.0+r, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(-2.0-r, 0.0, 0.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(-2.0, r, 0.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(-2.0, -r, 0.0)), 0.0, atol=1e-12)

    @test isapprox(torus(SVector(0.0, 0.0, 2.0+r)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(0.0, 0.0, 2.0-r)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(0.0, r, 2.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(0.0, -r, 2.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(0.0, 0.0, -2.0+r)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(0.0, 0.0, -2.0-r)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(0.0, r, -2.0)), 0.0, atol=1e-12)
    @test isapprox(torus(SVector(0.0, -r, -2.0)), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, torus) == nothing
end

@testset "Extrusion" begin
    h = 0.25
    circle = Circle()
    disk = Extrusion(circle; h=h)

    @test isapprox(disk(SVector(cos(π/4), sin(π/4), h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(-cos(π/4), sin(π/4), h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(cos(π/4), -sin(π/4), h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(-cos(π/4), -sin(π/4), h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(cos(π/4), sin(π/4), -h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(-cos(π/4), sin(π/4), -h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(cos(π/4), -sin(π/4), -h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(-cos(π/4), -sin(π/4), -h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(0.0, 0.0, h)), 0.0, atol=1e-12)
    @test isapprox(disk(SVector(0.0, 0.0, -h)), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, disk) == nothing
end