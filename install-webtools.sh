#templating language
go install github.com/a-h/templ/cmd/templ@latest
#add in tailwindcss standalone executable to $HOME
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
mv tailwindcss-linux-x64 tailwindcss
