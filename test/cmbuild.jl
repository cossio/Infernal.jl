using Test: @test, @testset
using Infernal: cmbuild, esl_afetch
import ..RFAM_SEED

@testset "cmbuild" begin
    seed = esl_afetch(RFAM_SEED, "RF00162")
    results = cmbuild(seed.out)
    @test isfile(results.cmout)
end
