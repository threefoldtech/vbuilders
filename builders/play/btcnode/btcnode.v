module btcnode

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.base
// import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	base.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'btcnode', platform: .alpine)

	// starting from light base image
	r.add_from(image: 'base', alias: 'builder')!

	r.add_codeget(url: 'https://github.com/bitcoin/bitcoin.git', dest: "/code/bitcoin")!
	r.add_package(name: "bash, bison, build-base, curl, linux-headers, make, pkgconf, python3, xz, autoconf, automake, libtool")!

	// building bitcoin required for musl on alpine
	r.add_run(
		cmd: "
			JOBS=\$((\$(grep -i -c 'bogomips' /proc/cpuinfo) + 1))

			cd /code/bitcoin
			make -C depends NO_QT=1 -j \$JOBS

			./autogen.sh
		    CONFIG_SITE=\$PWD/depends/x86_64-pc-linux-musl/share/config.site ./configure
			make -j \$JOBS
		"
	)!

	// downloading pre-compiled rfs (FIXME: maybe compile it)
	r.add_run(
		cmd: "
			wget https://github.com/threefoldtech/rfs/releases/download/v1.0.3/rfs -O /bin/rfs
			chmod +x /bin/rfs
		"
	)!

	// download sample config file from repository
	r.add_run(
		cmd: "
			wget https://raw.githubusercontent.com/threefoldtech/builders/development/builders/play/btcnode/bitcoin-source.conf -O /root/bitcoin-source.conf
		"
	)!

	r.add_from(image: 'base', alias: 'installer')!
	
	r.add_copy(from: "builder", source: "/bin/rfs", dest: "/bin/rfs")!
	r.add_copy(from: "builder", source: "/code/bitcoin/src/bitcoind", dest: "/bin/bitcoind")!
	r.add_copy(from: "builder", source: "/code/bitcoin/src/bitcoin-cli", dest: "/bin/bitcoin-cli")!

	// fix for rfs expecting fusermount on absolute path
	r.add_run(cmd: "ln -sf /bin/fusermount /usr/bin/fusermount")!
	
	r.add_sshserver()!

	// runtime dependencies
	r.add_package(name: "fuse, libstdc++, libgomp, libstdc++-dev, musl-dev")!

	// init script to download bitcoin snapshot
	r.add_zinit_cmd(
		name: "zerofs-setup",
		oneshot: true,
		exec: "
			mkdir -p /mnt/cache
			mkdir -p /mnt/readwrite
			mkdir -p /mnt/snapshot
			mkdir -p /mnt/workdir

			wget https://btc.grid.tf/snapshots/bitcoin-snapshot-2024-04-07.flist -O /root/bitcoin-snapshot.flist
		"
	)!

	// init script to start rfs with downloaded snapshot and mount it
	// on the right location
	r.add_zinit_cmd(
		name: "zerofs-mount",
		after: "zerofs-setup",
		oneshot: true,
		exec: "
			rfs --daemon --cache /mnt/cache --storage-url redis://[2001:728:1000:402:70b4:a3ff:fe89:bf13]:9900/604-22888-zdb1 --meta /root/bitcoin-snapshot.flist /mnt/snapshot/
			
			mkdir -p /root/.bitcoin
			mount -t overlay overlay -o lowerdir=/mnt/snapshot,upperdir=/mnt/readwrite,workdir=/mnt/workdir /root/.bitcoin/
		"
	)!


	// FIXME: do not download from home.maxux.net, embed it
	r.add_zinit_cmd(
		name: "bitcoind-setup",
		after: "zerofs-mount",
		oneshot: true,
		exec: "
			wget http://home.maxux.net/temp/bitcoin-source.conf -O /root/bitcoin-source.conf
			cp /root/bitcoin-source.conf /root/.bitcoin/bitcoin.conf
		"
	)!

	// FIXME: set password via environment variable
	r.add_zinit_cmd(
		name: "bitcoind",
		after: "bitcoin-setup",
		exec: "bitcoind -rpcbind=:: -rpcallowip=200::/7 -rpcpassword=password"
	)!

	r.build(args.reset)!
}
