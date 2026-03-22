using Test: @test, @test_throws, @testset
using Infernal: cmalign, cmalign_parse_sfile, cmcalibrate, cmemit, cmfetch, cmbuild,
    cmsearch, cmsearch_parse_tblout, esl_afetch, esl_reformat

@testset "offline parsing" begin
    sfile, sfile_io = mktemp()
    write(sfile_io, """
# cmalign summary
1 seq1 75 1 75 no 42.0 0.98 0.01 0.02 0.03 1.5
2 seq2 80 2 79 yes 39.5 0.87 0.11 0.22 0.33 2.5
""")
    close(sfile_io)

    df = cmalign_parse_sfile(sfile)
    @test size(df) == (2, 12)
    @test names(df) == [
        "idx", "seq_name", "length", "cm_from", "cm_to", "trunc", "bit_sc", "avg_pp",
        "band_calc", "alignment", "total", "mem_Mb"
    ]
    @test df.seq_name == ["seq1", "seq2"]
    @test df.cm_from == [1, 2]
    @test df.avg_pp == [0.98, 0.87]

    tblout, tblout_io = mktemp()
    write(tblout_io, """
# cmsearch table
seq1 acc1 query1 acc2 cm 1 75 5 79 + no 1 0.45 0.10 42.3 1e-9 ! desc_one
seq2 - query1 - cm 2 70 9 77 - yes 2 0.40 0.20 35.1 2e-4 ? desc_two
""")
    close(tblout_io)

    df = cmsearch_parse_tblout(tblout)
    @test size(df) == (2, 18)
    @test names(df) == [
        "target_name", "accession", "query_name", "accession2",
        "mdl", "mdl_from", "mdl_to", "seq_from", "seq_to", "strand",
        "trunc", "pass", "gc", "bias", "score",
        "E_value", "inc", "description_of_target"
    ]
    @test df.target_name == ["seq1", "seq2"]
    @test df.score == [42.3, 35.1]
    @test df.description_of_target == ["desc_one", "desc_two"]
end

@testset "offline command errors" begin
    missing = joinpath(mktempdir(), "missing")

    @test_throws ProcessFailedException cmfetch(missing, "RF00162")
    @test_throws ProcessFailedException cmalign(
        missing, missing;
        glob=true, notrunc=true, informat="FASTA", outformat="Stockholm", matchonly=true
    )
    @test_throws ProcessFailedException cmbuild(missing; enone=true, informat="Stockholm")
    @test_throws ProcessFailedException cmemit(
        missing; N=1, exp=2, aligned=true, outformat="AFA"
    )
    @test_throws ProcessFailedException cmcalibrate(missing)
    @test_throws ProcessFailedException cmsearch(missing, missing; toponly=true, notrunc=true)
    @test_throws ProcessFailedException cmsearch(missing, missing; bottomonly=true)
    @test_throws ProcessFailedException esl_reformat("AFA", missing; informat="Stockholm")
    @test_throws ProcessFailedException esl_afetch(missing, "RF00162")
end
