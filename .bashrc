# Test for an interactive shell. There is no need to set anything past this point for scp and rcp.
if [[ $- != *i* ]] ; then return ; fi

if [[ -f /etc/profile ]] ; then . /etc/profile ; fi

HISTCONTROL="ignoreboth:ignorespace"
HISTSIZE=10000
HISTFILESIZE=10000

shopt -s histappend
shopt -s checkwinsize

## make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

PROMPT_COMMAND='echo -ne "\033]0;[${USER}@${HOSTNAME}]:${PWD}\007"'

__get_PS1() {
  local bldred='\e[1;31m' # Red
  local bldgrn='\e[1;32m' # Green
  local bldylw='\e[1;33m' # Yellow
  local bldblu='\e[1;34m' # Blue
  #local bldpur='\e[1;35m' # Purple
  #local bldcyn='\e[1;36m' # Cyan
  #local txtred='\e[0;31m' # Red
  #local txtgrn='\e[0;32m' # Green
  #local txtylw='\e[0;33m' # Yellow
  #local txtblu='\e[0;34m' # Blue
  #local txtpur='\e[0;35m' # Purple
  local txtcyn='\e[0;36m' # Cyan
  local txtrst='\e[0m'    # Text Reset

  # use different colors for root and others
  local user_color="$txtcyn"
  if [[ $EUID == 0 ]]; then user_color="$bldred" ; fi

  echo -n "\[$bldylw\][[ \
\[$user_color\]\u\[$txtrst\]@\[$bldgrn\]\h\[$txtrst\] \
\[$bldblu\]\w\[$bldylw\] ]]\[$txtrst\] "
}

PS1="$(__get_PS1)"

unset __get_PS1

export DEFAULT_CHARSET="UTF-8"
export PATH="$PATH:$HOME/bin"
export LANG="en_US.utf-8"
export EDITOR="vim"

source_scripts() {
  local s
  for s in "$@"; do
    if [[ -r "$s" ]]; then . "$s"; fi
  done
}

source_scripts \
  ~/.aliases.bash \
  ~/.bash_scripts/local.sh \
  ~/.bash_scripts/roc.sh

# Colorful man pages.
man() {
  env LESS_TERMCAP_mb=$'\e[1;31m' \
      LESS_TERMCAP_md=$'\e[1;31m' \
      LESS_TERMCAP_me=$'\e[0m' \
      LESS_TERMCAP_se=$'\e[0m' \
      LESS_TERMCAP_so=$'\e[1;44;33m' \
      GROFF_NO_SGR=1 \
      man "$@"
}

# tilix
tilix_vte_file="$( find /etc/profile.d/ -name 'vte*.sh' | sort | tail -1 )"
if [[ -e "$tilix_vte_file" && ( -n "$TILIX_ID" || -n "$VTE_VERSION" ) ]]; then
  . "$tilix_vte_file"
fi

#~NIX_PATH="$NIX_PATH:$HOME/nix/nixpkgs"

###

# Remove duplicates from PATH
PATH=$( echo "$PATH" | awk -F: '{for (i=1;i<=NF;i++) { if (!x[$i]++) printf("%s:",$i); }}' | sed -re 's/:+$//' )
