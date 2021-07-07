# uncomment to run zprof: load zsh; run zprof to list result
# zmodload zsh/zprof

#setup prompt
eval "$(starship init zsh)"

## configure ls colors
eval "$(dircolors -b)"

setopt histignorealldups sharehistory

## Use emacs keybindings even if our EDITOR is set to vi
bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

## source other important files
for file in ~/.{aliases,functions,path,exports}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    # shellcheck source=/dev/null
    source "$file"
  fi
done

# asdf
. $HOME/.asdf/asdf.sh

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## kubectl autocomplete: takes too long to load
#[[ /home/msc/.asdf/shims/kubectl ]] && source <(kubectl completion zsh)
