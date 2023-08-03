module web3proxy

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder
import threefoldtech.builders.core.vbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine, reset: false, strict: args.strict)!
	vbuilder.build(engine: engine, reset: false, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'web3proxy', platform: .alpine)

	r.add_from(image: 'gobuilder', alias: 'builder')!

	web3_proxy_branch := 'development_v_ui' // branches need to be the same

	r.add_codeget(
		url: 'https://github.com/threefoldtech/web3_proxy/tree/${web3_proxy_branch}/server'
		dest: '/code/web3_proxy'
		pull: true
		reset: true
	)!

	r.add_run(
		cmd: '
		cd /code/web3_proxy
		go build .
		cp server /bin/web3proxy
		'
	)!

	r.add_from(image: 'vbuilder', alias: 'installer')!

	r.add_copy(from: 'builder', source: '/bin/web3proxy', dest: '/bin/web3proxy')!

	r.add_codeget(
		url: 'https://github.com/threefoldtech/web3_proxy/tree/${web3_proxy_branch}'
		dest: '/code/web3_proxy'
	)!

	r.add_run(
		cmd: '
		cd /code/web3_proxy/app/ui
		bash install.sh
		bash build.sh
		'
	)!

	r.add_expose(ports: ['8080', '8081'])!

	r.add_zinit_cmd(
		name: 'web3proxy'
		exec: '
				echo we did it, web3proxy is there
				/bin/web3proxy
			'
	)!

	r.add_zinit_cmd(
		name: '3bot'
		exec: '
				echo we did it, 3bot is here
				cd /code/web3_proxy/app/ui
				v run run.vsh
			'
	)!

	r.build(args.reset)!
}
