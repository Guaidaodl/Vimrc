# Zsh 的配置
#
# 首先要先安装 oh-my-zsh
#
# 需要先安装的软件:
# - fzf: https://github.com/junegunn/fzf#using-homebrew-or-linuxbrew
# - z.lua: https://github.com/skywind3000/z.lua 
# - powerlevel9k: https://github.com/Powerlevel9k/powerlevel9k 
#
# 需要额外的插件
# - zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions 
#
# 需要设定以下的环境变量:
# Z_LUA_PATH: z.lua 脚本的位置
#

plugins=(adb zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

########################################################### 
#  powerlevel9k
###########################################################
source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
ZSH_DISABLE_COMPFIX=true

########################################################### 
# fzf 
###########################################################
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

########################################################### 
# z.lua 
###########################################################
eval "$(lua $Z_LUA_PATH --init zsh)"

########################################################### 
# git 相关的配置
###########################################################
alias g="git"
alias gaf='git ls-files -m -o --exclude-standard | fzf --print0 -m | xargs -0 -t -o git add'

# 打印选中的分支
function gsb() {
    git rev-parse --git-dir 1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
        (>&2 echo "Not in git dir")
        echo ""
    fi
    local branches branch
    branches=$(git --no-pager branch -vv) &&
    branch=$(echo "$branches" | fzf +m --reverse --height 40% | sed "s/^*//"| awk '{print $1}') &&

    echo $branch
}

# 推送到 Gerrit
function gpg() {
    git rev-parse --git-dir 1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
        (>&2 echo "Not in git dir")
        return -1
    fi

    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)
    git push origin HEAD:refs/for/$branch
}

function gch() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m --reverse --height 40%) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

function gchr() {
  local branch=$(git branch -r | fzf +m --reverse --height 40% | sed "s/^ *origin\///1")

  if [ -n "$branch" ]; then
    git checkout $branch
  fi
}

function gmb() {
    git merge `gsb`
}

