function esl_afetch(
    msafile::AbstractString, key::AbstractString
)
    cmd = `$(Infernal_jll.esl_afetch())`
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $msafile $key`; stdout, stderr, append=false))
    return (; out, stdout, stderr)
end
