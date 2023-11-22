module Infernal

import CSV
import Infernal_jll
using DataFrames: DataFrame

#using Artifacts: @artifact_str
#include("util.jl")

const Opt{T} = Union{Nothing,T}

include("cmfetch.jl")
include("cmalign.jl")
include("cmbuild.jl")
include("cmemit.jl")
include("cmcalibrate.jl")
include("cmsearch.jl")

include("esl_reformat.jl")
include("esl_afetch.jl")

end
