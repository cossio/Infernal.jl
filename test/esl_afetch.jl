using Test: @test, @testset
using Infernal: esl_afetch
import ..RFAM_SEED

@testset "esl_afetch" begin
    result = esl_afetch(RFAM_SEED, "RF00162")
    @test isfile(result.out)
    @test isfile(result.log)
    @test isfile(result.err)
end
