module base

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.base0

pub fn build(args docker.BuildArgs) ! {
	// make sure dependency has been build
	base0.build(reset: args.reset, strict: args.strict)!

	mut engine := docker.new()!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'base', platform: .alpine)

	r.add_from(image: 'base0')!
	r.add_zinit()!
	r.build(args.reset)!
}
