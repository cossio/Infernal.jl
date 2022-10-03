using Test: @test, @testset
using Infernal: cmemit, cmfetch
using BioSequences: LongRNA
import FASTX
import ..CM_FILE, ..RFAM_ID

@testset "cmemit" begin
    N = 17
    cm = cmfetch(CM_FILE, RFAM_ID).out
    result = cmemit(cm; aligned=true, outformat="AFA", N)
    @test isfile(result.out)
    @test isfile(result.tfile)
    sequences = open(FASTX.FASTA.Reader, result.out) do reader
        strs = FASTX.sequence.(reader)
        no_inserts = map(strs) do str
            filter(!islowercase, replace(str, '.' => ""))
        end
        LongRNA{4}.(no_inserts)
    end
    @test length(sequences) == 17
    @test allequal(length.(sequences))
end
