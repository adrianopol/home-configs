# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

if [[ $- != *i* ]] ; then
  return
fi

[ -f /etc/profile ] && . /etc/profile

HISTCONTROL="ignoreboth:ignorespace"
HISTSIZE=2000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize

## make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#~if [[ -r /usr/share/git/git-prompt.sh ]]; then
#~  . /usr/share/git/git-prompt.sh
#~fi

PROMPT_COMMAND='echo -ne "\033]0;[${USER}@${HOSTNAME}]:${PWD}\007"'

get_PS1() {
  local bldblu='\e[1;34m' # Blue
  local bldgrn='\e[1;32m' # Green
  local bldred='\e[1;31m' # Red
  local bldylw='\e[1;33m' # Yellow
  local txtcyn='\e[0;36m' # Cyan
  local txtpur='\e[0;35m' # Purple
  local txtred='\e[0;31m' # Red
  local txtrst='\e[0m'    # Text Reset
  local txtylw='\e[0;33m' # Yellow

  # use different colors for root and others
  local user_color="$txtcyn"
  [[ $EUID == 0 ]] && user_color="$bldred"

  echo -n "\[$bldylw\][[ \
\[$user_color\]\u\[$txtrst\]@\[$bldgrn\]\h\[$txtrst\] \
\[$bldblu\]\w\[$bldylw\] ]]\[$txtrst\] "
}

PS1="$(get_PS1)"

export DEFAULT_CHARSET="UTF-8"
export PATH="$HOME/usr/bin:$PATH"
export LANG="en_US.utf-8"
export EDITOR="vim"

# Common aliases
[ -f ~/.aliases.bash ] && . ~/.aliases.bash

source_scripts() {
  local scripts="$@"
  for script in $scripts; do
    [ -r ~/.bash_scripts/$script ] && . ~/.bash_scripts/$script
  done
}

source_scripts local.sh ptsecurity.sh

# Colorful man pages.
man() {
  env LESS_TERMCAP_mb=$'\e[1;31m' \
      LESS_TERMCAP_md=$'\e[1;31m' \
      LESS_TERMCAP_me=$'\e[0m' \
      LESS_TERMCAP_se=$'\e[0m' \
      LESS_TERMCAP_so=$'\e[1;44;33m' \
      LESS_TERMCAP_ue=$'\e[0m' \
      LESS_TERMCAP_us=$'\e[1;32m' \
      GROFF_NO_SGR=1 \
      man "$@"
}

# Remove duplicates from PATH
PATH=$( echo $PATH | awk -F: '{for (i=1;i<=NF;i++) { if (!x[$i]++) printf("%s:",$i); }}' | sed -re 's/:+$//' )