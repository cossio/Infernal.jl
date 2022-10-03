function esl_reformat(
    format::AbstractString, seqfile::AbstractString;
    informat::Opt{AbstractString}=nothing
)
    exe = infernal_binary("esl-reformat")
    cmd = `$exe`
    isnothing(informat) || (cmd = `$cmd --informat $informat`)
    out = tempname()
    run(`$cmd -o $out $format $seqfile`)
    return (; out)
end
