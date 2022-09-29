using SafeTestsets: @safetestset

@time @safetestset "cmfetch" begin include("cmfetch.jl") end
@time @safetestset "cmalign" begin include("cmalign.jl") end
