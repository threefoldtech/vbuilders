
## Web 3 Gateway Development

see https://github.com/threefoldtech/3bot/tree/development_integration/web3gw/server

### to play with it manually

- build it 

```bash
v -cg run ~/code/github/threefoldtech/builders/examples/web3proxy/play_web3proxy.v
cd /tmp/builder/web3proxy
docker images 
```

you should see a web3proxy in the images

```bash
docker run --name web3proxy -p 8080:8080 -p 8081:8081 web3proxy:latest
```


