using Test: @test, @testset
using Infernal: cmfetch, cmalign, cmalign_parse_sfile
import ..CM_FILE, ..RFAM_ID, ..FULL_FASTA_FILE

@testset "cmalign" begin
    cm = cmfetch(CM_FILE, RFAM_ID).out
    result = cmalign(cm, FULL_FASTA_FILE)
    @test isfile(result.out)
    @test isfile(result.sfile)
    @test isfile(result.tfile)
    df = cmalign_parse_sfile(result.sfile)
end
