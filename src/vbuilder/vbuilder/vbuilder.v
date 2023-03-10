module vbuilder

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.base

pub fn build(args docker.BuildArgs)!{

	//make sure dependency has been build
	base.build(reset:args.reset, strict:args.strict)!

	mut engine := docker.new()!

	//specify we want to build an alpine version
	mut r:=engine.recipe_new(name:"vbuilder",platform:.alpine)

	r.add_from(image:"base")!
	r.add_vbuilder()!
	
	r.build(args.reset)!

}






