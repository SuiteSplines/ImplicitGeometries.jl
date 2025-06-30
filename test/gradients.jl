using ImplicitGeometries
using LinearAlgebra, StaticArrays

@testset "Central difference tetrahedron normals (sphere)" begin
    sphere = Sphere()
    normal = Normal(sphere)

    x = SVector(1.0, 1.0, 1.0) / sqrt(3)
    n = normal(x)

    @test norm(n) == 1.0
    @test isapprox(n, x, atol=1e-14)
end

@testset "Central difference tetrahedron normals (box)" begin
    box = Box()
    normal = Normal(box)

    points = [
        SVector(-1.0, 0.0, 0.0),
        SVector(1.0, 0.0, 0.0),
        SVector(0.0, -1.0, 0.0),
        SVector(0.0, 1.0, 0.0),
        SVector(0.0, 0.0, -1.0),
        SVector(0.0, 0.0, 1.0)
    ]

    for x in points
        n = normal(x)
        @test isapprox(norm(n), 1.0, atol=1e-14)
        @test isapprox(n, x, atol=1e-14)
    end
end

@testset "Central difference cross normals (circle)" begin
    circle = Circle()
    normal = Normal(circle; h=1e-4)

    x = SVector(1.0, 1.0) / sqrt(2)
    n = normal(x)

    @test isapprox(norm(n), 1.0, atol=1e-14)
    @test isapprox(n, x, atol=1e-14)
end

@testset "Central difference cross normals (rectangle)" begin
    rectangle = Rectangle()
    normal = Normal(rectangle)

    points = [
        SVector(-1.0, 0.0),
        SVector(1.0, 0.0),
        SVector(0.0, -1.0),
        SVector(0.0, 1.0),
    ]

    for x in points
        n = normal(x)
        @test isapprox(norm(n), 1.0, atol=1e-14)
        @test isapprox(n, x, atol=1e-14)
    end
end

@testset "Central difference tetrahedron normals (sphere)" begin
    sphere = Sphere()
    gradient = Gradient(sphere; h=1e-8)

    x = SVector(1.0, 2.0, 3.0)
    ∇ = gradient(x)

    @test isapprox(∇, x/norm(x), atol=10e-8)
end

@testset "Central difference cross gradient (circle)" begin
    circle = Circle()
    gradient = Gradient(circle)

    x = SVector(1.0, 2.0)
    ∇ = gradient(x)

    @test isapprox(∇, x/norm(x), atol=10e-10)
end