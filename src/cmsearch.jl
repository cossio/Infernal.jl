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
