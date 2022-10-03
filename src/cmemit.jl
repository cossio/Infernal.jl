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
    run(`$cmd -N $N --exp $exp --tfile $tfile -o $out $cmfile`)
    return (; out, tfile)
end

#cmemit -N 10000 -o "$DATA/$RF.enone.emit.exp1.afa" --exp 1 -a --outformat AFA "$DATA/$RF.enone.cm"
