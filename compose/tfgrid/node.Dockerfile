FROM alpine:latest

# Install node
RUN apk add --no-cache nodejs npm

RUN mkdir /app
WORKDIR  /app


# Make this a zinit container
COPY bin/zinit /bin/zinit

ENTRYPOINT ["/bin/zinit","init","--container"]