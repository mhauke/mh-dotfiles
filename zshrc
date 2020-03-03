# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob autopushd pushdignoredups
unsetopt appendhistory beep nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Special Aliases for zsh
# more advanced aliases for zsh
alias -s {yml,yaml}=vim
alias -s {json}=vim
alias -g G='| grep -i'
alias d='dirs -v | head -10'
