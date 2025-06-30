using ImplicitGeometries

@testset "Base.show for <:SDF" begin
    shape = Rectangle() - Circle()

    io = IOBuffer()
    Base.show(io, shape)
    msg = String(take!(io))

    @test msg == "BooleanSubtraction{2, Float64}"
end