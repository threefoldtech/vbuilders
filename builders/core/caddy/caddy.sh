export CGO_ENABLED=1
export GOOS=linux
export PATH=$PATH:/app/bin
cd /tmp
xcaddy build  --with github.com/caddyserver/ntlm-transport 