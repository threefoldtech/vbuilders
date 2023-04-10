
module main


import freeflowuniverse.crystallib.docker

import threefoldtech.builders.play.goca



fn do() ! {

	dockerregistry_datapath:=""
	// dockerregistry_datapath:="/Volumes/FAST/DOCKERHUB"
	// prefix:="despiegk/" //dont forget trailing slash
	prefix:=""
	reset:=true
	localonly:=false

	mut engine := docker.new(prefix:prefix,localonly:localonly)!

	if dockerregistry_datapath.len>0{
		engine.registry_add(datapath:dockerregistry_datapath)! //this means we run one locally
	}
	
	if reset{
		//TODO: prob better to only remove what is relevant to building
		engine.reset_all()!
	}

	
	goca.build(engine:&engine,reset:false)!

}

fn main() {

	do() or { panic(err) }
}
