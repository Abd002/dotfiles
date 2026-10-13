# If poetry is installed and an environment exists, run "poetry run nvim"
function v --wraps nvim --description 'nvim, through poetry run inside poetry projects'
    if command -q poetry; and test -f poetry.lock
        poetry run nvim $argv
    else
        nvim $argv
    end
end
