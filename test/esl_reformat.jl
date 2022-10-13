using Test: @test, @testset
using Infernal: esl_reformat, esl_afetch
import ..RFAM_SEED

@testset "esl_reformat" begin
    seed = esl_afetch(RFAM_SEED, "RF00162")
    result = esl_reformat("AFA", seed.out)
    @test isfile(result.out)
    @test isfile(result.stdout)
    @test isfile(result.stderr)
end
