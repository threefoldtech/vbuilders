module web3gwdev

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder
import threefoldtech.builders.core.vbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine)!
	vbuilder.build(engine: engine)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'web3gwdev', platform: .alpine)

	r.add_from(image: 'gobuilder', alias: 'builder')!

	gitbranch := 'development_integration' 

	r.add_gobuild_from_code(
		url: 'https://github.com/threefoldtech/3bot/tree/${gitbranch}/web3gw/server'
		name:"web3gw"
		buildcmd:"go build ."
		copycmd:"cp server /bin/web3gw"
	)!	

	r.add_from(image: 'vbuilder', alias: 'installer')!

	r.add_copy(from: 'builder', source: '/bin/web3gw', dest: '/bin/web3gw')!

	r.add_codeget(
		url: 'https://github.com/threefoldtech/3bot/tree/${gitbranch}/web3gw/examples'
		dest: '/code/examples'
	)!

	r.add_codeget(
		url: 'https://github.com/threefoldtech/3bot/tree/${gitbranch}/web3gw/client'
		dest: '/code/client'
	)!


	

	r.build(args.reset)!
}
