using Test: @test, @testset, @inferred
using Downloads: download
import Gzip_jll

# decompress a gzipped file
gunzip(file::String) = run(`$(Gzip_jll.gzip()) -d $file`)

const RFAM_ID = "RF00162" # Family we will use in tests
const RFAM_VERSION = "14.8"

@info "Downloading Rfam.cm ..."
const CM_FILE = tempname()
download("https://ftp.ebi.ac.uk/pub/databases/Rfam/14.8/Rfam.cm.gz", CM_FILE * ".gz")
gunzip(CM_FILE * ".gz")
@test isfile(CM_FILE)

@info "Downloading all seed alignments ..."
const RFAM_SEED = tempname()
download("https://ftp.ebi.ac.uk/pub/databases/Rfam/$RFAM_VERSION/Rfam.seed.gz", RFAM_SEED * ".gz")
gunzip(RFAM_SEED * ".gz")
@test isfile(RFAM_SEED)

@info "Downloading $RFAM_ID hit sequences ..."
const FULL_FASTA_FILE = tempname()
download(
    "https://ftp.ebi.ac.uk/pub/databases/Rfam/$RFAM_VERSION/fasta_files/$RFAM_ID.fa.gz",
    FULL_FASTA_FILE * ".gz"
)
gunzip(FULL_FASTA_FILE * ".gz")
@test isfile(FULL_FASTA_FILE)

# Tests
module esl_afetch_tests include("esl_afetch.jl") end
module esl_reformat_tests include("esl_reformat.jl") end

module cmfetch_tests include("cmfetch.jl") end
module cmalign_tests include("cmalign.jl") end
module cmbuild_tests include("cmbuild.jl") end
module cmemit_tests include("cmemit.jl") end
module cmsearch_tests include("cmsearch.jl") end
