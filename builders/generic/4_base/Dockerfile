FROM despiegk/rustbuilder as builder

RUN rm  -rf /tmp/* /var/cache/apk/*

# RUN rm -rf /code && mkdir -p /code && cd /code && git clone https://github.com/threefoldtech/zinit
# RUN cd /code/zinit && cargo build --release --target=x86_64-unknown-linux-musl
# RUN cd /code/zinit && cargo build --release

# FALL BACK
RUN apk add wget && \
    wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit  && \
    chmod +x /sbin/zinit

ADD conf.sh /

# Start a new, final image.
FROM despiegk/base0 as final

# Copy the binaries from the builder image.
COPY --from=builder /sbin/zinit /sbin/zinit

ARG HOME

RUN touch /etc/environment
RUN mkdir -p /etc/zinit/

ADD conf.sh /

ENTRYPOINT ["/sbin/zinit","init","--container"]
