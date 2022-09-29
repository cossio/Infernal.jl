using Test: @test, @testset
using Downloads: download
using Infernal: cmfetch
import Gzip_jll

# decompress a gzipped file
gunzip(file::String) = Gzip_jll.gzip() do gzip
    run(`$gzip -d $file`)
end

@testset "cmfetch" begin
    cm = tempname()
    download("https://ftp.ebi.ac.uk/pub/databases/Rfam/14.8/Rfam.cm.gz", cm * ".gz")
    gunzip(cm * ".gz")
    @test isfile(cm)
    result = cmfetch(cm, "RF00162")
    @test isfile(result.out)
end
