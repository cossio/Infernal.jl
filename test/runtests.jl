using Test: @test, @testset, @inferred
using Downloads: download
import Gzip_jll
import Rfam

# decompress a gzipped file
gunzip(file::String) = run(`$(Gzip_jll.gzip()) -d $file`)

const RFAM_ID = "RF00162" # Family we will use in tests
const RFAM_VERSION = "14.8"
const RFAM_DIR = tempdir()

@info "Downloading Rfam.cm ..."
const CM_FILE = Rfam.cm(; dir=RFAM_DIR, version=RFAM_VERSION)
@test isfile(CM_FILE)

@info "Downloading all seed alignments ..."
const RFAM_SEED = Rfam.seed(; dir=RFAM_DIR, version=RFAM_VERSION)
@test isfile(RFAM_SEED)

@info "Downloading $RFAM_ID hit sequences ..."
const FULL_FASTA_FILE = Rfam.fasta_file(RFAM_ID; dir=RFAM_DIR, version=RFAM_VERSION)
@test isfile(FULL_FASTA_FILE)

# Tests
module esl_afetch_tests include("esl_afetch.jl") end
module esl_reformat_tests include("esl_reformat.jl") end

module cmfetch_tests include("cmfetch.jl") end
module cmalign_tests include("cmalign.jl") end
module cmbuild_tests include("cmbuild.jl") end
module cmemit_tests include("cmemit.jl") end
module cmsearch_tests include("cmsearch.jl") end
