# vim -> nvim
command -v nvim &> /dev/null && alias vim="nvim"

# Always use color with pacman and yay
alias pacman="pacman --color=always"
alias yay="yay --color=always"

# Configs
alias ezsh="$EDITOR $HOME/.zshrc"
alias evim="$EDITOR $HOME/.vimrc"
alias rzsh="ranger $HOME/.config/zsh-custom"
alias ri3="ranger $HOME/.config/i3"
alias szsh="source $HOME/.zshrc"

# ls
function _aliases_ls {
    # The first available app is used as the `ls` replacement.
    local ls_replacements=(
        "exa"
        "lsd"
    )
    local ls_alias=
    for ls_repl in "${ls_replacements[@]}"; do
        command -v "$ls_repl" &> /dev/null \
            && { ls_alias="$ls_repl"; break; }
    done
    [ -n "$ls_alias" ] && alias ls="$ls_alias"

    alias ll="ls -l"
    alias la="ls -la"

    # Append -h to vanilla ls
    [ -z "$ls_alias" ] && {
        alias ll="ls -lh"
        alias la="ls -lah"
    }
}; _aliases_ls; unfunction _aliases_ls

# git
alias gis="git status"
alias gip="git push"
alias gipf="git push --force"
alias gipu="git pull"
alias gipuf="git pull --force"
alias gipup="git push -u"
alias gif="git fetch --all"
alias gica="git add -A; git commit -m"
alias gicam="git add -A; git commit --amend"
alias gil="git log"
alias gi1="git log --oneline"
alias gitree="git log --oneline --decorate --graph --all"
alias gich="git checkout"

# cd
alias cd="cd_then_source"
alias cdd="cd $HOME/Downloads"
alias cdM="cd $HOME/misc"
alias cdp="cd $HOME/Pictures"
alias cds="cd $HOME/Pictures/Screenshots"
alias cdg="cd $HOME/Games"
alias cdc="cd $HOME/.config"
alias cdC="cd $HOME/conf"
alias cdi3="cd $HOME/.config/i3"
alias cdz="cd $HOME/.config/zsh-custom"
alias cdS="cd $HOME/Sync"
alias cdS="cd $HOME/Sync/General"

# ranger
alias ra="ranger"
alias rah="ranger $HOME"
alias rad="ranger $HOME/Downloads"
alias ram="ranger $HOME/misc"
alias rap="ranger $HOME/Pictures"
alias ras="ranger $HOME/Pictures/Screenshots"
alias rag="ranger $HOME/Games"
alias rac="ranger $HOME/.config"
alias raC="ranger $HOME/conf"
alias rai3="ranger $HOME/.config/i3"
alias raz="ranger $HOME/.config/zsh-custom"
alias raS="ranger $HOME/Sync"
alias raG="ranger $HOME/Sync/General"

# misc
alias psa="ps aux | grep -i"
alias cppa="cppath"
alias cdpa="cdpath"
alias vall="vimall"
# thunderbird date format
command -v "thunderbird" &> /dev/null && alias thunderbird='LC_TIME="C" thunderbird'
# cat -> bat
command -v "bat" &> /dev/null && alias cat="bat"