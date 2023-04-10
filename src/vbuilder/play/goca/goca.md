
## Certificate Authority written in GO

this docker has mainly be used to show how to build docker images to build from code and uze zinit

see http://kairoaraujo.github.io/goca

rest interface on http://kairo.eti.br/goca/


### to play with it manually

- build it 

```bash
v -cg run ~/code/github/threefoldtech/builders/src/examples/goca/play_goca.v
cd /tmp/builder/goca
docker images 
```

you should see a goca in the images

```bash
docker run --name goca -p 8033:80 goca:latest
curl http://localhost:8033/api/v1/ca
```

//TODO: http://localhost:8033/swagger/ should work but it doesn't, might be broken