using Test

tests = [
    "base",
    "linalg",
    "gradients",
    "operations",
    "transformations",
    "shapes",
]

@testset "ImplicitGeometries" begin
    for t in tests
        fp = joinpath(dirname(@__FILE__), "$t.jl")
        println("$fp ...")
        include(fp)
    end
end # @testset
