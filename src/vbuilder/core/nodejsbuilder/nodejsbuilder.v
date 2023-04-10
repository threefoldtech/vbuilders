module nodejsbuilder

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.core.base

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine
	// make sure dependency has been build
	base.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'nodejsbuilder', platform: .alpine)

	r.add_from(image: 'base')!
	r.add_nodejsbuilder()!

	r.build(args.reset)!
}