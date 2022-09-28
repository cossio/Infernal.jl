Opt{T} = Union{Nothing,T}

function cmalign(
    cmfile::AbstractString, # path to CM file
    seqfile::AbstractString; # path to sequence file
    g::Bool=false, # -g
    o::Opt{AbstractString}=nothing, # -o; output path
    tfile::Opt{AbstractString}=nothing, # --tfile
    informat::Opt{AbstractString}=nothing,
    outformat::Opt{AbstractString}=nothing
)

end

run(`$(Infernal_jll.cmaling()) -h`)
