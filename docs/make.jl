using ImplicitGeometries
using Documenter

DocMeta.setdocmeta!(ImplicitGeometries, :DocTestSetup, :(using ImplicitGeometries); recursive=true)

makedocs(;
    modules=[ImplicitGeometries],
    authors="Michał Mika and contributors",
    sitename="ImplicitGeometries.jl",
    format=Documenter.HTML(;
        canonical="https://SuiteSplines.github.io/ImplicitGeometries.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/SuiteSplines/ImplicitGeometries.jl",
    devbranch="main",
)
