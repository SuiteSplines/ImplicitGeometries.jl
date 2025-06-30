import ImplicitGeometries: mix

@testset "Mix (linear interpolation)" begin
    @test mix(-2.0, 3.0, 0.0) == -2.0
    @test mix(-2.0, 3.0, 1.0) == 3.0
    @test isapprox(mix(-2.0, 3.0, 0.4), 0.0, atol=1e-12)
end