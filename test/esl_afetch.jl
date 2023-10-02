import Rfam
using Test: @test, @testset
using Infernal: esl_afetch

@testset "esl_afetch" begin
    result = esl_afetch(Rfam.seed(), "RF00162")
    @test isfile(result.out)
    @test isfile(result.stdout)
    @test isfile(result.stderr)
end
