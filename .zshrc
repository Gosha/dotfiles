[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile


export DF="$( cd "$( dirname "${(%):-%x}" )" >/dev/null 2>&1 && pwd )"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_CUSTOM=$DF/.dotfiles-aux
ZSH_THEME="mine"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git
    # colored-man-pages # This seems to be the default on most systems
    cp
    jump
    themes
)

source $ZSH/oh-my-zsh.sh

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
# End of lines added by compinstall


HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory beep extendedglob nomatch notify
setopt nullglob
unsetopt autocd
bindkey -e

if type exa > /dev/null; then
    alias l='exa -la --git'
    alias lt='exa -T'
else
    alias l='ls -lah'
    alias lt='tree .'
fi

function E() {
    filename=$1
    without_beg_slash="${1##/}"
    if [[ $without_beg_slash == $1 ]];then
        filename="${PWD%//}/$1"
    fi
    emacsclient -a emacs "/sudo:root@localhost:$filename"
}

TERM=xterm-256color

# fzf-completion when installed with nix
# See: https://nixos.wiki/wiki/Fzf
if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

# fzf-completion when installed without nix
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Restore Ctrl-T
bindkey "^T" transpose-chars
bindkey '^F' fzf-file-widget

# Allow overiding settings on current machine
[[ -f $HOME/.commonrc ]] && source $HOME/.commonrc
[[ -f $HOME/.this-zshrc ]] && source $HOME/.this-zshrc
