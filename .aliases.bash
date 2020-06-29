
alias l="ls -lh"
alias ll="ls -lai"

alias encaru="enca -L ru_RU.UTF-8"
alias enconvru="enconv -L ru_RU.UTF-8"

#alias gwin="gvim -S $HOME/.vim/cp1251.vim"
#alias vwin="vim +'e ++enc=cp1251'"

alias tstamp="gawk '{ print strftime(\"[%Y-%m-%d %H:%M:%S]\"), \$0 }'"

alias find-sort-by-mtime="find -type f -printf '%A@ %p\\n' | sort -n"

alias rg-less="rg --color always --heading -n numbered"
alias rg-src="rg --iglob '!/build' --iglob '!/tags'"

# skype sandbox
#alias skype-secure='xhost +local: && su skype -c /opt/bin/skype'
