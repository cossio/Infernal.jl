function cmalign(
    cmfile::AbstractString,
    seqfile::AbstractString;
    glob::Bool=false, notrunc::Bool=false,
    informat::Opt{AbstractString}=nothing,
    outformat::Opt{AbstractString}=nothing
)
    cmd = `$(infernal_binary("cmalign"))`
    glob && (cmd = `$cmd -g`)
    notrunc && (cmd = `$cmd --ntrunc`)
    isnothing(informat) || (cmd = `$cmd --informat $informat`)
    isnothing(outformat) || (cmd = `$cmd --outformat $outformat`)

    out = tempname()
    tfile = tempname()
    sfile = tempname()
    run(`$cmd --tfile $tfile --sfile $sfile -o $out $cmfile $seqfile`)

    return (; out, tfile, sfile)
end

function cmalign_parse_sfile(path::AbstractString)
    csv = CSV.File(
        path; delim=' ', ignorerepeated=true, comment="#",
        header=["idx", "seq_name", "length", "cm_from", "cm_to", "trunc", "bit_sc", "avg_pp", "band_calc", "alignment", "total", "mem_Mb"]
    )
    return DataFrame(csv)
end
