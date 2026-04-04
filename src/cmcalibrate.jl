"""
    cmcalibrate(cmfile)

Calibrate the covariance model stored in `cmfile` with Infernal's
`cmcalibrate` command.

Returns a named tuple with captured standard output and standard error.

# Example

```julia
using Infernal: cmcalibrate

result = cmcalibrate("/path/to/model.cm")
log_text = read(result.stderr, String)
```
"""
function cmcalibrate(cmfile::AbstractString)
    cmd = `$(Infernal_jll.cmcalibrate())`

    stdout = tempname()
    stderr = tempname()

    run(pipeline(`$cmd $cmfile`; stdout, stderr, append=false))
    return (; stdout, stderr)
end
