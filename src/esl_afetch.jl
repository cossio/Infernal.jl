"""
    esl_afetch(msafile, key)

Fetch the alignment with identifier `key` from the multi-alignment database file
`msafile` using `esl-afetch`.

Returns a named tuple with the fetched alignment and captured command streams.

# Example

```julia
using Infernal: esl_afetch

result = esl_afetch("/path/to/Rfam.seed", "RF00162")
stockholm = read(result.out, String)
```
"""
function esl_afetch(
    msafile::AbstractString, key::AbstractString
)
    cmd = `$(Infernal_jll.esl_afetch())`
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $msafile $key`; stdout, stderr, append=false))
    return (; out, stdout, stderr)
end
