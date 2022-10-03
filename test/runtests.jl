using Test: @test, @testset, @inferred
using Downloads: download
import Gzip_jll

# decompress a gzipped file
gunzip(file::String) = run(`$(Gzip_jll.gzip()) -d $file`)

@info "Downloading Rfam.cm ..."
const CM_FILE = tempname()
download("https://ftp.ebi.ac.uk/pub/databases/Rfam/14.8/Rfam.cm.gz", CM_FILE * ".gz")
gunzip(CM_FILE * ".gz")
@test isfile(CM_FILE)

const RFAM_FAMILY = "RF00162"
@info "Downloading $RFAM_FAMILY sequences ..."
const RFAM_VERSION = "14.8"
const FULL_FASTA_FILE = tempname()
download(
    "https://ftp.ebi.ac.uk/pub/databases/Rfam/$RFAM_VERSION/fasta_files/$RFAM_FAMILY.fa.gz",
    FULL_FASTA_FILE * ".gz"
)
gunzip(FULL_FASTA_FILE * ".gz")
@test isfile(FULL_FASTA_FILE)

# Tests
module cmfetch_tests include("cmfetch.jl") end
module cmalign_tests include("cmalign.jl") end
