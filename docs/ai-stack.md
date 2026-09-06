# AI stack (local LLM via harbor)

Install harbor: https://github.com/av/harbor

```bash
harbor llamacpp model https://huggingface.co/user/repo/file.gguf
```

Remove some defaults:
```bash
harbor defaults rm webui
harbor defaults rm ollama
```

Then run llamacpp:
```bash
harbor up llamacpp
```

Point opencode at the running model: check `harbor ps`, apply that base URL in
`opencode.json`.

## llamacpp args for a 4070 (12GB vram, 32GB ram, i7-14700f)

In `.harbor/.env`:

`HARBOR_LLAMACPP_EXTRA_ARGS="--flash-attn 'on' --slots --metrics -ngl 99 --no-context-shift --ctx-size 64000 --n-predict 64000 --temp 0.5 --top-k 20 --top-p 0.95 --min-p 0 --repeat-penalty 1.05 --presence-penalty 2.0 --threads 16 --threads-http 16 --cache-reuse 256 --main-gpu 0 --tensor-split 0.5,0.5 --override-tensor '([3-8]+).ffn_.*_exps.=CPU' --cache-type-k q8_0 --cache-type-v q8_0"`

## Model to try

https://huggingface.co/noctrex/GLM-4.7-Flash-MXFP4_MOE-GGUF
(opencode needs at least 64k ctx-size to work properly with it)