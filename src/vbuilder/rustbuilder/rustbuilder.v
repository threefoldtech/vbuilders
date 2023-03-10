module rustbuilder

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.rust0

pub fn build(args docker.BuildArgs)!{

	//make sure dependency has been build
	rust0.build(reset:args.reset, strict:args.strict)!

	mut engine := docker.new()!

	//specify we want to build an alpine version
	mut r:=engine.recipe_new(name:"rustbuilder",platform:.alpine)

	r.add_from(image:"rust0")!

	r.add_zinit()!

	r.build(args.reset)!

}


