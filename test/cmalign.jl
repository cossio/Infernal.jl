using Test: @test, @testset
import Infernal
import Rfam

@testset "infernal" begin
    @test isfile(Infernal.path("cmalign"))
    @test success(Infernal.exe("cmfetch", Rfam.cm(), "RF00162"))
end
