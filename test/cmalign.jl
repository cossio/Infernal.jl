using Test: @test, @testset
import Infernal

@testset "cmalign" begin
    @test isfile(Infernal.path("cmalign"))
    @test success(Infernal.exe("cmfetch", Rfam.cm(), "RF00162"))
end
