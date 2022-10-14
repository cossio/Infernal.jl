function cmsearch(
    cmfile::AbstractString, seqfile::AbstractString;
    toponly::Bool=false, bottomonly::Bool=false
)
    exe = infernal_binary("cmsearch")
    cmd = `$exe`

    toponly && (cmd = `$cmd --toponly`)
    bottomonly && (cmd = `$cmd --bottomonly`)

    out = tempname()
    stdout = tempname()
    stderr = tempname()

    run(pipeline(`$cmd -o $out $cmfile $seqfile`; stdout, stderr, append=false))
    return (; out, stdout, stderr)
end
