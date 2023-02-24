
FROM despiegk/3bot:latest

RUN apk add --no-cache make
RUN rm  -rf /tmp/* /var/cache/apk/*

RUN apk add --no-cache git musl-dev
RUN apk add --update gcc g++
RUN apk add --update go
WORKDIR /app
ENV GOPATH /app

#install tendermint
RUN CGO_ENABLED=1 GOOS=linux \
    && git clone https://github.com/tendermint/tendermint.git \
    && cd tendermint \
    && make install \
    && cp /app/bin/tendermint /bin/

RUN mkdir -p ~/code/github/threefoldtech \
    && mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# ADD git@github.com:threefoldtech/zbc_poc.git ~/code/github/threefoldtech/zbc_poc

RUN --mount=type=ssh,required=true \
    cd ~/code/github/threefoldtech \
    && git clone git@github.com:threefoldtech/zbc_poc.git

RUN cd ~/code/github/threefoldtech/zbc_poc/tendermint \
    && go build \
    && cp tm_ws /bin/consensusengine

RUN tendermint init

# cd ~/code/github/threefoldtech/zbc_poc/examples/kvs && v run main.v --chunksize=10 --snapshot=5000
# consensusengine -config /root/.tendermint/config/config.toml


ADD conf.sh /

