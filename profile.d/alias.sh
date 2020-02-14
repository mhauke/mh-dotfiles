if [ "$(uname)" == "Darwin" ]; then
  # Do something under Mac OS X platform
  #Add colors
  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced
#elif [ $(uname) = "Linux" ]; then
#  export LS_OPTIONS=' --color=auto'
  #export GREP_OPTIONS='--color=auto'
fi



#Start with my aliasses
alias zshconfig="nano ~/.zshrc"
alias dusch="du -sch * | sort -k1 -h "
alias mhmux='tmux attach-session -t mh || tmux new-session -s mh'
alias g='git'
alias free="free -m"
alias df="df -h"
alias vi="vim"
alias ll="ls -hlF --time-style=long-iso"
alias la="ls -hAlF --time-style=long-iso"
alias mkdir="mkdir -p"
alias ..='cd ..' # Go up one directory
alias ...='cd ../..' # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias cpp='rsync --progress -ah'
alias doch='sudo "$BASH" -c "$(history -p !!)"'
alias ip='ip -color'
alias ips='ip -brief a'
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pod'
alias kgpw='kubectl get pod -o wide'
alias kgdep='kubectl get deployment'
alias kgsvc='kubectl get service'
alias kging='kubectl get ingress'
alias kgcm='kubectl get configmap'
alias kgsec='kubectl get secret'
alias kd='kubectl describe'
alias ka='kubectl apply -f'

# more advanced aliases for zsh
alias -s {yml,yaml}=vim
alias -s {json}=vim
alias -g G='| grep -i'
