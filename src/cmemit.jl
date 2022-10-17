function cmemit(
    cmfile::AbstractString;
    N::Int = 10, exp::Real = 1, aligned::Bool=false,
    outformat::Opt{AbstractString}=nothing
)
    exe = infernal_binary("cmemit")
    cmd = `$exe`
    aligned && (cmd = `$cmd -a`)
    isnothing(outformat) || (cmd = `$cmd --outformat $outformat`)
    out = tempname()
    tfile = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -N $N --exp $exp --tfile $tfile -o $out $cmfile`; stdout, stderr))
    return (; out, stdout, stderr, tfile)
end
