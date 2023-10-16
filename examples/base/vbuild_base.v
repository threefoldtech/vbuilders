
module main


import threefoldtech.builders

fn do() ! {

	// dockerregistry_datapath:="/Volumes/FAST/DOCKERREGISTRY"
	dockerregistry_datapath:=""
	// prefix:="despiegk/" //dont forget trailing slash
	prefix:=""
	reset:=false


	mut ub:=builders.new(dockerregistry_datapath:dockerregistry_datapath,prefix:prefix)!
	
	ub.build_base(reset:reset)!	

}

fn main() {

	do() or { panic(err) }
}
