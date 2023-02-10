FROM despiegk/natstools as builder

ADD conf.sh /


FROM despiegk/vbuilder as final

RUN rm  -rf /tmp/* /var/cache/apk/*

ADD scripts/* /bin/

# Copy the binaries from the builder image.
COPY --from=builder /bin/nsc /bin/
COPY --from=builder /bin/nats /bin/

WORKDIR /tmp

RUN sh /bin/nodejs_install.sh
RUN sh /bin/tfgrid_v_install.sh
RUN sh /bin/tmuxp_install.sh

ADD conf.sh /
