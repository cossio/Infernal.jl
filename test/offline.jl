using Test: @test, @test_throws, @testset
using Infernal: cmalign, cmalign_parse_sfile, cmcalibrate, cmemit, cmfetch, cmbuild,
    cmsearch, cmsearch_parse_tblout, esl_afetch, esl_reformat

function write_simple_stockholm(tempdir::AbstractString)
    stockholm = joinpath(tempdir, "hairpin.sto")
    write(stockholm, """
# STOCKHOLM 1.0
#=GF ID hairpin
seq1         GGGAAACCC
seq2         GGGAAACCC
#=GC SS_cons (((...)))
//
""")
    return stockholm
end

function write_simple_fasta(tempdir::AbstractString)
    fasta = joinpath(tempdir, "hairpin.fa")
    write(fasta, """
>s1
GGGAAACCC
>s2
GGGAAACCC
""")
    return fasta
end

@testset "offline parsing" begin
    mktempdir() do tempdir
        sfile = joinpath(tempdir, "cmalign.sfile")
        write(sfile, """
# cmalign summary
1 seq1 75 1 75 no 42.0 0.98 0.01 0.02 0.03 1.5
2 seq2 80 2 79 yes 39.5 0.87 0.11 0.22 0.33 2.5
""")

        df = cmalign_parse_sfile(sfile)
        @test size(df) == (2, 12)
        @test names(df) == [
            "idx", "seq_name", "length", "cm_from", "cm_to", "trunc", "bit_sc", "avg_pp",
            "band_calc", "alignment", "total", "mem_Mb"
        ]
        @test df.seq_name == ["seq1", "seq2"]
        @test df.cm_from == [1, 2]
        @test df.avg_pp == [0.98, 0.87]

        tblout = joinpath(tempdir, "cmsearch.tblout")
        write(tblout, """
# cmsearch table
seq1 acc1 query1 acc2 cm 1 75 5 79 + no 1 0.45 0.10 42.3 1e-9 ! desc_one
seq2 - query1 - cm 2 70 9 77 - yes 2 0.40 0.20 35.1 2e-4 ? desc_two
""")

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

        empty_sfile = joinpath(tempdir, "cmalign-empty.sfile")
        write(empty_sfile, "# cmalign summary\n")
        @test size(cmalign_parse_sfile(empty_sfile)) == (0, 12)

        empty_tblout = joinpath(tempdir, "cmsearch-empty.tblout")
        write(empty_tblout, "# cmsearch table\n")
        @test size(cmsearch_parse_tblout(empty_tblout)) == (0, 18)
    end
end

@testset "offline local workflow" begin
    mktempdir() do tempdir
        stockholm = write_simple_stockholm(tempdir)
        fasta = write_simple_fasta(tempdir)
        fasta_sequences(path::AbstractString) = filter!(
            !isempty, [strip(line) for line in eachline(path) if !startswith(line, ">")]
        )
        default_emit_count = 3
        default_emit_exp = 1.5
        aligned_emit_count = 2
        aligned_emit_exp = 2

        fetched_alignment = esl_afetch(stockholm, "hairpin")
        @test all(isfile, [fetched_alignment.out, fetched_alignment.stdout, fetched_alignment.stderr])
        fetched_alignment_text = read(fetched_alignment.out, String)
        @test occursin("#=GF ID hairpin", fetched_alignment_text)
        @test occursin("seq1         GGGAAACCC", fetched_alignment_text)
        @test occursin("#=GC SS_cons (((...)))", fetched_alignment_text)

        build = cmbuild(fetched_alignment.out; informat="Stockholm")
        @test all(isfile, [build.cmout, build.stdout, build.stderr, build.o, build.O])
        @test filesize(build.cmout) > 0

        fetched_model = cmfetch(build.cmout, "hairpin")
        @test all(isfile, [fetched_model.out, fetched_model.stdout, fetched_model.stderr])
        @test occursin("NAME     hairpin", read(fetched_model.out, String))

        reformatted = esl_reformat("AFA", fetched_alignment.out; informat="Stockholm")
        @test all(isfile, [reformatted.out, reformatted.stdout, reformatted.stderr])
        @test read(reformatted.out, String) == ">seq1\nGGGAAACCC\n>seq2\nGGGAAACCC\n"

        emitted = cmemit(fetched_model.out; N=default_emit_count, exp=default_emit_exp)
        @test all(isfile, [emitted.out, emitted.stdout, emitted.stderr, emitted.tfile])
        emitted_sequences = fasta_sequences(emitted.out)
        @test length(emitted_sequences) == default_emit_count
        @test all(seq -> length(seq) == 9, emitted_sequences)
        @test all(seq -> all(c -> c in "ACGU", seq), emitted_sequences)

        emitted_aligned = cmemit(
            fetched_model.out;
            N=aligned_emit_count, exp=aligned_emit_exp, aligned=true, outformat="AFA"
        )
        @test all(isfile, [emitted_aligned.out, emitted_aligned.stdout, emitted_aligned.stderr, emitted_aligned.tfile])
        emitted_aligned_sequences = fasta_sequences(emitted_aligned.out)
        @test length(emitted_aligned_sequences) == aligned_emit_count
        @test all(seq -> length(seq) == 9, emitted_aligned_sequences)
        @test all(seq -> all(c -> c in "ACGU", seq), emitted_aligned_sequences)

        aligned = cmalign(
            fetched_model.out, fasta;
            glob=true, notrunc=true, informat="FASTA", outformat="Stockholm", matchonly=true
        )
        @test all(isfile, [aligned.out, aligned.stdout, aligned.stderr, aligned.tfile, aligned.sfile])
        aligned_df = cmalign_parse_sfile(aligned.sfile)
        @test size(aligned_df) == (2, 12)
        @test aligned_df.seq_name == ["s1", "s2"]
        @test aligned_df.cm_from == [1, 1]
        @test aligned_df.cm_to == [9, 9]
        @test aligned_df.avg_pp == [1.0, 1.0]

        calibrated = cmcalibrate(fetched_model.out)
        @test all(isfile, [calibrated.stdout, calibrated.stderr])

        search_top = cmsearch(fetched_model.out, fasta; toponly=true, notrunc=true)
        @test all(isfile, [search_top.out, search_top.stdout, search_top.stderr, search_top.A, search_top.tblout])
        search_top_df = cmsearch_parse_tblout(search_top.tblout)
        @test size(search_top_df) == (2, 18)
        @test search_top_df.target_name == ["s1", "s2"]
        @test search_top_df.query_name == ["hairpin", "hairpin"]
        @test all(search_top_df.E_value .< 1e-4)

        search_bottom = cmsearch(fetched_model.out, fasta; bottomonly=true)
        @test all(isfile, [search_bottom.out, search_bottom.stdout, search_bottom.stderr, search_bottom.A, search_bottom.tblout])
        @test size(cmsearch_parse_tblout(search_bottom.tblout)) == (0, 18)
    end
end

@testset "offline command errors" begin
    mktempdir() do tempdir
        missing = joinpath(tempdir, "missing")

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
end
