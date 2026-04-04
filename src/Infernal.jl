"""
    Infernal

Thin Julia wrappers around the command-line programs provided by
[Infernal](http://eddylab.org/infernal/).

The package does not export any symbols, so call the API as `Infernal.cmfetch(...)`
or import the functions you need explicitly.

Most wrapper functions execute an Infernal command, write its outputs to temporary
files, and return a named tuple with the generated paths.
"""
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
