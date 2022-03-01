[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

export DF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

HISTCONTROL=ignoredups # Don't save identical items in history
HISTSIZE=10000
SAVEHIST=10000
# Avoid duplicates
HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Sabayon/Gentoo bash completion
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh

#PS1='`date +%H:%M:%S`\[\e[0;30m\e[42m\] \w  \[\033[00m\] '
PS1='`date +%H:%M:%S`\[\e[0;30m\e[42m\] \w \[\033[00m\e[0;32m\] \[\e[0m\] '

THE_PROMPT="git"

function prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    echo " (`basename $virtualenv_path`)"
  fi
}

function setPrompt () {
    case "$THE_PROMPT" in
        git)
            GITPROMPT=$(bash $HOME/.dotfiles-aux/gitstat.sh)
            VENVPROMPT=$(prompt_virtualenv)
            VIRTUAL_ENV_DISABLE_PROMPT=1
            PS1="\t$VENVPROMPT$GITPROMPT \[\e[0;30m\e[42m\] \w \[\033[00m\e[0;32m\]\[\e[0m\] "
            ;;
        simple)
            PS1="\u@\h \w \$ "
            ;;
        standard)
            PS1="\t \[\e[0;30m\e[42m\] \w \[\033[00m\e[0;32m\]\[\e[0m\] "
    esac
}

PROMPT_COMMAND=setPrompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

function setup-oh-my-zsh {
  git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
  ZSH_PATH=$(which zsh)
  read -p "Set $ZSH_PATH as default shell? (Ctrl-C to exit)" -n 1 -r
  chsh -s $ZSH_PATH
}

# Set up ctrl-r with fzf for bash (without nix)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Allow overiding settings on current machine
[[ -f $HOME/.commonrc ]] && source $HOME/.commonrc
[[ -f $HOME/.this-bashrc ]] && source $HOME/.this-bashrc
