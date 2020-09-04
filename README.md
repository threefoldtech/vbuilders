

## to stop all containers

```
docker rm -f $(docker ps -a -q)
```

## ports used

- base: ssh:5000
- python: 5001
- sonic: 5002
- crystal: ssh:5003
- production: ssh:5005
- tarantool: ssh:5006
- golang: ssh:5007
- yggdrasil: ssh:5008