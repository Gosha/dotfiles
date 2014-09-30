# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_CUSTOM=~/.dotfiles
ZSH_THEME="mine"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

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
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git cp jump ssh-agent colored-man themes rvm)

#HOST=meronpan

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
# zstyle ':completion:*' completions 1
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' glob 1
# zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# zstyle ':completion:*' max-errors 2 numeric
# zstyle ':completion:*' preserve-prefix '//[^/]##/'
# zstyle ':completion:*' prompt '%e <<<'
# zstyle ':completion:*' substitute 1
# zstyle :compinstall filename '/home/gosha/.zshrc'

# autoload -Uz compinit
# compinit
# End of lines added by compinstall


# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
setopt appendhistory beep extendedglob nomatch notify
setopt nullglob
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

alias l='ls -lah'
DF="$HOME/.dotfiles"

source "$DF/copying.sh"

alias aplay="bash $DF/anime.sh aplay"
alias findanime='bash $DF/anime.sh findanime'
alias aniplay='bash $DF/anime.sh aniplay'
alias ymp='bash $DF/youtube.sh ymp'
alias bpl='bash $DF/beeg.sh bpl'

PATH="$PATH:/home/gosha/bin"

ANDROID_HOME=/home/gosha/android_sdk
PATH="$PATH:/home/gosha/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools"

TERM=xterm-256color

EDITOR=ecnw

##PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
##[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
