FROM builders_base
RUN rm  -rf /tmp/* /var/cache/apk/*
#don't understand but looks like gilang gets installed that way
RUN apk add --no-cache gcc git musl-dev
#so no golang needed extra
# RUN apk add --no-cache go
RUN echo 'GO LANG DEV ENV WELCOMES YOU' > /etc/motd
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]
