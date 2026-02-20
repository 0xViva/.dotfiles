#!/bin/zsh
  setopt ignore_eof
fzf-cd-widget() {
  local dir
  dir=$(fd "" "$HOME" --type d --hidden \
    --exclude '.rustup' \
    --exclude '.cargo' \
    --exclude '.cache' \
    --exclude 'go' \
    --exclude '.zen' \
    --exclude '.npm' \
    2> /dev/null | fzf --exact +m) || return

  LBUFFER+="${(q)dir}"
  zle reset-prompt
}

fzf-file-widget() {
  local file
  file=$(fd "" "/" --type f --hidden \
    --exclude '.rustup' \
    --exclude '.cargo' \
    --exclude '.cache' \
    --exclude 'go' \
    --exclude '.zen' \
    --exclude '.npm' \
    2> /dev/null | fzf --exact +m) || return

  LBUFFER+="$file"
  zle reset-prompt
}

zle -N fzf-file-widget
bindkey '^F' fzf-file-widget  # Ctrl+F to trigger

fzf-edit-widget() {
  local dir
  file=$(fd "" "/" --type f --hidden \
    --exclude '.rustup' \
    --exclude '.cargo' \
    --exclude '.cache' \
    --exclude 'go' \
    --exclude '.zen' \
    --exclude '.npm' \
    2> /dev/null | fzf --exact +m) || return

  nvim "$file" || return
  zle reset-prompt
  zle accept-line
}

zle -N fzf-file-widget
zle -N fzf-cd-widget
zle -N fzf-edit-widget

bindkey '^F' fzf-file-widget
bindkey '^D' fzf-cd-widget
bindkey '^E' fzf-edit-widget
bindkey -r '^T'
