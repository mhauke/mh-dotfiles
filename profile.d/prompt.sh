# Define color variables
Color_Off='\[\033[0m\]'         # Text Reset

# Regular Colors
Black='\[\033[0;30m\]'    # Black
Red='\[\033[0;31m\]'      # Red
Green='\[\033[0;32m\]'    # Green
Yellow='\[\033[0;33m\]'   # Yellow
Blue='\[\033[0;34m\]'     # Blue
Purple='\[\033[0;35m\]'   # Purple
Cyan='\[\033[0;36m\]'     # Cyan
White='\[\033[0;37m\]'    # White

# Bold
BBlack='\[\033[1;30m\]'   # Black
BRed='\[\033[1;31m\]'     # Red
BGreen='\[\033[1;32m\]'   # Green
BYellow='\[\033[1;33m\]'  # Yellow
BBlue='\[\033[1;34m\]'    # Blue
BPurple='\[\033[1;35m\]'  # Purple
BCyan='\[\033[1;36m\]'    # Cyan
BWhite='\[\033[1;37m\]'   # White

# new line
NEWLINE=$'\n'

function git_bash_prompt_vars {
  PROMPT_DIRTY=${BRed}'✗'${Color_Off}
  PROMPT_CLEAN=${BGreen}'✓'${Color_Off}
  PROMPT_PREFIX='|'
  PROMPT_SUFFIX=${BWhite}'|'
  GIT_BEHIND_CHAR=${Red}'↓'
  GIT_AHEAD_CHAR=${Green}'↑'
  GIT_STASH=''
  GIT_AHEAD=''
  GIT_BEHIND=''


  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
    local status="$(git status -b --porcelain 2> /dev/null || git status --porcelain 2> /dev/null)"
    if [[ -n "${status}" ]] && [[ "${status}" != "\n" ]] && [[ -n "$(grep -v ^# <<< "${status}")" ]]; then
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
    [[ "${status}" =~ ${ahead_re} ]] && GIT_AHEAD="${GIT_AHEAD_CHAR}${BASH_REMATCH[1]}"
    [[ "${status}" =~ ${behind_re} ]] && GIT_BEHIND="${GIT_BEHIND_CHAR}${BASH_REMATCH[1]}"
    local stash_count="$(git stash list 2> /dev/null | wc -l | tr -d ' ')"
    [[ "${stash_count}" -gt 0 ]] && GIT_STASH="{${stash_count}}"


    GPS="["$BRANCH$GIT_STATE$GIT_AHEAD$GIT_BEHIND$GIT_STASH"${BWhite}]"
  else
      #This cleans the non zero return code if not in GIT repo, usefull when using sterred
    w &> /dev/null 
    GPS=""
  fi
}

function git_zsh_prompt_vars {
  PROMPT_DIRTY='%F{red}✗%f'
  PROMPT_CLEAN='%F{green}✓%f'
  PROMPT_PREFIX='%F{253}|'
  PROMPT_SUFFIX='%F{253}|'
  GIT_BEHIND_CHAR='%F{red}↓'
  GIT_AHEAD_CHAR='%F{green}↑'
  GIT_STASH=''
  GIT_AHEAD=''
  GIT_BEHIND=''

  # enable bash_rematch in this function
  setopt local_options KSH_ARRAYS
  setopt local_options BASH_REMATCH

  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
    local git_status="$(git status -b --porcelain 2> /dev/null || git status --porcelain 2> /dev/null)"
    local git_grepstatus=$(grep -v "^#" <<< "${git_status}")
    if [[ -n "${git_status}" ]] && [[ "${git_status}" != "\n" ]] && [[ -n "${git_grepstatus}" ]]; then
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


    GPS="%F{white}[$BRANCH$GIT_STATE$GIT_AHEAD$GIT_BEHIND$GIT_STASH%f]"
  else
      #This cleans the non zero return code if not in GIT repo, usefull when using sterred
    w &> /dev/null
    GPS=''
  fi
}

bash_prompt() {
  git_bash_prompt_vars
  case $(id -u) in
    0) PS1="${Red}┌─[\u${Color_Off}@${BBlue}\h:${BWhite}$GPS${Yellow}\w${Red}]\n└─# ${Color_Off}"
    ;;
    *) PS1="${Green}┌─[\u${Color_Off}@${BBlue}\h:${BWhite}$GPS${Yellow}\w${Green}]\n└─\$${Color_Off} "
    ;;
  esac
}

zsh_prompt() {
  git_zsh_prompt_vars
  PROMPT="%(!.%F{red}.%F{green})┌─[%n%f@%F{blue}%m:$GPS%F{220}%~%F{green}]${NEWLINE}%F{green}└─%#%f "
}

# 'ZSH_VERSION' only defined in Zsh
# 'precmd' is a special function name known to Zsh

[ ${ZSH_VERSION} ] && precmd() { zsh_prompt; }

# 'BASH_VERSION' only defined in Bash
# 'PROMPT_COMMAND' is a special environment variable name known to Bash

[ ${BASH_VERSION} ] && PROMPT_COMMAND=bash_prompt



