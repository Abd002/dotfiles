# Ranger that leaves the shell in the last directory you browsed (zsh used ". ranger")
function r --wraps ranger --description 'ranger, cd to its last directory on exit'
    set -l tmp (mktemp)
    ranger --choosedir=$tmp $argv
    set -l dir (cat $tmp)
    rm -f $tmp
    if test -n "$dir"; and test "$dir" != "$PWD"
        cd $dir
    end
end
