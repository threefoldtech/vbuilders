module tfchainbuilder

import freeflowuniverse.crystallib.docker

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	mut r := engine.recipe_new(name: 'tfchain', platform: .ubuntu, zinit: false)
	r.add_from(image: 'paritytech/ci-linux', tag: 'production', alias: 'builder')!

	r.add_env('FEATURES', 'default')!

	// TODO: there is a code_get recipe see goca example
	r.add_run(cmd: 'git clone https://github.com/threefoldtech/tfchain /tfchain')!
	r.add_run(
		cmd: '
		cd /tfchain/substrate-node
		cargo build --locked --release --features \$FEATURES
	'
	)!

	// stage two
	r.add_from(image: 'ubuntu', tag: '20.04')!
	r.add_env('PROFILE', 'release')!

	r.add_copy(
		from: 'builder'
		source: '/tfchain/substrate-node/target/\$PROFILE/tfchain'
		dest: '/usr/local/bin'
	)!
	r.add_copy(
		from: 'builder'
		source: '/tfchain/substrate-node/chainspecs'
		dest: '/etc/chainspecs/'
	)!

	r.add_run(
		cmd: '
			ldd /usr/local/bin/tfchain
			/usr/local/bin/tfchain --version
		'
	)!

	r.add_run(
		cmd: '
			ldd /usr/local/bin/tfchain
			/usr/local/bin/tfchain --version
		'
	)!
	r.add_package(names: ['curl', 'ca-certificates'])!
	r.add_run(
		cmd: '
			rm -rf /usr/lib/python*
			rm -rf /src
			rm -rf /usr/share/man
			'
	)!

	r.add_expose(ports: ['30333', '9933', '9944', '9615'])!
	r.add_volume(mount_points: ['/tfchain'])!

	r.build(args.reset)!
}
