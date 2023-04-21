module tfhub

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.base

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	base.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: "tfhub", platform: .alpine)

	// starting from light base image
	r.add_from(image: "base", alias: "builder")!

	deps := "alpine-sdk git autoconf automake libtool libtar-dev zlib-dev jansson-dev \
	         capnproto-dev hiredis-dev sqlite-dev libb2-dev fts musl-fts-dev linux-headers \
			 snappy-dev curl-dev"

	r.add_package(name: deps)!

	// fetch dependencies source code
	r.add_codeget(url: "https://github.com/threefoldtech/0-db", dest: "/code/zdb")!
	r.add_codeget(url: "https://github.com/threefoldtech/0-flist", dest: "/code/zflist")!
	r.add_codeget(url: "https://github.com/opensourcerouting/c-capnproto", dest: "/code/capnpc")!

	// building capnpc not available in apk
	r.add_run(
		cmd: "
			cd /code/capnpc
			git submodule update --init --recursive
			autoreconf -f -i -s
			./configure
			make
			make install
		"
	)!

	// compiling zdb
	r.add_run(
		cmd: "
			cd /code/zdb/libzdb
			make release
			cd ../zdbd
			make release
		"
	)!

	// compiling zflist
	r.add_run(
		cmd: "
			cd /code/zflist/libflist
			make alpine
			cd ../zflist
			make alpine
		"
	)!


	r.add_from(image: 'base', alias: 'installer')!
	
	// download hub source code
	r.add_codeget(url: "https://github.com/threefoldtech/0-hub", dest: "/code/hub")!

	// copy binaries from builder, we don't keep source files
	r.add_copy(from: "builder", source: "/code/zdb/zdbd/zdb", dest: "/bin/zdb")!
	r.add_copy(from: "builder", source: "/code/zflist/zflist/zflist", dest: "/bin/zflist")!

	// but we need to add runtime libraries dependencies
	r.add_package(name: "libtar libb2 zlib jansson hiredis sqlite fts snappy curl sqlite-libs")!
	
	r.add_sshserver()!

	// runtime python dependencies
	r.add_package(name: "python3 py3-requests py3-pip py3-flask py3-pynacl py3-redis py3-pytoml")!

	// runtime python dependencies not available via apk
	r.add_run(cmd: "pip3 install python-jose docker")!

	// create customized config
	r.add_run(
		cmd: "
			cd /code/hub/src
			cp config.py.sample config.py

			sed -i 's#/opt/0-flist/zflist/zflist#/bin/zflist#g'

			openssl genpkey -algorithm x25519 -out private.key
			privkey=$(openssl pkey -in private.key -text | xargs | sed -e 's/.*priv\:\(.*\)pub\:.*/\1/' | xxd -r -p | base64)
	

		"
	)!

	/*
	// init script to download bitcoin snapshot
	r.add_zinit_cmd(
		name: "zerofs-setup",
		oneshot: true,
		exec: "
		    if ! grep 'vda /mnt ' /proc/mounts; then
			    echo External disk not mounted correctly >> /errors
				exit 1
			fi

			mkdir -p /mnt/cache
			mkdir -p /mnt/readwrite
			mkdir -p /mnt/snapshot
			mkdir -p /mnt/workdir

			if [ ! -f /mnt/bitcoin-snapshot.flist ]; then
				wget https://btc.grid.tf/snapshots/bitcoin-snapshot-2024-04-07.flist -O /mnt/bitcoin-snapshot.flist
			fi
		"
	)!

	// init script to start rfs with downloaded snapshot and mount it
	// on the right location
	r.add_zinit_cmd(
		name: "zerofs-mount",
		after: "zerofs-setup",
		oneshot: true,
		exec: "
			rfs --daemon --cache /mnt/cache --storage-url redis://[2001:728:1000:402:70b4:a3ff:fe89:bf13]:9900/604-22888-zdb1 --meta /mnt/bitcoin-snapshot.flist /mnt/snapshot/
			
			mkdir -p /root/.bitcoin
			mount -t overlay overlay -o lowerdir=/mnt/snapshot,upperdir=/mnt/readwrite,workdir=/mnt/workdir /root/.bitcoin/
		"
	)!

	// put back sample config file
	r.add_zinit_cmd(
		name: "bitcoind-setup", 
		after: "zerofs-mount",
		oneshot: true,
		exec: "
			cp /root/bitcoin-source.conf /root/.bitcoin/bitcoin.conf
		"
	)!

	r.add_zinit_cmd(
		name: "bitcoind",
		after: "bitcoind-setup",
		exec: "
		    if [ -z \$BTCPWD ]; then
			    BTCPWD=defaultbtc
			fi

			bitcoind -rpcbind=:: -rpcallowip=200::/7 -rpcpassword=\$BTCPWD
		"
	)!
	*/

	r.build(args.reset)!
}
