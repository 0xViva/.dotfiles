
# Dotfiles symlinked on my machine


install:

`./setup.sh [OS_TYPE]`

To make tailwindcss and html lsp work for WSL:

`cd .local/share/nvim/mason`
`ln -s packages/tailwindcss-language-server/node_modules/@tailwindcss @tailwindcss`
`ln -s packages/html-lsp/node_modules/vscode-langservers-extracted vscode-langservers-extracted`

install ai stack:

https://github.com/av/harbor

harbor llamacpp model https://huggingface.co/user/repo/file.gguf

harbor up llamacpp

point your local opencode config towards the running llamacpp
