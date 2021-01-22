FROM builders_base
# FROM alpine:3.12

RUN rm  -rf /tmp/* /var/cache/apk/*

WORKDIR /opt/vlang

ENV VVV  /opt/vlang
ENV PATH /opt/vlang:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV VFLAGS -cc gcc

RUN mkdir -p /opt/vlang && ln -s /opt/vlang/v /usr/bin/v

RUN apk --no-cache add \
  git make upx gcc bash \
  musl-dev \
  openssl-dev sqlite-dev \
  libx11-dev glfw-dev freetype-dev

## RUN apk --no-cache add --virtual sdl2deps sdl2-dev sdl2_ttf-dev sdl2_mixer-dev sdl2_image-dev

RUN cd /opt && git clone https://github.com/vlang/v
#to test this does not work
#do:
#export VFLAGS=-cc gcc
RUN cd /opt/v && make && ./v symlink
RUN v -version

RUN echo 'VLANG DEV ENV WELCOMES YOU' > /etc/motd

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]
