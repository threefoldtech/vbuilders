FROM vbuilder

RUN rm  -rf /tmp/* /var/cache/apk/*

ADD scripts/* /bin/

WORKDIR /tmp

#this copies the nats tools
ADD myhost/bin/* /bin/

RUN sh /bin/nodejs_install.sh
RUN sh /bin/tfgrid_v_install.sh
RUN sh /bin/tmuxp_install.sh

ADD conf.sh /
