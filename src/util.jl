Opt{T} = Union{Nothing,T}

function infernal_binaries_dir()
    if Sys.isapple()
        return joinpath(artifact"Infernal", "infernal-1.1.4-macosx-intel", "binaries")
    else
        return joinpath(artifact"Infernal", "infernal-1.1.4-linux-intel-gcc", "binaries")
    end
end

infernal_binary(name) = joinpath(infernal_binaries_dir(), name)

"""
    gunzip(path)

Decompress a gunzipped file.
"""
gunzip(file::String) = Gzip_jll.gzip() do gzip
    run(`$gzip -d $file`)
end
