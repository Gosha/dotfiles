# /etc/skel/.bashrc
#
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

# Colorful man-pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# I'm quite sure I actually use SCIM
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

EDITOR="emacsclient -c"
HISTCONTROL=ignoredups # Don't save identical items in history
HISTFILESIZE=2000
HISTSIZE=2000

PATH="$PATH:/home/gosha/bin"

##PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

##[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.

# Sabayon/Gentoo bash completion
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh

alias xpop='xprop | grep --color=none "WM_CLASS\|^WM_NAME" | xmessage -file -'
alias cdc='cd /media/c'
alias cdf='cd /media/f'
alias cdw='cd /var/www/localhost/htdocs/'
alias cds='cd /home/gosha/Dropbox/Skola/'

which colordiff > /dev/null 2>&1 && alias diff=colordiff


DF="$HOME/.dotfiles"

source "$DF/anime.sh"
source "$DF/youtube.sh"
source "$DF/wimp.sh"
source "$DF/beeg.sh"
source "$DF/gitstat.sh"
source "$DF/copying.sh"

#PS1='`date +%H:%M:%S`\[\e[0;30m\e[42m\] \w  \[\033[00m\] '
PS1='`date +%H:%M:%S`\[\e[0;30m\e[42m\] \w \[\033[00m\e[0;32m\] \[\e[0m\] '

THE_PROMPT="git"

function setPrompt () {
    case "$THE_PROMPT" in
        git)
            GITPROMPT=$(sh ~/gitstat.sh)
            PS1="\t$GITPROMPT \[\e[0;30m\e[42m\] \w \[\033[00m\e[0;32m\] \[\e[0m\] "
            ;;
        simple)
            PS1="\u@\h \w \$ "
            ;;
        standard)
            PS1="\t \[\e[0;30m\e[42m\] \w \[\033[00m\e[0;32m\] \[\e[0m\] "
    esac
}
PROMPT_COMMAND=setPrompt

# Some random auto ssh-agent script found on the internet.
GREP=/bin/grep
test=`/bin/ps -ef | $GREP ssh-agent | $GREP -v grep | /usr/bin/awk '{print $2}' | xargs`

if [ "$test" = "" ]; then
   # there is no agent running
   if [ -e "$HOME/agent.sh" ]; then
      # remove the old file
      /bin/rm -f $HOME/agent.sh
   fi;
   # start a new agent
   /usr/bin/ssh-agent | $GREP -v echo >&$HOME/agent.sh
fi;

test -e $HOME/agent.sh && source $HOME/agent.sh

alias kagent="kill -9 $SSH_AGENT_PID"
