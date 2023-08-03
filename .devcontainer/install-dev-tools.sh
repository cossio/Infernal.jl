# julia (juliaup)
curl -fsSL https://install.julialang.org | sh -s -- --yes

# rye
curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes" bash
echo 'source "$HOME/.rye/env"' > .profile