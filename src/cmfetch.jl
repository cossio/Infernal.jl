function cmfetch(cmfile::AbstractString, id::AbstractString)
    exe = infernal_binary("cmfetch")
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$exe -o $out $cmfile $id`; stdout, stderr))
    return (; out, stdout, stderr)
end
