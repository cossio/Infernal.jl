import Rfam
Rfam.set_rfam_directory(tempdir())
Rfam.set_rfam_version("14.8")

# Tests
module aqua_tests include("aqua.jl") end

module esl_afetch_tests include("esl_afetch.jl") end
module esl_reformat_tests include("esl_reformat.jl") end

module cmfetch_tests include("cmfetch.jl") end
module cmalign_tests include("cmalign.jl") end
module cmbuild_tests include("cmbuild.jl") end
module cmemit_tests include("cmemit.jl") end
module cmsearch_tests include("cmsearch.jl") end
