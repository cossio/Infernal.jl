function cmbuild(
    msafile::AbstractString;
    enone::Bool=false,
    informat::Opt{AbstractString} = nothing
)
    exe = infernal_binary("cmbuild")
    cmd = `$exe`
    enone && (cmd = `$cmd --enone`)
    isnothing(informat) || (cmd = `$cmd --informat $informat`)

    stdout = tempname()
    stderr = tempname()
    cmout = tempname()
    o = tempname()
    O = tempname()

    run(pipeline(`$cmd -o $o -O $O $cmout $msafile`; stdout, stderr, append=false))
    return (; cmout, stdout, stderr, o, O)
end
