module lnnode

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.base
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'lnnode', platform: .alpine)

	// starting from light base image
	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_codeget(url: 'https://github.com/lightningnetwork/lnd', dest: "/code/lnd")!
	r.add_package(name: "bash, bison, build-base, curl, linux-headers, make, pkgconf, python3, xz, autoconf, automake, libtool")!

	// building bitcoin required for musl on alpine
	r.add_run(
		cmd: "
			cd /code/lnd
			make install
	"
	)!

	// download sample config file from repository
	// configurl := "https://raw.githubusercontent.com/threefoldtech/builders/development/builders/play/btcnode/bitcoin-source.conf"
	// r.add_run(cmd: "wget $configurl -O /root/bitcoin-source.conf")!

	r.add_from(image: 'base', alias: 'installer')!
	
	r.add_copy(from: "builder", source: "/app/bin/lnd", dest: "/bin/lnd")!
	r.add_copy(from: "builder", source: "/app/bin/lncli", dest: "/bin/lncli")!

	r.add_sshserver()!

	// runtime dependencies
	r.add_package(name: "fuse, libstdc++, libgomp, libstdc++-dev, musl-dev, jq")!

	r.add_zinit_cmd(
		name: "lnd",
		// after: "bitcoind-setup",
		exec: "
			echo HELLO WORLD > /hello
		"
	)!

	r.build(args.reset)!
}
