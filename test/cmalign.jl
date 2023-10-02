import Rfam
using Test: @test, @testset
using Infernal: cmfetch, cmalign, cmalign_parse_sfile

@testset "cmalign" begin
    cm = cmfetch(Rfam.cm(), "RF00162").out
    result = cmalign(cm, Rfam.fasta_file("RF00162"))
    @test isfile(result.out)
    @test isfile(result.stdout)
    @test isfile(result.stderr)
    @test isfile(result.sfile)
    @test isfile(result.tfile)
    df = cmalign_parse_sfile(result.sfile)
end
