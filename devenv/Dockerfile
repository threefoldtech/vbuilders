FROM docker.io/golang:alpine as builder

ARG YGG_VERSION=v0.4.7

WORKDIR /src

ENV CGO_ENABLED=0

RUN apk add git
RUN git clone --depth 1 --branch $YGG_VERSION https://github.com/yggdrasil-network/yggdrasil-go.git .
RUN ./build && go build -o /src/genkeys cmd/genkeys/main.go

FROM 3bot

RUN apk add wget && \
    wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit  && \
    chmod +x /sbin/zinit && \
    mkdir -p /etc/zinit

RUN wget https://github.com/threefoldtech/go-rmb/releases/download/v0.2.1/msgbusd && \
    mv msgbusd /usr/bin/msgbusd &&\
    chmod +x /usr/bin/msgbusd

RUN git clone https://github.com/threefoldtech/grid3_client_ts ~/grid3_client_ts && \
    cd ~/grid3_client_ts && \
    npm install --force

COPY --from=builder /src/yggdrasil /usr/bin/yggdrasil
COPY --from=builder /src/yggdrasilctl /usr/bin/yggdrasilctl
COPY --from=builder /src/genkeys /usr/bin/genkeys

RUN v install --git https://github.com/threefoldtech/vgrid &&\
    cd ~/.vmodules/ &&\
    mv vgrid/ threefoldtech/ &&\
    cd freeflowuniverse/crystallib &&\
    git fetch --all &&\
    git checkout origin/development_improve_twinclient_module