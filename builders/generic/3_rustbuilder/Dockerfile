FROM despiegk/rustbuilder as builder

RUN rm  -rf /tmp/* /var/cache/apk/*

# FALL BACK, does this work multi platform
RUN apk add wget && \
    wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit  && \
    chmod +x /sbin/zinit

ADD conf.sh /

ARG HOME

RUN touch /etc/environment
RUN mkdir -p /etc/zinit/

ENTRYPOINT ["/sbin/zinit","init","--container"]
