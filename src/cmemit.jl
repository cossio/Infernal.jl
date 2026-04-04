"""
    cmemit(cmfile; N=10, exp=1, aligned=false, outformat=nothing)

Emit example sequences from the covariance model in `cmfile`.

Returns a named tuple with keys:
- `out`: path to the emitted sequences file.
- `tfile`: path to the trace file.
- `stdout`: path to captured standard output.
- `stderr`: path to captured standard error.

# Example

```julia
using Infernal: cmemit

result = cmemit("/path/to/model.cm"; N=5, outformat="AFA")
fasta_text = read(result.out, String)
```
"""
function cmemit(
    cmfile::AbstractString;
    N::Int = 10, exp::Real = 1, aligned::Bool=false,
    outformat::Opt{AbstractString}=nothing
)
    cmd = `$(Infernal_jll.cmemit())`
    aligned && (cmd = `$cmd -a`)
    isnothing(outformat) || (cmd = `$cmd --outformat $outformat`)
    out = tempname()
    tfile = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -N $N --exp $exp --tfile $tfile -o $out $cmfile`; stdout, stderr))
    return (; out, stdout, stderr, tfile)
end
