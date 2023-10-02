import Aqua
import Infernal
using Test: @testset

@testset verbose = true "aqua" begin
    Aqua.test_all(Infernal; ambiguities = false)
end
