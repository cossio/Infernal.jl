#=
# Infernal.jl usage example
=#

import Infernal
import Rfam

# Retrieve the path to Infernal programs

isfile(Infernal.path("cmalign"))

# Execute a command

success(Infernal.exe("cmfetch", Rfam.cm(), "RF00162"))
