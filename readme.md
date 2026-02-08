
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


`HARBOR_LLAMACPP_EXTRA_ARGS="--flash-attn 'on' --slots --metrics -ngl 99 --no-context-shift --ctx-size 64000 --n-predict 64000 --temp 0.5 --top-k 20 --top-p 0.95 --min-p 0 --repeat-penalty 1.05 --presence-penalty 2.0 --threads 16 --threads-http 16 --cache-reuse 256 --main-gpu 0 --tensor-split 0.5,0.5 --override-tensor '([3-8]+).ffn_.*_exps.=CPU' --cache-type-k q8_0 --cache-type-v q8_0"`

should try this:
https://huggingface.co/noctrex/GLM-4.7-Flash-MXFP4_MOE-GGUF
opencode says it needs at least 64k ctx-size to work properly.
