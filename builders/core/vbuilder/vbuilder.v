module vbuilder

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.cbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	cbuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'vbuilder', platform: .alpine)

	r.add_from(image: 'cbuilder')!
	r.add_vbuilder()!

	r.add_zinit()!

	r.build(args.reset)!
}
