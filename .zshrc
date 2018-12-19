# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt autocd extendedglob hist_ignore_all_dups
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

[[ -s /home/lealexis/.autojump/etc/profile.d/autojump.sh ]] && source /home/lealexis/.autojump/etc/profile.d/autojump.sh

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Gresham
unsetopt beep
export DOTBASE=$HOME
export WORKSPACE=$HOME/w
export DEPLOY=$HOME/deploy
export CCM_SNAPSHOTS_URL=https://nexus.greshamtech.com/content/repositories/ccm-snapshots/
export KUBE_NS=tempest

# Git
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"

export EDITOR=vim
export VISUAL=vim
source $DOTBASE/.zfuns/z_colours
source $DOTBASE/.zfuns/z_greek
export COLUMNS
export LINES

export LEIN_FAST_TRAMPOLINE=1

setopt prompt_subst
# export PROMPT='$(myzshprompt)'
export PROMPT="$FG_[yellow]\$(echo \${KUBE_NS:-%M})$RESET_ $FG_[green]\$(__git_ps1 '%s')$RESET_%# %B"
export RPROMPT='%~ %*'
preexec() {
  echo -n "$RESET"
}

bindkey \^U backward-kill-line
autoload -U select-word-style
select-word-style bash

autoload edit-command-line
zle -N edit-command-line
#bindkey '^e' edit-command-line
bindkey '^Xe' edit-command-line
bindkey '^X^e' edit-command-line
bindkey '^Xx' edit-command-line
bindkey '^X^X' edit-command-line

stty -ixon
unset KSH_ARRAYS

path[1,0]=(
  ~/.dotfiles/bin
  ~/localbin
  ~/bin
  ~/Dropbox/bin
  ~/go/bin
)

export VIMB=$DOTBASE/.vim/bundle
export GOPATH=~/go

# Completion
# . ~/w/tmuxinator/completion/tmuxinator.zsh
which jira > /dev/null 2>&1 && source <(jira --completion-script-zsh)

# Kubectl-fns
[[ -d ~/w/kubectl-fns ]] && . ~/w/kubectl-fns/zshrc
export HELM_HOME=~/.helm

# Git prompt + completion
source $HOME/.zsh/_git_ps1
fpath=($HOME/.zsh_fpath $fpath)
_git_co() { _git_checkout }

loadFnDir() {
  fpath+=$1
  for i in $1/*; do
    F="$(basename "$i")"
    unfunction $F > /dev/null 2>&1
    autoload $F
  done
}
loadFnDir $DOTBASE/.zfuns/funs

# Automatically enable my Python3 VE
if [[ -d "$HOME/pyve" ]]; then
  pyve
fi

# Pick values out of a prettytable
grok() {
    PAT=
    IX=1
    if [ -z "$2" ]; then
        if [[ $1 =~ ^[0-9]+$ ]]; then
            IX=$1
        else
            PAT=$1
        fi
    else
        PAT=$1
        IX=$2
    fi

    CMD="{print \$$(( $IX * 2 ))}"
    if [ -n "$PAT" ]; then
        CMD="/$PAT/ $CMD"
    fi
    awk "$CMD"
}

function w() { cd ~/w/$1 && title $1 }
function g() { cd ~/g/$1 }
function l() { command ls --color=always -CF $* }
function la() { l -a $* }
function ll() { l -l --block-size=M $* }
function lal() { ll -a $* }
function lu() { l -U $* }

function get() { sudo -E apt-get install $* }

function gti() { git "$@" }
function gvim () { (/usr/bin/gvim -f "$@" &) }

export MUSIC=$HOME/Music
function pause() { rhythmbox-client --play-pause }
function prev() { rhythmbox-client --previous }
function next() { rhythmbox-client --next }

function hup() { nohup "$@" > /dev/null 2>&1 & }
function tab() { sed 's/^/  /g' }
function vfind() { vim $(find "$@") }
# alias grep='f(){ echo "Tsk, use ag" }; f'
alias agc='ag --clojure'
function hi_ip() { egrep "[0-9]+\.[0-9]+|" --color=always $@ }

function vim() { nvim "$@" }
function vc() { ( cd "$(git rev-parse --show-toplevel)"; vim $(git ls "$@") ) }
function vcp() { ( cd "$(git rev-parse --show-toplevel)"; vim $(git ls "$@" | percol) ) }
function vs() { ( cd "$(git rev-parse --show-toplevel)"; vim $(git lss "$@") ) }
function vsp() { ( cd "$(git rev-parse --show-toplevel)"; vim $(git lss "$@" | percol) ) }
function vu() { ( cd "$(git rev-parse --show-toplevel)"; vim $(git untracked "$@") ) }
function vup() { ( cd "$(git rev-parse --show-toplevel)"; vim $(git untracked "$@" | percol) ) }
function pv() { vim $($@ | percol) }
function pon() { . proxy-on && "$@" }
function poff() { . proxy-off && "$@" }
function mkwheels() {
  for X in requirements.txt test-requirements.txt; do
    if [ -f "$X" ]; then
      pip wheel -r "$X"
    fi
  done
}
function pipdeps() {
  for X in `cat requirements.txt test-requirements.txt | sed 's/#.*//;/^$/d'`; do
    echo $X
    pip install $X
  done
}
function gits() {
  local short
  if [ "$1" = "1" ]; then
    short=1
    shift
  fi
  for X in `find -maxdepth 2 -name .git | cut -d/ -f2`; do
    if [ -z $short ]; then
      echo "-------------------- $X --------------------"
      git -C "$X" "$@"
    else
      echo "$X: $(git -C "$X" "$@")"
    fi
  done
}

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

export LPASS_AGENT_TIMEOUT=0
function lpass-login() { lpass login lastpass@lxsli.co.uk; }
function lpp() { lpass show -c --password $1; }
function lpp-github() { lpp github.com; }

#DROPBOX_STATUS=`dropbox status`
#if [[ "$DROPBOX_STATUS" != 'Up to date' ]]; then
#  dropbox start > /dev/null
#fi

function dockerid() {
  docker ps | awk "/$1/ {print \$1}"
}

function dex() {
  # Use "dex mitre-server opts -- bash", the -- is mandatory
  CONT="$1"
  shift
  OPTS=()
  while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--" ]]; then
      shift
      break
    else
      OPTS+=("$1")
      shift
    fi
  done
  CMD=(docker exec $OPTS -ti $(dockerid "$CONT") "$@")
  echo $CMD
  $CMD
}

# Leiningen
# export LEIN_FAST_TRAMPOLINE=y
# export LEIN_JAVA_CMD="$HOME/bin/drip"

function _w_cd { pushd ~/w >/dev/null; _cd "$@"; popd >/dev/null}
compdef _w_cd w

function title() {
  printf "\e]2;$*\a"
}

# vim: ts=2 sw=2 ft=zsh :
