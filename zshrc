# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt PROMPT_SUBST

function git_prompt_vars {
  PROMPT_DIRTY='%F{red}✗%f'
  PROMPT_CLEAN='%F{green}✓%f'
  PROMPT_PREFIX='%F{253}|'
  PROMPT_SUFFIX='%F{253}|'
  GIT_BEHIND_CHAR='%F{red}↓'
  GIT_AHEAD_CHAR='%F{green}↑'
  GIT_STASH=''
  GIT_AHEAD=''
  GIT_BEHIND=''

  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
    local git_status="$(git status -b --porcelain 2> /dev/null || git status --porcelain 2> /dev/null)"
    if [[ -n "${git_status}" ]] && [[ "${git_status}" != "\n" ]] && [[ -n "$(grep -v ^# <<< "${git_status}")" ]]; then
      GIT_STATE=$PROMPT_PREFIX$PROMPT_DIRTY$PROMPT_SUFFIX
    else
      GIT_STATE=$PROMPT_PREFIX$PROMPT_CLEAN$PROMPT_SUFFIX
    fi
    local ref=$(git symbolic-ref -q HEAD 2> /dev/null)
    if [[ -n "$ref" ]]; then
      BRANCH=${ref#refs/heads/}
    else
      BRANCH=$(git describe --tags --exact-match 2> /dev/null)
    fi

    local ahead_re='.+ahead ([0-9]+).+'
    local behind_re='.+behind ([0-9]+).+'
    [[ "${git_status}" =~ ${ahead_re} ]] && GIT_AHEAD="${GIT_AHEAD_CHAR}${BASH_REMATCH[1]}"
    [[ "${git_status}" =~ ${behind_re} ]] && GIT_BEHIND="${GIT_BEHIND_CHAR}${BASH_REMATCH[1]}"
    local stash_count="$(git stash list 2> /dev/null | wc -l | tr -d ' ')"
    [[ "${stash_count}" -gt 0 ]] && GIT_STASH="{${stash_count}}"


    GPS=$BRANCH$GIT_STATE$GIT_AHEAD$GIT_BEHIND$GIT_STASH
    #%B%F{white}%b'
  else
      #This cleans the non zero return code if not in GIT repo, usefull when using sterred
    w &> /dev/null
    GPS=''
  fi
}

git_prompt_vars

NEWLINE=$'\n'
PROMPT='%(!.%F{red}.%F{green})┌─[%n%f@%F{blue}%m:%F{white}$GPS%F{220}%~%F{green}]${NEWLINE}%F{green}└─%#%f '

