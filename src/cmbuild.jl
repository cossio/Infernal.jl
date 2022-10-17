function cmbuild(
    msafile::AbstractString;
    enone::Bool=false
)
    exe = infernal_binary("cmbuild")
    cmd = `$exe`
    enone && (cmd = `$cmd --enone`)

    stdout = tempname()
    stderr = tempname()
    cmout = tempname()
    o = tempname()
    O = tempname()

    run(pipeline(`$cmd -o $o -O $O $cmout $msafile`; stdout, stderr, append=false))
    return (; cmout, stdout, stderr, o, O)
end
