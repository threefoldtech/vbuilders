# Builders

![](https://github.com/threefoldtech/builders/blob/development/docs/img/nice_lake.png)

Our aim is to make a set of reprocable builders using vlang.

Our requirements

- easy to read
- easy to extend
- easier to develop than 100+ bash scripts

Documentation on https://threefoldtech.github.io/builders

> there are a lot of docker examples in https://github.com/threefoldtech/tf-images, look for inspiration there before creating the vbuilders


## Get started with crystallib & builders

the following script will install vlang, crystallib and this repository

```bash
curl https://raw.githubusercontent.com/threefoldtech/vbuilders/development/scripts/install.sh > /tmp/install.sh
bash /tmp/install.sh
```

## Example 

```bash
#go to branch of kristof for now
cd ~/code/github/freeflowuniverse/crystallib
#example installers for caddy, ...
vrun ~/code/github/threefoldtech/vbuilders/vinstallers/example.v
```

