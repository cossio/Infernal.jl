function esl_afetch(
    msafile::AbstractString, key::AbstractString
)
    exe = infernal_binary("esl-afetch")
    cmd = `$exe`
    out = tempname()
    run(`$cmd -o $out $msafile $key`)
    return (; out)
end
