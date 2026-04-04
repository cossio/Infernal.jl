"""
    cmbuild(msafile; enone=false, informat=nothing)

Build a covariance model from the multiple sequence alignment file `msafile`.

Returns a named tuple with the generated covariance model and captured outputs:

- `cmout`: generated covariance model file
- `stdout`: command standard output
- `stderr`: command standard error
- `o`: main textual report written by `cmbuild -o`
- `O`: annotated alignment output written by `cmbuild -O`

# Example

```julia
using Infernal: cmbuild

result = cmbuild("/path/to/alignment.sto"; informat="Stockholm")
cm_text = read(result.cmout, String)
```
"""
function cmbuild(
    msafile::AbstractString;
    enone::Bool=false,
    informat::Opt{AbstractString} = nothing
)
    cmd = `$(Infernal_jll.cmbuild())`
    enone && (cmd = `$cmd --enone`)
    isnothing(informat) || (cmd = `$cmd --informat $informat`)

    stdout = tempname()
    stderr = tempname()
    cmout = tempname()
    o = tempname()
    O = tempname()

    run(pipeline(`$cmd -o $o -O $O $cmout $msafile`; stdout, stderr, append=false))
    return (; cmout, stdout, stderr, o, O)
end
