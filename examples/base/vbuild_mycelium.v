
module main


import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.mycelium

fn do() ! {
	dockerregistry_datapath:=""
	// dockerregistry_datapath:="/Volumes/FAST/DOCKERHUB"
	// prefix:="despiegk/" //dont forget trailing slash
	prefix:=""
	localonly:=false

	mut engine := docker.new(prefix:prefix,localonly:localonly)!

	if dockerregistry_datapath.len>0{
		engine.registry_add(datapath:dockerregistry_datapath)! //this means we run one locally
	}
	

	
	mycelium.build(engine:&engine,reset:false)!
}

fn main() {
	do() or { panic(err) }
}
