module Infernal

using Pkg: @artifact_str
using DataFrames: DataFrame
import CSV

include("util.jl")
include("cmfetch.jl")
include("cmalign.jl")

end