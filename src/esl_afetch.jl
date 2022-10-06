function esl_afetch(
    msafile::AbstractString, key::AbstractString
)
    exe = infernal_binary("esl-afetch")
    cmd = `$exe`
    out = tempname()
    log = tempname()
    err = tempname()
    run(pipeline(`$cmd -o $out $msafile $key`; stdout=log, stderr=err, append=false))
    return (; out, log, err)
end
