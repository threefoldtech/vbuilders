FROM alpine:edge
RUN rm  -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache redis && apk add --no-cache dumb-init 
RUN apk add --no-cache nginx curl libssh2

# add openssh and clean
RUN apk add --no-cache openssh && rm  -rf /tmp/* /var/cache/apk/*

# add entrypoint script
ADD boot.sh /usr/local/bin

#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
RUN chmod 770 /usr/local/bin/boot.sh

RUN apk add --no-cache mc htop rsync

EXPOSE 22
EXPOSE 6379

RUN echo 'THREEFOLD BASE DEV ENV WELCOMES YOU' > /etc/motd

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]
