module base

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.core.base0

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine
	
	println(" - build base: reset:$args.reset")

	// make sure dependency has been build
	base0.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'base', platform: .alpine)

	r.add_from(image: 'base0')!
	r.add_zinit()!
	r.build(args.reset)!
}
