function cmbuild(
    msafile::AbstractString;
    enone::Bool=false,
)
    exe = infernal_binary("cmbuild")
    cmd = `$exe`
    enone && (cmd = `$cmd --enone`)
    cmout = tempname()
    run(`$cmd $cmout $msafile`)
    return (; cmout)
end
