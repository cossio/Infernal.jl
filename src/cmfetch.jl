"""
    cmfetch(cmfile, id)

Fetch a covariance model with identifier `id` from the Infernal model database
file `cmfile`.

Returns a named tuple with the generated output file and captured standard output
and standard error:

- `out`: fetched covariance model
- `stdout`: command standard output
- `stderr`: command standard error

# Example

```julia
using Infernal: cmfetch

result = cmfetch("/path/to/Rfam.cm", "RF00162")
cm_text = read(result.out, String)
```
"""
function cmfetch(cmfile::AbstractString, id::AbstractString)
    cmd = `$(Infernal_jll.cmfetch())`
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $cmfile $id`; stdout, stderr))
    return (; out, stdout, stderr)
end
