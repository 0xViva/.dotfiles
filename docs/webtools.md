# Web dev tools (manual)

These are manual dev tools, intentionally not part of setup.sh:

```bash
go install github.com/a-h/templ/cmd/templ@latest   # templating language

curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
mv tailwindcss-linux-x64 tailwindcss            # standalone binary in $HOME
```