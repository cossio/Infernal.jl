function esl_afetch(
    msafile::AbstractString, key::AbstractString
)
    exe = infernal_binary("esl-afetch")
    cmd = `$exe`
    out = tempname()
    stdout = tempname()
    stderr = tempname()
    run(pipeline(`$cmd -o $out $msafile $key`; stdout, stderr, append=false))
    return (; out, stdout, stderr)
end
