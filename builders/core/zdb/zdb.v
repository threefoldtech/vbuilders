module zdb

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.base
import threefoldtech.builders.core.cbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	cbuilder.build(engine: engine, reset: args.reset, strict: args.strict)!
	base.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'zdb', platform: .alpine)

	r.add_from(image: 'cbuilder', alias: 'builder')!

	r.add_codeget(url: 'git@github.com:threefoldtech/0-db.git', dest: '/code/zdb')!

	r.add_run(
		cmd: '
		# make -C /code/zdb/libzdb release
		# make -C /code/zdb/zdbd release		
		# make -C /code/zdb/tools release
		cd  /code/zdb
		make release
		cp /code/zdb/bin/zdb /bin/
	'
	)!

	r.add_from(image: 'base', alias: 'zdb')!
	// we are now in phase 2, and start from a clean image, we call this layer 'installer'
	// we now add the file as has been build in step one to phase 2
	r.add_copy(from: 'builder', source: '/bin/zdb', dest: '/bin/zdb')!

	r.add_expose(ports: ['9900'])!

	r.add_zinit_cmd(name: 'zdb', exec: '/bin/zdb')!

	r.build(args.reset)!
}
