# Infernal Julia package

Access [Infernal](http://eddylab.org/infernal/) commands from Julia.

## Installation

This package is registered. Install with:

```julia
import Pkg
Pkg.add("Infernal")
```

This package does not export any symbols.

Use either qualified calls such as `Infernal.cmfetch(...)` or import the
functions you need explicitly:

```julia
using Infernal: cmfetch, cmalign, cmalign_parse_sfile
```

Most functions are thin wrappers around Infernal command-line tools. They write
command outputs to temporary files and return a named tuple containing the
generated paths.

## Available wrappers

- `cmfetch`: fetch a covariance model from a CM database
- `cmalign`: align sequences to a covariance model
- `cmalign_parse_sfile`: parse `cmalign --sfile` output into a `DataFrame`
- `cmbuild`: build a covariance model from an alignment
- `cmemit`: emit example sequences from a covariance model
- `cmcalibrate`: calibrate a covariance model
- `cmsearch`: search sequences with a covariance model
- `cmsearch_parse_tblout`: parse `cmsearch --tblout` output into a `DataFrame`
- `esl_afetch`: fetch an alignment from an MSA database
- `esl_reformat`: convert between sequence/alignment formats

## Examples

### Fetch a covariance model and align sequences

```julia
using Infernal: cmfetch, cmalign, cmalign_parse_sfile

cm = cmfetch("/path/to/Rfam.cm", "RF00162")
alignment = cmalign(cm.out, "/path/to/sequences.fasta"; outformat="Stockholm")
summary = cmalign_parse_sfile(alignment.sfile)

summary[:, ["seq_name", "bit_sc", "avg_pp"]]
```

`alignment.out` contains the alignment written by `cmalign`, while
`alignment.sfile` contains the per-sequence summary parsed above.

### Fetch and reformat an alignment

```julia
using Infernal: esl_afetch, esl_reformat

seed = esl_afetch("/path/to/Rfam.seed", "RF00162")
afa = esl_reformat("AFA", seed.out; informat="Stockholm")

println(read(afa.out, String))
```

### Build, emit, and search with a covariance model

```julia
using Infernal: cmbuild, cmemit, cmsearch, cmsearch_parse_tblout

built = cmbuild("/path/to/alignment.sto"; informat="Stockholm")
emitted = cmemit(built.cmout; N=5, outformat="AFA")
search = cmsearch(built.cmout, emitted.out)
hits = cmsearch_parse_tblout(search.tblout)
```

## Notes

- The wrapped Infernal commands must succeed or the functions throw
  `ProcessFailedException`.
- Temporary output files are not deleted automatically; remove them when they
  are no longer needed.

Supported platforms:

* Linux
* macOS (Intel & M-series)

Windows not supported because Infernal is not available for Windows (use WSL instead).
