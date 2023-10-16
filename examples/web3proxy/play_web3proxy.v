
module main


import freeflowuniverse.crystallib.osal.docker

import threefoldtech.builders.play.web3proxy



fn do() ! {

	dockerregistry_datapath:=""
	// dockerregistry_datapath:="/Volumes/FAST/DOCKERHUB"
	// prefix:="despiegk/" //dont forget trailing slash
	prefix:=""
	reset:=false
	localonly:=false

	mut engine := docker.new(prefix:prefix,localonly:localonly)!

	if dockerregistry_datapath.len>0{
		engine.registry_add(datapath:dockerregistry_datapath)! //this means we run one locally
	}
	
	if reset{
		//TODO: prob better to only remove what is relevant to building
		engine.reset_all()!
	}

	
	web3proxy.build(engine:&engine,reset:true)!

}

fn main() {

	do() or { panic(err) }
}
