import Rfam
using Test: @test, @testset
using Infernal: cmfetch

@testset "cmfetch" begin
    result = cmfetch(Rfam.cm(), "RF00162")
    @test isfile(result.out)
    @test isfile(result.stdout)
    @test isfile(result.stderr)
end
