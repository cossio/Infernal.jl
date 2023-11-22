function cmcalibrate(cmfile::AbstractString)
    cmd = `$(Infernal_jll.cmcalibrate())`

    stdout = tempname()
    stderr = tempname()

    run(pipeline(`$cmd $cmfile`; stdout, stderr, append=false))
    return (; stdout, stderr)
end
