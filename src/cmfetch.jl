function cmfetch(cmfile::AbstractString, id::AbstractString)
    exe = infernal_binary("cmfetch")
    out = tempname()
    run(`$exe -o $out $cmfile $id`)
    return (; out)
end
