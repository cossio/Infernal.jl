using SafeTestsets: @safetestset

@time @safetestset "cmd" begin include("cmd.jl") end
