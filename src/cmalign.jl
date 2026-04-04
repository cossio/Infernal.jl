"""
    cmalign(cmfile, seqfile; glob=false, notrunc=false, informat=nothing,
            outformat=nothing, matchonly=false)

Align sequences in `seqfile` against the covariance model stored in `cmfile`.

Returns a named tuple containing the main alignment output and auxiliary files:

- `out`: alignment produced by `cmalign -o`
- `stdout`: command standard output
- `stderr`: command standard error
- `tfile`: tabular trace information
- `sfile`: per-sequence summary file

# Example

```julia
using Infernal: cmalign

result = cmalign("/path/to/model.cm", "/path/to/sequences.fasta"; outformat="Stockholm")
alignment = read(result.out, String)
```
"""
function cmalign(
    cmfile::AbstractString,
    seqfile::AbstractString;
    glob::Bool=false, notrunc::Bool=false,
    informat::Opt{AbstractString}=nothing,
    outformat::Opt{AbstractString}=nothing,
    matchonly::Bool=false
)
    cmd = `$(Infernal_jll.cmalign())`
    glob && (cmd = `$cmd -g`)
    notrunc && (cmd = `$cmd --notrunc`)
    matchonly && (cmd = `$cmd --matchonly`)
    isnothing(informat) || (cmd = `$cmd --informat $informat`)
    isnothing(outformat) || (cmd = `$cmd --outformat $outformat`)

    out = tempname()
    tfile = tempname()
    sfile = tempname()
    stdout = tempname()
    stderr = tempname()

    run(pipeline(`$cmd --tfile $tfile --sfile $sfile -o $out $cmfile $seqfile`; stdout, stderr, append=false))
    return (; out, stdout, stderr, tfile, sfile)
end

"""
    cmalign_parse_sfile(path)

Parse a `cmalign --sfile` summary file into a `DataFrame`.

# Example

```julia
using Infernal: cmalign, cmalign_parse_sfile

result = cmalign("/path/to/model.cm", "/path/to/sequences.fasta")
summary = cmalign_parse_sfile(result.sfile)
```
"""
function cmalign_parse_sfile(path::AbstractString)
    csv = CSV.File(
        path; delim=' ', ignorerepeated=true, comment="#",
        header=[
            "idx", "seq_name", "length", "cm_from", "cm_to", "trunc", "bit_sc", "avg_pp",
            "band_calc", "alignment", "total", "mem_Mb"
        ]
    )
    return DataFrame(csv)
end
