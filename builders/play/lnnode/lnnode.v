module lnnode

import freeflowuniverse.crystallib.osal.docker
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

	r.add_codeget(url: 'https://github.com/lightningnetwork/lnd', dest: '/code/lnd')!
	r.add_codeget(url: 'https://github.com/lightninglabs/lndinit', dest: '/code/lndinit')!
	r.add_package(
		name: 'bash, bison, build-base, curl, linux-headers, make, pkgconf, python3, xz, autoconf, automake, libtool'
	)!

	// building bitcoin required for musl on alpine
	r.add_run(
		cmd: '
			cd /code/lnd
			make install
	'
	)!

	r.add_run(
		cmd: '
			cd /code/lndinit
			make
	'
	)!

	// download sample config file from repository
	configurl := 'https://raw.githubusercontent.com/threefoldtech/builders/development/builders/play/lnnode/lnd-default.conf'
	r.add_run(cmd: 'wget ${configurl} -O /root/lnd-source.conf')!

	r.add_from(image: 'base', alias: 'installer')!

	r.add_copy(from: 'builder', source: '/root/lnd-source.conf', dest: '/root/lnd-source.conf')!
	r.add_copy(from: 'builder', source: '/app/bin/lnd', dest: '/bin/lnd')!
	r.add_copy(from: 'builder', source: '/app/bin/lncli', dest: '/bin/lncli')!
	r.add_copy(from: 'builder', source: '/code/lndinit/lndinit-debug', dest: '/bin/lndinit')!

	r.add_sshserver()!

	// runtime dependencies
	r.add_package(name: 'fuse, libstdc++, libgomp, libstdc++-dev, musl-dev, jq')!

	r.add_zinit_cmd(
		name: 'lnd-setup'
		oneshot: true
		exec: "
			if [ -z \$BTCHOST ]; then
			    echo 'Missing BTCHOST' >> /errors
				exit 1
			fi

			if ! grep -q bitcoind.local /etc/hosts; then
				echo >> /etc/hosts
				echo \$BTCHOST    bitcoind.local >> /etc/hosts
			fi

			mkdir -p /root/.lnd
			cp /root/lnd-source.conf /root/.lnd/lnd.conf

			mkdir -p /safe

			if [[ ! -f /safe/seed ]]; then
				echo Creating seed
    			lndinit gen-seed > /safe/seed
			fi

			if [[ ! -f /safe/password ]]; then
				echo Creating password
				lndinit gen-password > /safe/password
			fi
	
			echo Creating wallet
			lndinit -v init-wallet --secret-source=file --file.seed=/safe/seed --file.wallet-password=/safe/password --init-file.output-wallet-dir=/root/.lnd/data/chain/bitcoin/mainnet --init-file.validate-password
		"
	)!

	r.add_zinit_cmd(
		name: 'lnd'
		after: 'lnd-setup'
		exec: "
			if [ -z \$BTCHOST ]; then
			    echo 'Missing BTCHOST' >> /errors
				exit 1
			fi

			if [ -z \$BTCUSER ]; then 
				BTCUSER=user
			fi

			if [ -z \$BTCPWD ]; then
				BTCPWD=defaultbtc
			fi

			lnd --bitcoind.rpcuser=\$BTCUSER --bitcoind.rpcpass=\$BTCPWD --wallet-unlock-allow-create
		"
	)!

	r.build(args.reset)!
}
