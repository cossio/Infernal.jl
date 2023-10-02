import Rfam
using Test: @test, @testset
using Infernal: cmbuild, esl_afetch

@testset "cmbuild" begin
    seed = esl_afetch(Rfam.seed(), "RF00162")
    results = cmbuild(seed.out)
    @test isfile(results.cmout)
    @test isfile(results.stdout)
    @test isfile(results.stderr)

    results = cmbuild(seed.out; informat="Stockholm")
    @test isfile(results.cmout)
    @test isfile(results.stdout)
    @test isfile(results.stderr)
end
