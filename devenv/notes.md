- [x] add ygg
- [x] run scripts inside tmuxp
- [ ] move compsoe outside
- [ ] vgrid/gridclient already installed?
- [ ] zinit already installed?

```bash
RUN apk add --update go

RUN git clone https://github.com/yggdrasil-network/yggdrasil-go && \
    cd yggdrasil-go && \
    ./build && go build -o /src/genkeys cmd/genkeys/main.go && \
    cp yggdrasil /usr/local/bin && \
    cp yggdrasilctl /usr/local/bin && \
    cp /src/genkeys /usr/local/bin/genkeys &&\
    yggdrasil -genconf > /etc/yggdrasil.conf
```


docker couldn't connect to a tun or load one. so ygg fails
try pprivileged: true. okay this give a deferent error

modprobe tun


since it works on gridproxy with the same config it should be a run time config is missing


it will only work if you did so. https://github.com/yggdrasil-network/yggdrasil-go/issues/522
The admin socket can be disabled by setting IfName to none 


v install --git https://github.com/threefoldtech/vgrid



errors for loading. privelede
errror with admine, if anme none
error on ipv6
```yaml
networks:
  main:
    name: net2
    enable_ipv6: true
    ipam:
      config:
        - subnet: 2001:db8:a::/64
          gateway: 2001:db8:a::1
```