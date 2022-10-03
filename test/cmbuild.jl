using Test: @test, @testset
using Infernal: cmbuild
import ..SEED_FILE

@testset "cmbuild" begin
    results = cmbuild(SEED_FILE)
    @test isfile(results.cmout)
end
