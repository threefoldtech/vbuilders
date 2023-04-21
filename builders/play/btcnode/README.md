# Bitcoin Full Node image builder

## Build process

This builder script create a final image which can boot a bitcoin daemon using a pre-polulated chain state
download on the fly during the process starting up stage.

To achieve this, here are the steps the builder does:
- Build and install `bitcoind` and `bitcoin-cli`.
  - Because we use alpine image, we need to compile `bitcoind` to get a binary working with musl.
- Install `rfs` (formely `0-fs`) to be able to mount an flist inside the VM
- Download a sample config file for `bitcoin.conf` from this repository
- Enable SSH server in the image
- All zinit script needed on runtime to prepare the machine

Note: because of a dependency inside `rfs`, the fuse library execute `fusermount` utility with an absolute
path: `/usr/bin/fusermount`, by default, on our image, this helper is on `/bin/fusermount`, so we symlink it to make it works.

## Runtime

Here are the steps the image does on boot (runtime):

1. `zerofs-setup`
  - In order to use the flist for the chain state, we need to use an overlayfs to get the read-write layer working.
    Overlayfs require specific filesystem to works and this require for us an external disk to be mounted in the VM. The script
   first ensure that a disk a mounted in it's expected location (`/mnt`) and dire otherwise with an error in `/errors`.
  - The script create needed directories inside `/mnt` if they don't exists
  - The script download a bitcoin chain snapshot and save it inside `/mnt`. Saving it inside `/mnt` is important because
    if the machine reboot, this file will be persisted and the same file will be reused to mount the base snapshot.
2. `zerofs-mount`
  - This is where the flist magic happen, we open the snapshot content with `rfs` and expose the read-only filesystem.
  - We then mount the overlayfs inside `/root/.bitcoin` which will be used by `bitcoind` later
3. `bitcoind-setup`
  - Copy a default `bitcoin.conf` file needed by bitcoind
4. `bitcoind`
  - Run the actual `bitcoind` daemon. The daemon will only accept connection via **Planetary Network**.
  - The password will be taken from environment variable (`BTCPWD`) or the default one (`defaultbtc`) will be used.

## How to build it

When using the default installer for the builder, you can just trigger the build like this:
```
v -cg run /root/code/github/threefoldtech/builders/examples/btcnode/play_btcnode.v
```

## How to upload it to the hub

When the image is ready, you can simply take it and export to upload it to the grid hub.

Run a temporarily container with the newly built image. We override the entrypoint to avoid starting the bitcoin node.
```
docker run --rm -dit --entrypoint /bin/bash --name bitcoin-export btcnode
```

You can now extract the filesystem content:
```
docker export bitcoin-export > btcnode.tar
docker stop bitcoin-export
```

The `stop` will take care to cleanup the docker, because flag `--rm` were supplied.

Now we have the root filesystem ready locally. Let's compress it:
```
gzip btcnode.tar
```

You can now get that `btcnode.tar.gz` file (via scp, whatever) and upload it directly as it to the `hub.grid.tf`.

## How to run the VM

In order to run that Micro VM easily, just go to a grid playground (eg: `play.test.grid.tf`).

1. Create a new Micro VM
2. In VM Image, select `Other`
3. FList URL: `https://hub.grid.tf/maxux42.3bot/btcnode.flist` (will be changed later)
4. Entry Point:
  - Keep the default one: `/sbin/zinit init`
5. Enable **public IPv6** and **Planetary Network**
6. In Environment Variables:
  - Add a new `BTCPWD` variable with your desired password
7. Keep your `SSH_KEY` set in order to manage your machine
8. Add a Disk:
  - Size: at least `50G` (more is better)
  - Mount Point: `/mnt` (this is important, just `/mnt`)

Deploy the machine ! And now:
- You can SSH the Micro VM to check the status.
- You can use command `zinit` to see daemon status
- In case of a well known error, a file called `/errors` will contains more information, you can check that file
- You can use `bitcoin-cli` to localy query your node and get status (you need to specify your password)

You can query your bitcoin node remotely via:
```
$ bitcoin-cli -rpcconnect=300:bda2:1631:aaf7:960c:2fc5:49b1:6b29 -rpcpassword=custompwd getblockscount
785305
```

The `rpcconnect` is the machine Planetary Network address, the `rpcpassword` is your password set via environment variable.

That's it !
