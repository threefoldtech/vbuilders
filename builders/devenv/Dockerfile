FROM 3bot

RUN apk add wget && \
    wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit  && \
    chmod +x /sbin/zinit && \
    mkdir -p /etc/zinit

# required vmodules
RUN mkdir -p ~/.vmodules/threefoldtech &&\
    cd ~/.vmodules/threefoldtech &&\
    git clone https://github.com/threefoldtech/vgrid

RUN cd ~/.vmodules/freeflowuniverse/crystallib &&\
    git pull