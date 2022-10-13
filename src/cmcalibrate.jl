function cmcalibrate(cmfile::AbstractString)
    exe = infernal_binary("cmcalibrate")
    cmd = `$exe`
    run(`$cmd $cmfile`)
    return nothing
end
