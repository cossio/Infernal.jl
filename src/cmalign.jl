function cmalign(
    cmfile::AbstractString,
    seqfile::AbstractString;
    glob::Bool=false, notrunc::Bool=false,
    informat::Opt{AbstractString}=nothing,
    outformat::Opt{AbstractString}=nothing
)
    exe = infernal_binary("cmalign")
    cmd = `$exe`
    glob && (cmd = `$cmd -g`)
    notrunc && (cmd = `$cmd --ntrunc`)
    isnothing(informat) || (cmd = `$cmd --informat $informat`)
    isnothing(outformat) || (cmd = `$cmd --outformat $outformat`)

    out = tempname()
    tfile = tempname()
    sfile = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd --tfile $tfile --sfile $sfile -o $out $cmfile $seqfile`; stdout, stderr, append=false))
    return (; out, stdout, stderr, tfile, sfile)
end

function cmalign_parse_sfile(path::AbstractString)
    csv = CSV.File(
        path; delim=' ', ignorerepeated=true, comment="#",
        header=["idx", "seq_name", "length", "cm_from", "cm_to", "trunc", "bit_sc", "avg_pp", "band_calc", "alignment", "total", "mem_Mb"]
    )
    return DataFrame(csv)
end
