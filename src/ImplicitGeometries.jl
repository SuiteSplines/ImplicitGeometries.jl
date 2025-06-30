module ImplicitGeometries

    using AbstractTrees, StaticArrays, LinearAlgebra
    import Rotations: RotX, RotY, RotZ

    include("base.jl")
    include("linalg.jl")
    include("gradients.jl")
    include("shapes.jl")
    include("operations.jl")
    include("transformations.jl")

end # module
