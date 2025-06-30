using ImplicitGeometries
using StaticArrays
using AbstractTrees

@testset "Boolean union" begin
    rectangle = Rectangle(; w = 2.0, h = 2.0)
    circle = Translation(Circle(); dx = 1.0, dy = 1.0)

    # shape = BooleanUnion(rectangle, circle)
    shape = rectangle ∪ circle
    print_tree(devnull, shape)

    # point on rectangle
    x = SVector(-1.0, 1.0)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point on circle
    x = circle.q + SVector(1.0, 1.0) / sqrt(2)
    @test isapprox(shape(x), 0.0, atol=1e-12)
    
    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Boolean intersection" begin
    rect1 = Translation(Rectangle(; w = 2.0, h = 2.0); dx = 0.5, dy = 0.5)
    rect2 = Translation(Rectangle(; w = 2.0, h = 2.0); dx = -0.5, dy = -0.5)

    # shape = BooleanIntersection(rect1, rect2)
    shape = rect1 ∩ rect2

    # point on intersection
    x = SVector(0.0, 0.5)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Boolean subtraction" begin
    rectangle = Rectangle(; w = 2.0, h = 2.0)
    circle = Circle(; r=0.5)

    # shape = BooleanSubtraction(rectangle, circle)
    shape = rectangle - circle

    # point on rectangle
    x = SVector(-1.0, 1.0)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point on circle
    x = SVector(0.5, 0.0)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point outside rectangle
    x = SVector(1.5, 1.5)
    @test shape(x) > 0

    # point inside circle
    x = SVector(0.0, 0.0)
    @test shape(x) > 0

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Boolean difference" begin
    rect1 = Translation(Rectangle(; w = 2.0, h = 2.0); dx = 0.5, dy = 0.5)
    rect2 = Translation(Rectangle(; w = 2.0, h = 2.0); dx = -0.5, dy = -0.5)

    # shape = BooleanDifference(rect1, rect2)
    shape = rect1 \ rect2

    # point on difference
    x = SVector(0.0, 0.0)
    @test shape(x) > 0

    # point on rectangle 1
    x = SVector(1.5, 1.5)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point on rectangle 2
    x = SVector(-1.5, -1.5)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point outside
    x = SVector(-1.5, 1.5)
    @test shape(x) > 0

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Smooth union" begin
    rectangle = Rectangle(; w = 2.0, h = 2.0)
    circle = Translation(Circle(); dx = 1.0, dy = 1.0)

    shape = SmoothUnion(rectangle, circle; k = 0.5)

    # point on rectangle
    x = SVector(-1.0, 1.0)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point on circle
    x = circle.q + SVector(1.0, 1.0) / sqrt(2)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point inside transition region
    x = SVector(-0.05, 1.1)
    @test shape(x) < 0

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Smooth intersection" begin
    rect1 = Translation(Rectangle(; w = 2.0, h = 2.0); dx = 0.5, dy = 0.5)
    rect2 = Translation(Rectangle(; w = 2.0, h = 2.0); dx = -0.5, dy = -0.5)

    shape = SmoothIntersection(rect1, rect2; k = 0.5)

    # point on intersection
    x = SVector(0.0, 0.5)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point on transition region
    x = SVector(-0.48, 0.48)
    @test shape(x) > 0

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Smooth subtraction" begin
    rectangle = Rectangle(; w = 2.0, h = 2.0)
    circle = Translation(Circle(; r=0.5); dx = 1.0)

    shape = SmoothSubtraction(rectangle, circle; k = 0.5)

    # point on rectangle
    x = SVector(-1.0, 1.0)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point on circle
    x = circle.q - SVector(0.5, 0.0)
    @test isapprox(shape(x), 0.0, atol=1e-12)

    # point outside rectangle
    x = SVector(1.5, 1.5)
    @test shape(x) > 0

    # point inside circle
    x = circle.q 
    @test shape(x) > 0

    # point on transition region
    x = circle.q + SVector(-0.1, 0.5)
    @test shape(x) > 0

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end

@testset "Smooth minimum" begin
    rectangle = Rectangle(; w = 2.0, h = 2.0)
    circle = Translation(Circle(); dx = 1.0, dy = 1.0)

    shape = SmoothMinimum(rectangle, circle; k = 0.5)

    # point inside transition region
    x = SVector(-0.05, 1.1)
    @test shape(x) < 0

    # test AbstractTrees integration
    @test print_tree(devnull, shape) == nothing
end