"""
    path(name)

Path to Infernal binary `name`.
"""
path(name::String) = joinpath(artifact"Infernal", "infernal-1.1.4-linux-intel-gcc", "binaries", name)

"""
    cmd(name, [args...])

Returns a command to call an Infernal binary `name`.
"""
cmd(name::String, args...) = `$(path(name)) $args`

"""
    exe(name, [args...])

Runs the Infernal binary `name` with arguments `args`.
"""
exe(name::String, args...) = run(cmd(name, args...))
