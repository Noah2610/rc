# source a 'zshrc' file, if one is present in the current directory
function source_zshrc {
    [ -f "./zshrc" ] && source ./zshrc
}

# Try to source zshrc file if available
source_zshrc

# Change directory as usual with cd but execute function 'source_zshrc' afterwards
function cd_then_source {
    \cd $@
    exit_code=$?
    source_zshrc
    return $exit_code
}

# cd into directory with the current date
function cddatedir {
    local _dir="$( date "+%Y-%m-%d" )"
    [ -d "$_dir" ] && cd "$_dir"
}

# Save current directory to cdpath file.
# Use the `cdpath` function to then navigate into the stored cdpath.
function cppath {
    local cdpath_file="$CDPATH_FILE"
    [ -z "$cdpath_file" ] && cdpath_file="${HOME}/.cdpath"
    pwd > "$cdpath_file"
}

# cd into directory path stored in the cdpath file.
function cdpath {
    local cdpath_file="$CDPATH_FILE"
    [ -z "$cdpath_file" ] && cdpath_file="${HOME}/.cdpath"
    local cdpath_path=
    if [ -f "$cdpath_file" ]; then
        read -r cdpath_path < "$cdpath_file"
        [ -d "$cdpath_path" ] && cd_then_source "$cdpath_path"
    fi
    return 0
}

[ -n "$AUTO_CDPATH" ] && cdpath

# cheat
function cheat {
    \curl "cheat.sh/$1"
}

# git clone
function giclone {
    local repo="$1"
    shift
    git clone "git@github.com:${repo}" "$@"
}

# cdp
function cdp {
    local cdp_path="$HOME/Projects/Bash/cdp"
    [ -d "$cdp_path" ] || return 1
    local p="$( ${cdp_path}/cdp.sh "$@" )" || return 1
    [ -d "$p" ] && cd "$p"
}

# Run a command without saving it to the command history.
function nohist {
    local histfile="$HISTFILE"
    unset HISTFILE
    [ -f "$histfile" ] && sed -i '$d' "$histfile"

    $@

    HISTFILE="$histfile"
}

# mkdir directory and cd into it
function cdmk {
    local dir="$1"
    [ -z "$dir" ] && { \
        echo -e "mkdir DIR and cd into it\n    $0 DIR [mkdir-args...]"
        return 0
    }
    shift
    [ -d "$dir" ] || mkdir -p "$dir" "$@"
    cd "$dir"
}
