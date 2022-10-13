function cmbuild(
    msafile::AbstractString;
    enone::Bool=false,
)
    exe = infernal_binary("cmbuild")
    cmd = `$exe`
    enone && (cmd = `$cmd --enone`)

    cmout = tempname()
    stdout = tempname()
    stderr = tempname()

    run(pipeline(`$cmd $cmout $msafile`; stdout, stderr, append=false))
    return (; cmout, stdout, stderr)
end
