FROM alpine:3.12

LABEL maintainer="spytheman <spytheman@bulsynt.org>"

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

RUN apk add --no-cache openssh-client git mc

# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts


## RUN apk --no-cache add --virtual sdl2deps sdl2-dev sdl2_ttf-dev sdl2_mixer-dev sdl2_image-dev

RUN git clone https://github.com/vlang/v /opt/vlang && make && v -version

RUN echo 'VLANG DEV ENV WELCOMES YOU' > /etc/motd

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]