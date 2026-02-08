
# Dotfiles symlinked on my machine


install:

`./setup.sh [OS_TYPE]`

# install ai stack:

from here: https://github.com/av/harbor

`harbor llamacpp model https://huggingface.co/user/repo/file.gguf`

remove some defaults:
`harbor defaults rm webui`
`harbor defaults rm ollama`

then run llamacpp:
`harbor up llamacpp`

point your local opencode config towards the running llamacpp:
check whats running `harbor ps`, apply that base URL in the `opencode.json`

llamacpp arguments setup that works for my current desktop pc (gpu rtx4070 vram 12gb, ram 32gb, cpu i7-14700f) in `.harbor/.env`:

`HARBOR_LLAMACPP_EXTRA_ARGS="--ctx-size 64000 --n-gpu-layers 24 --cache-type-k q4_0 --cache-type-v q4_0 --flash-attn on --parallel 1"`

opencode says it needs at least 64k ctx-size to work properly.
