FROM alpine:latest

# Make this a zinit container
COPY bin/zinit /bin/zinit

ENTRYPOINT ["/bin/zinit","init","--container"]