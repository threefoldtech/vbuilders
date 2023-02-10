FROM despiegk/rust0 as builder

RUN rm  -rf /tmp/* /var/cache/apk/*

RUN rm -rf /code && mkdir -p /code && cd /code && git clone https://github.com/threefoldtech/zinit

# RUN cd /code/zinit && cargo build --release --target=x86_64-unknown-linux-musl
RUN cd /code/zinit && cargo build --release

RUN cp /code/zinit/target/release/zinit /bin/

# Start a new, final image.
FROM despiegk/base0 as final

# Copy the binaries from the builder image.
COPY --from=builder /bin/zinit /bin/

ARG HOME

RUN touch /etc/environment
RUN mkdir -p /etc/zinit/

# ADD myhost/bin/zinit /bin/zinit

# WE HAD OUR OWN BUILDS OF ZINIT SEE RUSTBUILDER, THIS BROKE IT
# RUN apk add wget && \
#     wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit  && \
#     chmod +x /sbin/zinit

RUN rm -f /conf.sh
ADD conf.sh /

ENTRYPOINT ["/sbin/zinit","init","--container"]
