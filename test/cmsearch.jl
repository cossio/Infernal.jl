import Rfam
using Test: @test, @testset
using Infernal: cmsearch

@testset "cmsearch" begin
    MINI_FASTA_FILE, MINI_FASTA_IO = mktemp()
    for line in readlines(Rfam.fasta_file("RF00162"))[1:10]
        write(MINI_FASTA_IO, line)
    end
    close(MINI_FASTA_IO)
    result = cmsearch(Rfam.cm(), MINI_FASTA_FILE)
    @test isfile(result.out)
    @test isfile(result.stdout)
    @test isfile(result.stderr)
end
