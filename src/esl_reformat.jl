"""
    esl_reformat(format, seqfile; informat=nothing)

Reformat `seqfile` into the sequence/alignment format named by `format` using
Infernal's `esl-reformat`.

Returns a named tuple with the reformatted output and captured command streams.

# Example

```julia
using Infernal: esl_reformat

result = esl_reformat("AFA", "/path/to/alignment.sto"; informat="Stockholm")
afa_text = read(result.out, String)
```
"""
function esl_reformat(
    format::AbstractString, seqfile::AbstractString;
    informat::Opt{AbstractString}=nothing
)
    cmd = `$(Infernal_jll.esl_reformat())`
    isnothing(informat) || (cmd = `$cmd --informat $informat`)
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $format $seqfile`; stdout, stderr))
    return (; out, stdout, stderr)
end
