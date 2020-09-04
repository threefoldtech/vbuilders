FROM builders_golang
RUN rm  -rf /tmp/* /var/cache/apk/*
# RUN 
RUN echo 'nameserver 8.8.8.8' > '/etc/resolv.conf';\
    mkdir /root/code;\
    cd /root/code;git clone https://github.com/yggdrasil-network/yggdrasil-go
RUN cd /root/code/yggdrasil-go;./build
RUN echo 'YGGDRASIL DEV ENV WELCOMES YOU' > /etc/motd
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]
