# Config shared between bash+zsh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH="$PATH:$HOME/bin:$HOME/.local/bin"

alias gs='git status'

function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "$@"
}
