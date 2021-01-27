FROM python:3.8.7-alpine3.12

RUN pip install --upgrade pip

RUN rm  -rf /tmp/* /var/cache/apk/*

RUN apk add --no-cache openssh dumb-init rsync
RUN  rm  -rf /tmp/* /var/cache/apk/*

ADD boot.sh /usr/local/bin

#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
RUN chmod 770 /usr/local/bin/boot.sh

EXPOSE 22

RUN echo 'THREEFOLD PYTHON DEV ENV WELCOMES YOU' > /etc/motd

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]
