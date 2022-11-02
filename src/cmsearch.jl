function cmsearch(
    cmfile::AbstractString, seqfile::AbstractString;
    toponly::Bool=false, bottomonly::Bool=false, notrunc::Bool=false
)
    exe = infernal_binary("cmsearch")
    cmd = `$exe`

    toponly && (cmd = `$cmd --toponly`)
    bottomonly && (cmd = `$cmd --bottomonly`)
    notrunc && (cmd = `$cmd --notrunc`)

    out = tempname()
    stdout = tempname()
    stderr = tempname()
    tblout = tempname()
    A = tempname()

    run(
        pipeline(
            `$cmd -o $out -A $A --tblout $tblout $cmfile $seqfile`;
            stdout, stderr, append=false
        )
    )
    return (; out, stdout, stderr, A, tblout)
end

function cmsearch_parse_tblout(tblout::AbstractString)
    csv = CSV.File(
        tblout; delim=' ', ignorerepeated=true, comment="#",
        header=[
            "target_name", "accession", "query_name", "accession2",
            "mdl", "mdl_from", "mdl_to", "seq_from", "seq_to", "strand",
            "trunc", "pass", "gc", "bias", "score",
            "E_value", "inc", "description_of_target"
        ]
    )
    return DataFrame(csv)
end
