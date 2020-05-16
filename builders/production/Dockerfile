FROM builders_base
RUN rm  -rf /tmp/* /var/cache/apk/*

RUN echo 'THREEFOLD 3BOT ENV ...' > /etc/motd

ADD sync.sh /tmp/sync.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]
