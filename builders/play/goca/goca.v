module goca

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'goca', platform: .alpine)

	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_codeget(url: 'git@github.com:kairoaraujo/goca.git', dest: '/code/goca')!

	r.add_run(
		cmd: '
		cd /code/goca/rest-api
		go build -o main .
		cp main /bin/goca
		'
	)!

	r.add_from(image: 'base', alias: 'installer')!

	r.add_copy(from: 'builder', source: '/bin/goca', dest: '/bin/goca')!

	r.add_env('CAPATH', '/goca/data')!
	r.add_workdir(workdir: '/goca/data')!
	r.add_expose(ports: ['80'])!

	// TODO should add test curl command to it
	r.add_zinit_cmd(
		name: 'goca'
		exec: '
				echo we did it
				mkdir -p /goca/data
				cd /goca/data
				/bin/goca
			'
	)!
	r.add_zinit_cmd(name: 'redis', exec: 'redis-server --port 7777', test: 'redis-cli -p 7777 PING')!
	r.add_zinit_cmd(name: 'redis2', exec: 'redis-server --port 7778')!

	r.build(args.reset)!
}

