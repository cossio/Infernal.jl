"""
    cmsearch(cmfile, seqfile; toponly=false, bottomonly=false, notrunc=false)

Search the sequences in `seqfile` with the covariance model `cmfile`.

Returns a named tuple with the main report, Stockholm alignment output, tabular
summary output, and captured command streams:

- `out`: main `cmsearch` report
- `stdout`: command standard output
- `stderr`: command standard error
- `A`: alignment output produced with `-A`
- `tblout`: tabular summary produced with `--tblout`

# Example

```julia
using Infernal: cmsearch

result = cmsearch("/path/to/model.cm", "/path/to/sequences.fasta"; toponly=true)
hits = read(result.tblout, String)
```
"""
function cmsearch(
    cmfile::AbstractString, seqfile::AbstractString;
    toponly::Bool=false, bottomonly::Bool=false, notrunc::Bool=false
)
    cmd = `$(Infernal_jll.cmsearch())`

    toponly && (cmd = `$cmd --toponly`)
    bottomonly && (cmd = `$cmd --bottomonly`)
    notrunc && (cmd = `$cmd --notrunc`)

    out = tempname()
    stdout = tempname()
    stderr = tempname()
    tblout = tempname()
    A = tempname()

    run(
        pipeline(
            `$cmd -o $out -A $A --tblout $tblout $cmfile $seqfile`;
            stdout, stderr, append=false
        )
    )
    return (; out, stdout, stderr, A, tblout)
end

"""
    cmsearch_parse_tblout(tblout)

Parse a `cmsearch --tblout` file into a `DataFrame`.

# Example

```julia
using Infernal: cmsearch, cmsearch_parse_tblout

result = cmsearch("/path/to/model.cm", "/path/to/sequences.fasta")
table = cmsearch_parse_tblout(result.tblout)
```
"""
function cmsearch_parse_tblout(tblout::AbstractString)
    csv = CSV.File(
        tblout; delim=' ', ignorerepeated=true, comment="#",
        header=[
            "target_name", "accession", "query_name", "accession2",
            "mdl", "mdl_from", "mdl_to", "seq_from", "seq_to", "strand",
            "trunc", "pass", "gc", "bias", "score",
            "E_value", "inc", "description_of_target"
        ]
    )
    return DataFrame(csv)
end
