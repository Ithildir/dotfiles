# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.cache/zsh_history
HISTSIZE=10000
SAVEHIST=100000

bindkey -e

fpath=(~/.config/zsh/functions $fpath)

autoload -Uz compinit ~/.config/zsh/functions/*
compinit

setopt noautomenu

if command -v gcloud &> /dev/null; then
  local gcloudDir=`dirname $(command -v gcloud)`

  source "$gcloudDir/completion.zsh.inc"
  source "$gcloudDir/path.zsh.inc"
fi

if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi

source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme

source ~/.config/zsh/aliases.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
