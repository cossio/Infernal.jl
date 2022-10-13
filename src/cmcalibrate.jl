function cmcalibrate(cmfile::AbstractString)
    exe = infernal_binary("cmcalibrate")
    cmd = `$exe`

    stdout = tempname()
    stderr = tempname()

    run(pipeline(`$cmd $cmfile`; stdout, stderr, append=false))
    return (; stdout, stderr)
end
