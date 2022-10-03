using Test: @test, @testset
using Infernal: cmfetch, cmalign, cmalign_parse_sfile
import ..CM_FILE, ..FULL_FASTA_FILE

@testset "cmalign" begin
    cm = cmfetch(CM_FILE, "RF00162").out
    result = cmalign(cm, FULL_FASTA_FILE)
    @test isfile(result.out)
    @test isfile(result.sfile)
    @test isfile(result.tfile)
    df = cmalign_parse_sfile(result.sfile)
end
