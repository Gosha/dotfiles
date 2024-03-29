# Pretty much pargs of the agnoster theme with a few changes

autoload -U colors && colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn

if [[ "$HOST" == "meronpan" ]] {
   BGC=cyan
} elif [[ "$HOST" == "Goshas-MBP.lan" ]] {
   BGC=yellow
} elif [[ "$WSL_DISTRO_NAME" =~ "Ubuntu" ]] {
   BGC=166 # Ubuntu-ish color
} else {
   BGC=blue
}

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats "%b %c%u"
    } else {
        zstyle ':vcs_info:*' formats "%b %c%u%F{red}●"
    }
    vcs_info
}

prompt_docker() {
  if [[ ! -z $DOCKER_MACHINE_NAME ]] {
    prompt_segment green white $DOCKER_MACHINE_NAME
  }
}

prompt_date() {
    prompt_segment 0 "" "%D{%H:%M:%S}"
}

prompt_git() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
      PL_BRANCH_CHAR=$'\ue0a0' # 
      prompt_segment 8 white "${PL_BRANCH_CHAR} ${vcs_info_msg_0_}"
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "`basename $virtualenv_path`"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%F{red}✘%f"
  [[ $UID -eq 0 ]] && symbols+="%F{yellow}⚡%f"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%F{cyan}⚙%f"

  [[ -n "$symbols" ]] && echo -n "$symbols"
}

prompt_dir() {
    prompt_segment $BGC black "%~"
}

VIRTUAL_ENV_DISABLE_PROMPT=1
build_prompt() {
    RETVAL=$?
    prompt_status
    prompt_date
    prompt_virtualenv
    prompt_git
    prompt_docker
    prompt_dir
    prompt_end
}

PROMPT=$'%{%f%b%k%}$(build_prompt)%-30(l::\n$) '

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
