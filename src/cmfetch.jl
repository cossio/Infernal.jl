function cmfetch(cmfile::AbstractString, id::AbstractString)
    cmd = `$(Infernal_jll.cmfetch())`
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $cmfile $id`; stdout, stderr))
    return (; out, stdout, stderr)
end
