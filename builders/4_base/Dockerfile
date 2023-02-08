FROM base0
RUN rm  -rf /tmp/* /var/cache/apk/*
# RUN apk update
# RUN apk upgrade

ARG HOME

RUN touch /etc/environment
RUN mkdir -p /etc/zinit/


# ADD zinit/* /etc/zinit/
RUN mkdir -p /etc/zinit
# ADD myhost/bin/zinit /bin/zinit

RUN apk add wget && \
    wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit  && \
    chmod +x /sbin/zinit

# ADD scripts/* /bin/
# ADD env.sh /
# ADD conf.sh /


ENTRYPOINT ["/sbin/zinit","init","--container"]


