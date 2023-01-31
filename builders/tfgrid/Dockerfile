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