function esl_reformat(
    format::AbstractString, seqfile::AbstractString;
    informat::Opt{AbstractString}=nothing
)
    cmd = `$(Infernal_jll.esl_reformat())`
    isnothing(informat) || (cmd = `$cmd --informat $informat`)
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $format $seqfile`; stdout, stderr))
    return (; out, stdout, stderr)
end
