using Test: @test, @testset
using Infernal: cmsearch
import ..CM_FILE, ..FULL_FASTA_FILE

@testset "cmsearch" begin
    MINI_FASTA_FILE, MINI_FASTA_IO = mktemp()
    for line in readlines(FULL_FASTA_FILE)[1:10]
        write(MINI_FASTA_IO, line)
    end
    close(MINI_FASTA_IO)
    result = cmsearch(CM_FILE, MINI_FASTA_FILE)
    @test isfile(result.out)
    @test isfile(result.stdout)
    @test isfile(result.stderr)
end
