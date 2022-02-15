import Documenter
import Literate
import Infernal

ENV["JULIA_DEBUG"] = "Documenter,Literate,Infernal"

const literate_dir = joinpath(@__DIR__, "src/literate")

function clear_md_files(dir::String)
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".md")
                rm(joinpath(root, file))
            end
        end
    end
end

clear_md_files(literate_dir)

for (root, dirs, files) in walkdir(literate_dir)
    for file in files
        if endswith(file, ".jl")
            Literate.markdown(joinpath(root, file), root; documenter=true)
        end
    end
end

Documenter.makedocs(
    modules = [Infernal],
    sitename = "Infernal.jl",
    pages = [
        "Home" => "index.md",
        "Examples" => [
            "Infernal" => "literate/infernal.md",
        ],
        "Reference" => "reference.md"
    ],
    strict = true
)

clear_md_files(literate_dir)

Documenter.deploydocs(
    repo = "github.com/cossio/Infernal.jl.git",
    devbranch = "master"
)
