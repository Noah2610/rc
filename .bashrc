# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
		export PSD=$PS1
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# NOAH preferences
export TERM="xterm-256color"  # for tmux vim colorscheme
stty -ixon  # disable ctrl-s freeze in terminal
# set vim like terminal control
set -o vi
# export vars
# set default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# reset PS1 after input
trap 'echo -ne "\e[0m"' DEBUG

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# ranger env var:
export RANGER_LOAD_DEFAULT_RC=false

# java jdk environment variables and path:
#export JAVA_HOME="/usr/lib/jvm/java-9-openjdk-amd64/bin/java"
#export JAVA_HOME="/usr/bin/java"
export JAVA_HOME="/usr/lib/jvm/java-9-openjdk-amd64"
export PATH="$PATH:/usr/lib/jvm/java-9-openjdk-amd64/bin"
# sdk-android environment variables and path:
export ANDROID_HOME="$HOME/SDK-tools"
export PATH="$PATH:$ANDROID_HOME/tools"

# set default terminal emulator for i3
#export TERMINAL="termite"


# PS stuff
# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white

	export PS2=$RS$HC$FBLE'> '$RS
	export PSp=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$RS$FGRN'@\h'$RS':'$HC$FBLE'\w'$FWHT'\$ '$RS
	export PSp2=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$RS$FGRN'@\h'$RS':'$HC$FBLE'\w	'$RS$UL$FWHT'\t\n'$RS$HC$FRED'\$ '$RS

	export PSp3=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$RS$FGRN'@\h'$RS':'$HC$FBLE'\w	'$RS$UL$FWHT'\t\n'$RS$HC$FWHT'\$ '$RS
	# blue input:
	#export PSp3=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$RS$FGRN'@\h'$RS':'$HC$FBLE'\w	'$RS$UL$FWHT'\t\n'$RS$HC$FWHT'\$ '"$RS$HC$FBLE"  #\[\033[35m\]"

	export PSs=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$FWHT'\$ '$RS
	export PSs2=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u '$RS$UL$FWHT'\t\n'$RS$HC$FRED'\$ '$RS
	export PSs3=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u '$RS$UL$FWHT'\t\n'$RS$HC$FWHT'\$ '$RS
	export PSm=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$RS':'$HC$FBLE'\w'$FWHT'\$ '$RS
	export PSm2=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$RS':'$HC$FBLE'\w	'$RS$UL$FWHT'\t\n'$RS$HC$FRED'\$ '$RS
	export PSm3=${debian_chroot:+($debian_chroot)}$RS$HC$FGRN'\u'$RS':'$HC$FBLE'\w	'$RS$UL$FWHT'\t\n'$RS$HC$FWHT'\$ '$RS
export PS1="${PSp3}"
export PSusing="PSp3"


