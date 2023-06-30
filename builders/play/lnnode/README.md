# Lightning Network node image builder

## Build process

This builder script create a final image which can boot a lightning network daemon connecting an existing bitcoind
node.

## Runtime

Here are the steps the image does on boot (runtime):

1. `lnd-setup`
  - Check variable environment
  - Create a wallet if it doesn't exists
  - Prepare system environement
2. `lnd`
  - Run the actual `lnd` daemon. The daemon will only accept connection via **Planetary Network**.
  - The password will be taken from environment variable (`BTCPWD`) or the default one (`defaultbtc`) will be used.
  - The user will be taken from environment variable (`BTCUSER`) or the default one (`user`) will be used.

The location `/safe` contains seed and password. You should mount a disk in order to make this location persistant.
Otherwise you have to login into the machine and keep this directory safe somewhere. You can run the node without
a disk mounted, this won't be treated as an issue.

Wallet is automatically created based on password and seed, on runtime.

Note: it seems that `lnd` have some issue parsing IPv6 for some command line arguments, in order to make things
working and easier to maintain, a fake domain `bitcoind.local` is added into `/etc/hosts` pointing to the bitcoind
node passed as environment variable.

## How to build it

When using the default installer for the builder, you can just trigger the build like this:
```sh
v -cg run /root/code/github/threefoldtech/builders/examples/lnnode/play_lnnode.v
```

## How to upload it to the hub

When the image is ready, you can simply take it and export to upload it to the grid hub.

Run a temporarily container with the newly built image. We override the entrypoint to avoid starting the bitcoin node.
```sh
docker run --rm -dit --entrypoint /bin/bash --name lnnode-export lnnode
```

You can now extract the filesystem content:
```sh
docker export lnnode-export > lnnode.tar
docker stop lnnode-export
```

The `stop` will take care to cleanup the docker, because flag `--rm` were supplied.

Now we have the root filesystem ready locally. Let's compress it:
```sh
gzip lnnode.tar
```

You can now get that `lnnode.tar.gz` file (via scp, whatever) and upload it directly as it to the `hub.grid.tf`.

## How to run the VM

In order to run that Micro VM easily, just go to a grid playground (eg: `play.test.grid.tf`).

1. Create a new Micro VM
2. In VM Image, select `Other`
3. FList URL: `https://hub.grid.tf/maxux42.3bot/lnnode.flist` (will be changed later)
4. Entry Point:
    - Keep the default one: `/sbin/zinit init`
5. Enable **public IPv6** and **Planetary Network**
6. In Environment Variables:
    - Add a new `BTCHOST` variable with your bitcoind host IPv6 address
    - Add a new `BTCUSER` variable with your bitcoind user set (empty will use default from btcnode)
    - Add a new `BTCPWD` variable with your bitcoind password set (empty will use default from btcnode)
7. Keep your `SSH_KEY` set in order to manage your machine
8. Add a Disk to persist your important data:
    - Size: at least `1G`
    - Mount Point: `/safe` (this is important, just `/safe`)

**Deploy the machine !**

And now:
- You can SSH the Micro VM to check the status.
- You can use command `zinit` to see daemon status
- In case of a well known error, a file called `/errors` will contains more information, you can check that file

You can query your lnnode node remotely via:
```sh
FIXME
```

That's it !
