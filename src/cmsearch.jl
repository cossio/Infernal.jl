function cmsearch(cmfile::AbstractString, seqfile::AbstractString)
    exe = infernal_binary("cmsearch")
    cmd = `$exe`
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $cmfile $seqfile`; stdout, stderr, append=false))
    return (; out, stdout, stderr)
end
