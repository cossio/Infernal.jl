using Test: @test, @testset
using Infernal: cmfetch
import ..CM_FILE

@testset "cmfetch" begin
    result = cmfetch(CM_FILE, "RF00162")
    @test isfile(result.out)
end
