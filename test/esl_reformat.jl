using Test: @test, @testset
using Infernal: esl_reformat
import ..SEED_FILE

@testset "esl_reformat" begin
    result = esl_reformat("AFA", SEED_FILE)
    @test isfile(result.out)
end
