function infernal_binaries_dir()
    if Sys.isapple() && Sys.ARCH === :aarch64
        return joinpath(artifact"Infernal", "infernal-1.1.5-macosx-silicon", "binaries")
    elseif Sys.isapple() && Sys.ARCH === :x86_64
        return joinpath(artifact"Infernal", "infernal-1.1.5-macosx-intel", "binaries")
    elseif Sys.islinux()
        return joinpath(artifact"Infernal", "infernal-1.1.5-linux-intel-gcc", "binaries")
    else
        error("Unsupported platform")
    end
end

infernal_binary(name::AbstractString) = joinpath(infernal_binaries_dir(), name)
