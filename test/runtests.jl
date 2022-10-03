using Test: @test, @testset, @inferred
using Downloads: download
import Gzip_jll

# decompress a gzipped file
gunzip(file::String) = run(`$(Gzip_jll.gzip()) -d $file`)

function read_seed(file::AbstractString, name::AbstractString)
    stk = String[]
    current_name = ""
    for line in eachline(file)
        if line == "# STOCKHOLM 1.0"
            empty!(stk)
        end
        push!(stk, line)
        if startswith(line, "#=GF AC")
            words = split(line)
            @assert length(words) == 3 && startswith(words[3], "RF")
            current_name = words[3]
        end
        if line == "//" && current_name == name
            return stk
        end
    end
end

const RFAM_ID = "RF00162" # Family we will use in tests
const RFAM_VERSION = "14.8"

@info "Downloading Rfam.cm ..."
const CM_FILE = tempname()
download("https://ftp.ebi.ac.uk/pub/databases/Rfam/14.8/Rfam.cm.gz", CM_FILE * ".gz")
gunzip(CM_FILE * ".gz")
@test isfile(CM_FILE)

@info "Downloading all seed alignments ..."
const ALL_SEEDS_FILE = tempname()
download("https://ftp.ebi.ac.uk/pub/databases/Rfam/$RFAM_VERSION/Rfam.seed.gz", ALL_SEEDS_FILE * ".gz")
gunzip(ALL_SEEDS_FILE * ".gz")
@test isfile(ALL_SEEDS_FILE)

@info "Extract seed alignment of $RFAM_ID ..."
const SEED_FILE = tempname()
let stk = read_seed(ALL_SEEDS_FILE, RFAM_ID)
    open(SEED_FILE, "w") do io
        for line in stk
            write(io, line * '\n')
        end
    end
end

@info "Downloading $RFAM_ID hit sequences ..."
const FULL_FASTA_FILE = tempname()
download(
    "https://ftp.ebi.ac.uk/pub/databases/Rfam/$RFAM_VERSION/fasta_files/$RFAM_ID.fa.gz",
    FULL_FASTA_FILE * ".gz"
)
gunzip(FULL_FASTA_FILE * ".gz")
@test isfile(FULL_FASTA_FILE)

# Tests
module cmfetch_tests include("cmfetch.jl") end
module cmalign_tests include("cmalign.jl") end
module cmbuild_tests include("cmbuild.jl") end
module cmemit_tests include("cmemit.jl") end

module esl_reformat_tests include("esl_reformat.jl") end
